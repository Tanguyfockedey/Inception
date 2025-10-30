#!/bin/sh
set -e

echo "Starting docker-entrypoint.sh for MariaDB"

# Load environment variables from secrets
echo "Loading environment variables from secrets..."
export DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
export DB_PASSWORD=$(cat /run/secrets/db_password)

# Initialize DB if empty
echo "Checking if database is initialized..."
if [ ! -d /var/lib/mysql/${DB} ]; then
    mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

# Start MariaDB in background
echo "Starting temporary MariaDB server..."
mariadbd-safe --skip-networking &
pid="$!"

# Wait for MariaDB to start
until mariadb-admin ping --silent; do
    sleep 1
done
echo "Waiting for MariaDB to start..."

# Secure MariaDB installation
echo "Securing MariaDB installation..."

# Set root password
echo "Setting root password..."
mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';"

# Remove anonymous users
echo "Removing anonymous users..."
mariadb -u root -p"$DB_ROOT_PASSWORD" -e "DELETE FROM mysql.user WHERE User='';"

# Disallow remote root login
echo "Disallowing remote root login..."
mariadb -u root -p"$DB_ROOT_PASSWORD" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"

# Remove test database
echo "Removing test database..."
mariadb -u root -p"$DB_ROOT_PASSWORD" -e "DROP DATABASE IF EXISTS test;"
mariadb -u root -p"$DB_ROOT_PASSWORD" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"

# Flush privileges
echo "Flushing privileges..."
mariadb -u root -p"$DB_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

# Create the specified database
echo "Creating database..."
mariadb -u root -p"$DB_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $DB;"

# Create a user and grant privileges
echo "Creating user and granting privileges..."
mariadb -u root -p"$DB_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
mariadb -u root -p"$DB_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $DB.* TO '$DB_USER'@'%';"
mariadb -u root -p"$DB_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

# Stop the temporary MariaDB server
echo "Stopping temporary MariaDB server..."
mariadb-admin -u root -p"${DB_ROOT_PASSWORD}" shutdown

# Wait for the background process to finish
wait "$pid"
fi

# Finally, exec main process (MariaDB server)
echo "Starting MariaDB server..."
exec "$@"
