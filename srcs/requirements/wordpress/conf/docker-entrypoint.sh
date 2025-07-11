#!/bin/sh
set -e

mkdir /var/www
mkdir /var/www/html
cd /var/www/html
curl -O https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz
tar -xzf wordpress-6.0-fr_FR.tar.gz
rm wordpress-6.0-fr_FR.tar.gz
chmod 777 -R wordpress
