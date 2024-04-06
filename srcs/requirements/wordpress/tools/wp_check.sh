#!/bin/bash

if [ -f "./wp-config.php" ]; then
    echo "Wordpress is installed"
else
    echo "Wordpress configuration start.. "

   wget http://wordpress.org/latest.tar.gz
	tar xfz latest.tar.gz
	mv -f wordpress/* .
	rm -rf latest.tar.gz
	rm -rf wordpress


	#Inport env variables in the config file
	sed -i "s/username_here/$MYSQL_USER/g" wp-config-sample.php
	sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config-sample.php
	sed -i "s/localhost/$MYSQL_HOSTNAME/g" wp-config-sample.php
	sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config-sample.php
	cp wp-config-sample.php wp-config.php
	# wp core download
	# wp core config --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=$MYSQL_HOSTNAME
	# wp core install --url=$DOMAIN_NAME --title="Inception" --admin_user=$MYSQL_USER --admin_password=$MYSQL_PASSWORD --admin_email=$MYSQL_EMAIL

# #boosting security removing wordpress, css, js versions
# echo 'function remove_ver_css_js( $src ) {' >> wp-config.php
# echo '    if ( strpos( $src, "ver=" . esc_url(get_bloginfo( "version" )) ) )' >> wp-config.php
# echo '        $src = remove_query_arg( "ver", $src );' >> wp-config.php
# echo '    return $src;' >> wp-config.php
# echo '}' >> wp-config.php

# echo 'add_filter( 'script_loader_src', 'remove_ver_css_js', 9999 );' >> wp-config.php
# echo  'add_filter( 'style_loader_src', 'remove_ver_css_js', 9999 );' >> wp-config.php

# # #obfuscate debug errors
# echo 'define('WP_DEBUG', false);' >> wp-config.php

fi

exec "$@"
