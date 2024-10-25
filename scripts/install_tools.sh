#!/bin/bash

# install phpmyadmin
source .env

mkdir -p /var/www/html/adminer

wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-mysql.php -P /var/www/html/adminer

mv /var/www/html/adminer/adminer-4.8.1-mysql.php /var/www/html/adminer/index.php

mysql -u root <<< "DROP DATABASE IF EXISTS $DB_NAME"

mysql -u root <<< "CREATE DATABASE $DB_NAME"

mysql -u root <<< "DROP USER IF EXISTS '$DB_USER'@'%'"

mysql -u root <<< "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD'"

mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%'"

sudo apt install goaccess -y

mkdir -p /var/www/html/stats

goaccess /var/log/apache2/access.log -o /var/www/html/stats/index.html --log-format=COMBINED --real-time-html --daemonize

cp ../conf/000-default-stats.conf /etc/apache2/sites-available

a2dissite 000-default.conf

a2ensite 000-default-stats.conf

systemctl reload apache2

sudo htpasswd -bc /etc/apache2/.htpasswd $STATS_USERNAME $STATS_PASSWORD

cp ../conf/000-default-htaccess.conf /etc/apache2/sites-available

a2dissite 000-default-stats.conf

a2ensite 000-default-htaccess.conf

systemctl reload apache2

cp ../htaccess/.htaccess /var/www/html/stats