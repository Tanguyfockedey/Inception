FROM alpine:3.21

# Install dependencies
RUN apk add --no-cache \
	mariadb \
	mariadb-client

# MariaDB configuration
COPY conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld
RUN mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql && chmod 755 /var/lib/mysql

COPY conf/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["mariadbd", "--user=mysql"]
