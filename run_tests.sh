#!/usr/bin/env sh
set -eo pipefail

# Test files exist
test -f /usr/local/bin/ddns53.sh
test -f /etc/periodic/15min/ddns53

# Test file permissions
$([ $(stat -c %a /usr/local/bin/ddns53.sh) -eq 755 ] && exit 0 || exit 1)
$([ $(stat -c %a /etc/periodic/15min/ddns53) -eq 777 ] && exit 0 || exit 1)

# Test environment variables
test -n "${AWS_DEFAULT_REGION}"
test -n "${AWS_DEFAULT_OUTPUT}"

# Test crond is running
ps | grep [c]rond &>/dev/null