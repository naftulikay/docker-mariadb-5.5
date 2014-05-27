#!/bin/bash

# if something fails, exit 
set -e

# if there's no defined timezone, use UTC
if [ -z "$MYSQL_TIMEZONE" ]; then
    MYSQL_TIMEZONE="GMT"
fi

# if this is the first run, execute the first run script and then 
# remove it.
if [ -f "/sbin/mariadb-first-run" ]; then
    echo "First run, calling."
    /sbin/mariadb-first-run && rm /sbin/mariadb-first-run
    echo "Done"
fi

echo "Starting mysqld"

# startup mariadb as user 'mysql' with the given timezone
/sbin/setuser mysql mysqld --default-time-zone="$MYSQL_TIMEZONE" \
    --defaults-file=/config/my.cnf
