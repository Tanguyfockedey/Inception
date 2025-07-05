FROM alpine:3.21

# Install dependencies
RUN apk update
RUN apk upgrade
#RUN apk add vim
RUN apk add mariadb

# MariaDB configuration
RUN mkdir -p /var/lib/mysql
COPY conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY conf/mariadb-init.sh /docker-entrypoint-initdb.d/mariadb-init.sh
RUN chmod +x /docker-entrypoint-initdb.d/mariadb-init.sh
#RUN /docker-entrypoint-initdb.d/mariadb-init.sh