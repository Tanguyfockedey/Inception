#!/bin/sh
set -e

# Load environment variables from secrets
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_PASSWORD=$(cat /run/secrets/db_password)

# Initialize DB if empty
if [ ! -d /var/lib/mysql/mysql ]; then
    mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

# Start MariaDB server in the background
mysqld_safe

# Set root password
mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';"

# Remove anonymous users
mariadb -u root -e "DELETE FROM mysql.user WHERE User='';"

# Disallow remote root login
mariadb -u root -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"

# Remove test database
mariadb -u root -e "DROP DATABASE IF EXISTS test;"
mariadb -u root -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"

# Flush privileges
mariadb -u root -e "FLUSH PRIVILEGES;"

# Create the specified database
mariadb -u root -p"$DB_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS '$DB';"

# Create a user and grant privileges
mariadb -u root -p"$DB_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
mariadb -u root -p"$DB_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $DB.* TO '$DB_USER'@'localhost';"
mariadb -u root -p"$DB_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

# Stop the MariaDB server
mariadb -u root -p"$DB_ROOT_PASSWORD" shutdown

exec "$@"
