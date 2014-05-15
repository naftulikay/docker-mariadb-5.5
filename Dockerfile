FROM ubuntu:precise
MAINTAINER Naftuli Tzvi Kay <rfkrocktk@gmail.com>

# Ensure everything is UTF-8, because there's no reason in the world why not.
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8 
RUN locale-gen en_US.UTF-8

# Install MariaDB PPA
ADD conf/apt/mariadb.list /etc/apt/sources.list.d/mariadb.list
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db \
     && apt-get update -q 2 \
     && DEBIAN_FRONTEND=noninteractive apt-get install -q 2 -y mariadb-server pwgen

# Lock Down MariaDB for Production

# Generate root password

# Run MariaDB as the 'mysql' User
USER mysql

# Mount Shared Volumes
VOLUME ["/etc/mysql/"]
VOLUME ["/var/lib/mysql"]
VOLUME ["/var/log"]

# Expose TCP Port 3306
EXPOSE 3306
