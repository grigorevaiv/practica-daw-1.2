#!/bin/bash
set -ex

source .env

rm -rf /tmp/iaw-practica-lamp

git clone https://github.com/josejuansanchez/iaw-practica-lamp /tmp/iaw-practica-lamp

mv /tmp/iaw-practica-lamp/src/* /var/www/html

mysql -u root <<< "DROP DATABASE IF EXISTS $DB_NAME"

mysql -u root <<< "CREATE DATABASE $DB_NAME"

mysql -u root <<< "DROP USER IF EXISTS '$DB_USER'@'%'"

mysql -u root <<< "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD'"

mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%'"

#configuring config.php
sed -i "s/database_name_here/$DB_NAME/" /var/www/html/config.php


sed -i "s/username_here/$DB_USER/" /var/www/html/config.php

sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/config.php

#configuring dbsql
sed -i "s/lamp_db/$DB_NAME/" /tmp/iaw-practica-lamp/db/database.sql

mysql -u root < /tmp/iaw-practica-lamp/db/database.sql

