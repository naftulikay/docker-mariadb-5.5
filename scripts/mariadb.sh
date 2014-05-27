#!/bin/bash

# if something fails, exit 
set -e

# if there's no defined timezone, use UTC
if [ -z "$MYSQL_TIMEZONE" ]; then
    MYSQL_TIMEZONE="GMT"
fi

# if this is the first run, execute the first run script and then 
# remove it.
if [ -f "/usr/local/bin/mariadb-first-run" ]; then
    /usr/local/bin/mariadb-first-run && \
        rm /usr/local/bin/mariadb-first-run
fi

# startup mariadb as user 'mysql' with the given timezone
sudo -u mysql mysqld_safe --timezone="$MYSQL_TIMEZONE"
