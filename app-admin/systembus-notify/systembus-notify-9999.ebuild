# Copyright 2025 Jérôme
# Distributed under the terms of the MIT License

EAPI=8

inherit git-r3 toolchain-funcs

DESCRIPTION="Tiny daemon that shows system bus D-Bus signals as desktop notifications"
HOMEPAGE="https://github.com/rfjakob/systembus-notify"
EGIT_REPO_URI="https://github.com/rfjakob/systembus-notify.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

# elogind fournit sd-bus sans systemd. Le Makefile détecte libelogind via pkg-config
# et l'utilise automatiquement à la place de libsystemd. Sur OpenRC + Plasma, elogind
# est déjà présent (Plasma en dépend).
RDEPEND="
	sys-auth/elogind
	sys-apps/dbus
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_compile() {
	# Le Makefile fait 'CFLAGS +=' (ajoute à nos flags, ne les écrase pas) et détecte
	# libelogind tout seul. On passe juste le bon compilateur.
	emake CC="$(tc-getCC)"
}

src_install() {
	# PAS 'make install' upstream (il installe dans ${HOME}, incompatible Portage).
	# Binaire system-wide :
	dobin systembus-notify

	# Autostart XDG global (lu par Plasma au démarrage de session, tous users) :
	insinto /etc/xdg/autostart
	doins systembus-notify.desktop

	dodoc README.md
}

pkg_postinst() {
	elog "systembus-notify se lance au démarrage de session (autostart XDG)."
	elog "Pour l'activer maintenant sans relancer la session :"
	elog "    systembus-notify &"
	elog ""
	elog "Test d'une notification depuis root/un service :"
	elog "    dbus-send --system --type=signal / \\"
	elog "        net.nuetzlich.SystemNotifications.Notify \\"
	elog "        'string:Titre' 'string:Corps du message'"
}
