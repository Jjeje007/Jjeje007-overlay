# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Retrieve from https://github.com/jorgicio/jorgicio-gentoo-overlay

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="Simple pythonic wrapper around inotify"
HOMEPAGE="https://github.com/chrisjbillington/inotify_simple"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2+"
SLOT="0"
IUSE=""

DEPEND="${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
 
