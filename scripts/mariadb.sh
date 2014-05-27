#!/bin/bash

# if something fails, exit 
set -e

# if this is the first run, execute the first run script and then 
# remove it.
if [ -f "/sbin/mariadb-first-run" ]; then
    /sbin/mariadb-first-run && rm /sbin/mariadb-first-run
fi

# startup mariadb as user 'mysql' with the given timezone
setuser mysql mysqld --defaults-file=/config/my.cnf
