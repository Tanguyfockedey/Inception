service mysql start;
mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${SQL_DATABASE};"
mysql -u root -e "CREATE USER IF NOT EXISTS '${SQL_USER}'@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -u root -e "GRANT ALL PRIVILEGES ON '${SQL_DATABASE}.* TO '${SQL_USER}'@'localhost';"
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
mysql -u root -e "FLUSH PRIVILEGES;"
mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown;
exec mariadb_safe;
