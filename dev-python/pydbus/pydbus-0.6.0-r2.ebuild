# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Retrieve from https://github.com/jorgicio/jorgicio-gentoo-overlay

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..13} )

inherit distutils-r1 pypi

DESCRIPTION="Pythonic DBus library"
HOMEPAGE="https://github.com/LEW21/pydbus"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/LEW21/${PN}.git"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="$(pypi_sdist_url "${PN^}" "${PV}")"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2+"
SLOT="0"
IUSE=""

# DEPEND="${PYTHON_DEPS}
# 	dev-python/setuptools[${PYTHON_USEDEP}]
# "

RDEPEND="${DEPEND}
	dev-python/pygobject:3[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}"
