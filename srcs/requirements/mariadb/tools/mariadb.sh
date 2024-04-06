#!/bin/bash

#set -e #if something went wrong exit the script

#mysql_install_db #initializes the MySQL data directory and creates the system tables that it contains, if they do not exist

if [ $(mysql -h "$MYSQL_HOSTNAME" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "USE wordpress; SHOW TABLES;" | wc -l) -gt 0 ]; then
    echo "Database already exists, NOT creating"
else
    sudo mysql_install_db
fi

sudo /etc/init.d/mariadb start

if [ -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
	echo "Database already exists, copying wordpress.sql.. "
    mysqldump -u $MYSQL_USER -p $MYSQL_DATABASE > /usr/local/bin/wordpress.sql
    mysql -uroot -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < /usr/local/bin/wordpress.sql
else

    #Add a root user on 127.0.0.1 to allow remote connexion 
#Flush privileges allow to your sql tables to be updated automatically when you modify it
#mysql -uroot launch mysql command line client
    echo "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; FLUSH PRIVILEGES;" | mysql -uroot

#Create database and user in the database for wordpress

    echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE; GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'; FLUSH PRIVILEGES;" | mysql -u root

    #echo "SET GLOBAL connect_timeout = 10;" | mysql -uroot

    #mysql_secure_installation << echo $MYSQL_ROOT_PASSWORD
    mysql -uroot -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < /usr/local/bin/wordpress.sql


fi

sudo /etc/init.d/mariadb stop

exec "$@"