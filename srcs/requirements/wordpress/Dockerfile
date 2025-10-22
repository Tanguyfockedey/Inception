FROM alpine:3.21

# Install dependencies
RUN apk add --no-cache \
	mariadb-client \
	php83 \
	php83-fpm \
	php83-mysqli \
	php83-phar \
	php83-mbstring \
	php83-iconv \
	curl

# PHP configuration
COPY ./conf/www.conf /etc/php83/php-fpm.d/www.conf

# WordPress installation
COPY ./conf/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

# Run in docker compose
CMD ["php-fpm83", "-F"]
