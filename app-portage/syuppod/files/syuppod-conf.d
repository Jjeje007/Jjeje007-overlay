# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# The syuppod daemon executable
SYUPPOD_EXEC="/usr/bin/syuppod"

# Options passed to the daemon (see 'syuppod --help').
#
# Logging (default level: info, to the system log)
#   -d, --debug           also write debug messages to /var/log/syuppod/debug.log
#   -q, --quiet           errors only
#
# Portage
#   -s, --sync <int>      interval between two syncs of the repositories:
#                         1w = 1 week, 1d = 1 day, 1h = 1 hour, can be
#                         combined (1d12h, 1w2d1h...). Minimum and default: 1d.
#
# Advanced debug -- needs --debug, and writes A LOT. One module at a time,
# while looking into something, then remove it again. Put it last: it takes
# every name that follows it.
#   --vdebug <m> [<m>...] with <m> among:
#       logparser         last world update parser
#       logparserlines    logparser, plus every emerge.log line it reads
#                         (about 3 000 lines each time it runs)
#       formattimestamp   time formatting
#       durations         every build recorded in the durations database
#                         (all of them, some 47 000, when it is rebuilt)
#       procrunning       every process looked at when searching for a
#                         world, system, sync or portage emerge (about 20
#                         lines per process, at each check)
#
# Not for the service, terminal only:
#   --dryrun              writes nothing (state file, logs)
#   --nodbus              no dbus service: syuppoc and the desktop panel
#                         get nothing
#
# Examples:
#   SYUPPOD_OPTS="-d"
#   SYUPPOD_OPTS="-d -s 1d12h"
#   SYUPPOD_OPTS="-d --vdebug durations"
SYUPPOD_OPTS="-d"
