# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Retrieve from https://github.com/jorgicio/jorgicio-gentoo-overlay

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1 pypi

DESCRIPTION="Simple pythonic wrapper around inotify"
HOMEPAGE="https://github.com/chrisjbillington/inotify_simple"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="$(pypi_sdist_url "${PN^}" "${PV}")"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2+"
SLOT="0"
IUSE=""

DEPEND="${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
 
