# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Must be set before inheriting distutils-r1: the eclass reads it at inherit
# time to pick the build backend. 'setuptools' matches the build-system
# declared in pyproject.toml.
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 git-r3

DESCRIPTION="GIt KErnel Updater Daemon: watches a kernel git repo for updates"
HOMEPAGE="https://github.com/Jjeje007/gikeud"
EGIT_REPO_URI="https://github.com/Jjeje007/gikeud.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""

RDEPEND="
	${PYTHON_DEPS}
	acct-group/gikeud
	acct-user/gikeud
	app-admin/sudo
	dev-python/gitpython[${PYTHON_USEDEP}]
	dev-python/babel[${PYTHON_USEDEP}]
	dev-python/inotify_simple[${PYTHON_USEDEP}]
	dev-python/dbus-fast[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-vcs/git
"
DEPEND="${RDEPEND}"

src_install() {
	distutils-r1_src_install

	# Everything below comes from the source tree, not from FILESDIR: the
	# packaging files belong to the project, so it stays installable by hand
	# or on a non-Gentoo system. See config/README.md upstream.
	newinitd config/gikeud.initd gikeud
	newconfd config/gikeud.confd gikeud

	# The D-Bus policy. It grants the name to user gikeud, not root: the
	# daemon could not claim it otherwise once it stopped running as root.
	insinto /usr/share/dbus-1/system.d
	doins config/gikeud-dbus.conf

	# The privileged helper. gikeud may run it through sudo but must never be
	# able to modify it: that is what makes the NOPASSWD rule below safe.
	# Hence root:root and no write bit for anyone else.
	exeinto /usr/bin
	doexe config/gikeud-sync
	fowners root:root /usr/bin/gikeud-sync
	fperms 0755 /usr/bin/gikeud-sync

	# sudo refuses to read anything looser than 0440 here.
	insinto /etc/sudoers.d
	newins config/gikeud.sudoers gikeud
	fowners root:root /etc/sudoers.d/gikeud
	fperms 0440 /etc/sudoers.d/gikeud

	# Logs belong to the daemon user, which is why this ebuild and the
	# privilege drop had to be done together: the ownership here depends on
	# who runs the daemon.
	# /var/lib/gikeud is not created here -- it is the user's home, so
	# acct-user/gikeud owns that decision.
	keepdir /var/log/gikeud
	fowners gikeud:gikeud /var/log/gikeud
	fperms 0750 /var/log/gikeud
}

pkg_postinst() {
	elog "The kernel repository path is set in /etc/conf.d/gikeud"
	elog "(GIKEUD_REPO). Both the daemon and /usr/bin/gikeud-sync read it"
	elog "from there, so they cannot drift apart."
	elog ""
	elog "gikeud runs as its own user and updates the repository through"
	elog "sudo, using a fixed wrapper. Check that it works before enabling"
	elog "the service:"
	elog ""
	elog "    sudo -u gikeud sudo -n /usr/bin/gikeud-sync"
	elog ""
	elog "The repository stays owned by root: your own git checkouts and"
	elog "kernel builds are unaffected."
	elog ""

	# ewarn rather than elog: this is not optional. Without it the daemon
	# starts, runs and reports no error, while never detecting a single
	# kernel version -- a failure mode quiet enough to go unnoticed for
	# weeks.
	ewarn "git refuses a repository owned by another user since 2.35.5, so"
	ewarn "the daemon cannot read a single tag until it is declared safe."
	ewarn "This is left to you rather than done here, since it edits"
	ewarn "/etc/gitconfig:"
	ewarn ""
	ewarn "    git config --system --add safe.directory ${EPREFIX}/usr/src/zen-kernel"
	ewarn ""
	ewarn "Adjust the path if GIKEUD_REPO points elsewhere. --system rather"
	ewarn "than --global on purpose: OpenRC does not guarantee a HOME for"
	ewarn "the service user, so a per-user setting would be unreliable."
	ewarn ""
	ewarn "Skipping this does not crash anything, which is what makes it"
	ewarn "easy to miss: pulling still works, since the wrapper runs as"
	ewarn "root. Only the reads fail, so the repository keeps updating"
	ewarn "while no kernel version is ever reported. Look for 'detected"
	ewarn "dubious ownership' in the logs if that happens."
}
