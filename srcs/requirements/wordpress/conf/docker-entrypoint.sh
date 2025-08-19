#!/bin/sh
set -e

mkdir -p /var/www/html
cd /var/www/html
curl -LO https://wordpress.org/latest.zip
unzip -n latest.zip
rm -f latest.zip

# Fix permissions for the worpress directory
#chown -R www-data:www-data /var/www/html
chmod -R 777 /var/www/html

exec "$@"