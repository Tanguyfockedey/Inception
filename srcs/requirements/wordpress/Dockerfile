FROM alpine:3.21

# Install dependencies
RUN apk update
RUN apk upgrade
#RUN apk add vim
RUN apk add php-fpm

COPY ./conf/www.conf /etc/php83/php-fpm.d/www.conf

CMD ["php-fpm83", "-F"]
