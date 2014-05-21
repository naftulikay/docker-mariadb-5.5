FROM ubuntu:precise
MAINTAINER Naftuli Tzvi Kay <rfkrocktk@gmail.com>

# Ensure everything is UTF-8, because there's no reason in the world why not.
ENV LANG en_US.UTF-8
#ENV LC_ALL en_US.UTF-8 # gives a warning to stderr :( 
RUN locale-gen en_US.UTF-8

# Install MariaDB PPA
ADD conf/apt/mariadb.list /etc/apt/sources.list.d/mariadb.list
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db \
     && apt-get update -q 2 \
     && DEBIAN_FRONTEND=noninteractive apt-get install --yes -q 2 mariadb-server sudo pwgen \
            inotify-tools 

# Run Initial Setup
ADD scripts/mariadb-first-run.sh /usr/local/bin/mariadb-first-run
ADD scripts/mariadb-startup.sh /usr/local/bin/mariadb

RUN chmod +x /usr/local/bin/mariadb-first-run \
    /usr/local/bin/mariadb

# Mount Shared Volumes
VOLUME ["/etc/mysql/"] # configuration files
VOLUME ["/var/lib/mysql"] # database files
VOLUME ["/var/run/mysql"] # unix socket
VOLUME ["/var/log"] # log files

# Expose TCP Port 3306
EXPOSE 3306

# Set Main Command
CMD ["/usr/local/bin/mariadb"]
