#!/bin/sh
set -e

log() { echo "[$(date +'%F %T')] $*"; }
log "Starting docker-entrypoint.sh for MariaDB"

# Load environment variables from secrets
log "Loading environment variables from secrets..."
export DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
export DB_PASSWORD=$(cat /run/secrets/db_password)

# Initialize DB if empty
log "Checking if database is initialized..."
if [ ! -d /var/lib/mysql/${DB} ]; then
    mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

# Start MariaDB in background
log "Starting temporary MariaDB server..."
mariadbd-safe --skip-networking &
pid="$!"

# Wait for MariaDB to start
until mariadb-admin ping --silent; do
    sleep 1
done
log "Waiting for MariaDB to start..."

# Secure MariaDB installation
log "Securing MariaDB installation..."

# Set root password
log "Setting root password..."
mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';"

# Remove anonymous users
log "Removing anonymous users..."
mariadb -u root -p"$DB_ROOT_PASSWORD" -e "DELETE FROM mysql.user WHERE User='';"

# Disallow remote root login
log "Disallowing remote root login..."
mariadb -u root -p"$DB_ROOT_PASSWORD" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"

# Remove test database
log "Removing test database..."
mariadb -u root -p"$DB_ROOT_PASSWORD" -e "DROP DATABASE IF EXISTS test;"
mariadb -u root -p"$DB_ROOT_PASSWORD" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"

# Flush privileges
log "Flushing privileges..."
mariadb -u root -p"$DB_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

# Create the specified database
log "Creating database..."
mariadb -u root -p"$DB_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $DB;"

# Create a user and grant privileges
log "Creating user and granting privileges..."
mariadb -u root -p"$DB_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
mariadb -u root -p"$DB_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $DB.* TO '$DB_USER'@'%';"
mariadb -u root -p"$DB_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

# Stop the temporary MariaDB server
log "Stopping temporary MariaDB server..."
mariadb-admin -u root -p"${DB_ROOT_PASSWORD}" shutdown

# Wait for the background process to finish
wait "$pid"
fi

# Finally, exec main process (MariaDB server)
log "Starting MariaDB server..."
exec "$@"
