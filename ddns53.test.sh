#!/usr/bin/env sh
set -eo pipefail

# Test files exist
printf "Test files exist..."
test -f /usr/local/bin/ddns53.sh
test -f /etc/periodic/15min/ddns53
printf "ok\n"

# Test file permissions
printf "Test file permissions..."
$([ $(stat -c %a /usr/local/bin/ddns53.sh) -eq 755 ] && exit 0 || exit 1)
$([ $(stat -c %a /etc/periodic/15min/ddns53) -eq 777 ] && exit 0 || exit 1)
printf "ok\n"

# Test environment variables
printf "Test environment variables..."
test -n "${AWS_DEFAULT_REGION}"
test -n "${AWS_DEFAULT_OUTPUT}"
printf "ok\n"
