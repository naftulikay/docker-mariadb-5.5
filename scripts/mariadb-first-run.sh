#!/bin/bash

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
    echo "For security reasons, please log into MySQL and change this password \
        immediately."
else
    echo "Using user-defined password for the MySQL root account."
fi

# set the mysql root password

