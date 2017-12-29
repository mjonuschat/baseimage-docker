#!/bin/sh
set -e

## Upgrade all packages
apk --update --no-cache upgrade

apk add --update --no-cache curl less vim psmisc tzdata
ln -nfs /usr/share/zoneinfo/GMT /etc/localtime

curl -ssL -o /tmp/s6-overlay-amd64.tar.gz https://github.com/just-containers/s6-overlay/releases/download/v1.21.2.2/s6-overlay-amd64.tar.gz
tar -xz -C / -f /tmp/s6-overlay-amd64.tar.gz

# Cron
install -D -m 0755 /build/services/cron/cron.s6 /etc/services.d/cron/run

# Syslog
apk add --update --no-cache syslog-ng
install -D -m 0755 /build/services/syslog-ng/syslog-ng.s6 /etc/services.d/syslog-ng/run
install -D -m 0644 /build/services/syslog-ng/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf
mkdir -p /var/lib/syslog-ng
touch /var/log/syslog
chmod u=rw,g=r,o= /var/log/syslog

# Syslog to "docker logs" forwarder.
install -D -m 0755 /build/services/syslog-ng/syslog-forwarder.s6 /etc/services.d/syslog-forwarder/run

# Logrotate
apk add --update --no-cache syslog-ng
install -D -m 0644 /build/services/syslog-ng/logrotate.conf /etc/logrotate.conf
install -D -m 0644 /build/services/syslog-ng/logrotate_syslogng /etc/logrotate.d/syslog-ng

# Cleanup
rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /build
