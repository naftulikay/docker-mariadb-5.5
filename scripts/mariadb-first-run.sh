#!/bin/bash

# fail on any error
set -e

# If the user has not defined a specific password they'd prefer to use for the
# MySQL root account, generate a 32 digit random new password using the following
# options:
#   -s: Generate completely random passwords
#   -n: Include at least one number in the password
#   -B: Don't include ambiguous characters in the password
#   -c: Include at least one capital letter in the password

if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
    export MYSQL_ROOT_PASSWORD="$(pwgen -snBc 32 1)"
    # log the newly generated MySQL root password to the Docker logs so the user
    # can look it up for initial provisioning of the server
    echo "Generated MySQL Root Password: \"$MYSQL_ROOT_PASSWORD\""
    echo "For security reasons, please log into MySQL and change this password immediately."
else
    echo "Using user-defined password for the MySQL root account."
fi

# start mysql in background to be able to run the following SQL
mysqld >/dev/null 2>&1 & 

while [[ ! -S /var/run/mysqld/mysqld.sock ]]; do
    # wait for mysql to start, ie, wait for it to bind to the unix socket
    inotifywait -qq -e create /var/run/mysqld/
done

# set the mysql root password
mysqladmin -u root password "$MYSQL_ROOT_PASSWORD"

# modify root user to allow access to external hosts, only because Docker networking
# makes everything look remote to all containers. if the user sets MYSQL_SECURE_ROOT,
# then the root account will only have access from the local Docker container. for
# most people, this will be annoying, but some people accept this and would rather
# provision MySQL users from within the Docker container. to each his own.
if [ -z "$MYSQL_SECURE_ROOT" ]; then
    echo "Allowing remote access to the MySQL root account."
    echo "Provision your MySQL users, then remove external login to the root account to ensure optimal security."
    
    echo 'update user set Host = "%" where User = "root" limit 1;' | mysql -u root \
        --password="$MYSQL_ROOT_PASSWORD" mysql

    echo 'delete from user where User = "root" and Host != "%";' | mysql -u root \
        --password="$MYSQL_ROOT_PASSWORD" mysql
else
    echo "The root account ONLY has access from the local Docker container."
    echo "Login from outside of the Docker container WILL FAIL."
fi

# stop mysql
killall -w -s SIGTERM mysqld

# all was successful, remove pwgen and inotify-tools
apt-get remove --yes -q 2 pwgen inotify-tools >/dev/null 2>&1

# all done
exit 0
