#!/bin/bash
set -e

# Start sshd
/usr/sbin/sshd

# Start apache2
/usr/sbin/apachectl -D FOREGROUND

exec /bin/bash