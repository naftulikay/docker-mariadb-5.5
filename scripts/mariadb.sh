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

# startup mariadb as user 'mysql' with the given timezone
setuser mysql mysqld --defaults-file=/config/my.cnf
