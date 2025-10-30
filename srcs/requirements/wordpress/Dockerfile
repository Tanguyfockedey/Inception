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
	php83-gd \
	php83-curl \
	php83-dom \
	php83-exif \
	php83-fileinfo \
	php83-zip \
	php83-intl \
	php83-pecl-imagick \
	curl

# PHP configuration
COPY ./conf/www.conf /etc/php83/php-fpm.d/www.conf

# WordPress installation
COPY ./conf/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

# Run in docker compose
CMD ["php-fpm83", "-F"]
