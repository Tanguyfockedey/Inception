#!/bin/sh
set -e

echo "Starting docker-entrypoint.sh for WordPress..."

# addgroup -S www-data
adduser -S -G www-data www-data

export DB_PASSWORD=$(cat /run/secrets/db_password)
export WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
export WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

mkdir -p /var/www/html
cd /var/www/html

# Download WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

echo "Waiting for MariaDB..."
until mysql -hmariadb -u"$DB_USER" -p"$DB_PASSWORD" -e "SELECT 1" >/dev/null 2>&1; do
	sleep 1
done

if [ ! -f wp-config.php ]; then
	echo "Downloading WordPress..."
	php -d memory_limit=512M /usr/local/bin/wp core download --allow-root --locale=en_US

	echo "Creating custom wp-config.php..."
	wp config create --allow-root --dbname=$DB --dbuser=$DB_USER --dbpass=$DB_PASSWORD --dbhost=mariadb

	# # Enable WP debug logging
	# wp config set WP_DEBUG true --raw --allow-root
	# wp config set WP_DEBUG_LOG true --raw --allow-root
	# wp config set WP_DEBUG_DISPLAY false --raw --allow-root

	# wp option update siteurl "https://localhost:4343" --allow-root --path=/var/www/html
	# wp option update home "https://localhost:4343" --allow-root --path=/var/www/html

	# echo "if (isset(\$_SERVER['HTTP_X_FORWARDED_PROTO']) && \$_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {\$_SERVER['HTTPS'] = 'on';}" >> /var/www/html/wp-config.php

	echo "Installing WordPress..."
	wp core install --allow-root --url=$DOMAIN --title="Inception" --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASSWORD --admin_email="admin@admin.com"

	echo "Creating additional user..."
	wp user create --allow-root $WP_USER "author@author.com" --user_pass=$WP_USER_PASSWORD --role=author

fi
# Fix permissions for the worpress directory
chown -R www-data:www-data /var/www/html
chmod -R 777 /var/www/html

exec "$@"