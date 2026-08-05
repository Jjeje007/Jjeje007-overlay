# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for the gikeud daemon"

# See the group ebuild for why this is -1 rather than a fixed number.
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( "gikeud" )

# The daemon keeps its state file here, so it is both the home and the
# working directory. Ownership and permissions are set by the gikeu ebuild,
# which also creates /var/log/gikeud alongside it.
ACCT_USER_HOME="/var/lib/gikeud"
ACCT_USER_HOME_OWNER="gikeud:gikeud"
ACCT_USER_HOME_PERMS=0750

# Nothing ever logs in as this user: it only exists to run the daemon and to
# be the subject of the sudoers rule.
ACCT_USER_SHELL=/sbin/nologin

acct-user_add_deps
