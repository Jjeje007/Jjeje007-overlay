# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PLOCALES="fr en"
PLOCALE_BACKUP="en"

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
EGIT_REPO_URI="https://github.com/Jjeje007/${PN}.git"

inherit distutils-r1 git-r3 plocale


DESCRIPTION="Syuppod is a python3 daemon which automate sync and calculate how many packages to update
            for gentoo portage manager. His client (syuppoc) retrieve these informations over dbus."
HOMEPAGE="https://github.com/Jjeje007/syuppod"
SRC_URI=""


LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
    >=sys-apps/portage-3.0.4[${PYTHON_USEDEP}]
    >=dev-python/pydbus-0.6.0[${PYTHON_USEDEP}]
    dev-python/numpy[${PYTHON_USEDEP}]
    dev-python/pexpect[${PYTHON_USEDEP}]
    >=dev-python/inotify_simple-1.3.3[${PYTHON_USEDEP}]
    sys-apps/dbus
    acct-user/syuppod
    acct-group/syuppod
"

DEPEND="${RDEPEND}"

python_install_all() {
    distutils-r1_python_install_all
    
    newconfd "${FILESDIR}"/syuppod-conf.d syuppod
    newinitd "${FILESDIR}"/syuppod-init syuppod
    
    insinto /usr/share/dbus-1/system.d
    doins "${FILESDIR}"/syuppod-dbus.conf
    
    insinto /etc/sudoers.d
    newins "${FILESDIR}"/syuppod-sudoers syuppod
    
    # Make sure perm is 0440 otherwise it will not work
    fperms 0440 /etc/sudoers.d/syuppod
    
    keepdir /var/log/syuppod
    keepdir /var/lib/syuppod
    
    fowners syuppod:syuppod /var/log/syuppod
    fowners syuppod:syuppod /var/lib/syuppod
    
    # Install Internationalization
    install_locale() {
        insinto /usr/share/locale/"${1}"/LC_MESSAGES/
        doins "${S}"/syuppo/locale/"${1}"/LC_MESSAGES/syuppoc.mo
    }
    
    plocale_for_each_locale install_locale    
}


