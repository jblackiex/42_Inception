include ./srcs/.env
export

all: domain certs 
	@docker-compose -f ./srcs/docker-compose.yml up -d --build

re: clean all

domain:
		@if ! grep -qF $(MYSQL_USER) /etc/hosts; then \
			sed -i '1i 127.0.0.1 $(DOMAIN_NAME)' /etc/hosts; \
			systemctl restart NetworkManager; \
		fi

certs:
	@if [ ! -f $(VOLUME_DIR) ]; then \
		mkdir -p $(VOLUME_DIR_MYSQL); \
		mkdir -p $(VOLUME_DIR_WORDPRESS); \
	fi
	@mkdir -p $(CERT_DIR)
	@rm -rf $(CERT_DIR_CRT)
	@rm -rf $(CERT_DIR_KEY)
	@echo "Creating certificates for TLS..."
	@if [ ! -f $(CERT_DIR_CRT) ]; then \
			openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
       		-subj $(OPENSSL) \
       		-keyout $(CERT_DIR_KEY) \
       		-out $(CERT_DIR_CRT); \
	fi

clean:
	@if docker network ls | grep 'inception'; then \
    	docker stop $$(docker ps -qa); \
		docker rm $$(docker ps -qa); \
		docker rmi -f $$(docker images -qa); \
		docker volume rm $$(docker volume ls -q); \
		docker network rm $$(docker network ls | grep 'inception' | awk '{print $2}') 2>/dev/null || true; \
	fi


cleanvlm: clean
		rm -rf $(VOLUME_DIR_WORDPRESS)
		rm -rf $(VOLUME_DIR_MYSQL)
		mkdir -p $(VOLUME_DIR_WORDPRESS)
		mkdir -p $(VOLUME_DIR_MYSQL)

stop:
	@docker stop $$(docker ps -qa) 2>/dev/null || true;
start:
	@docker start $$(docker ps -qa) 2>/dev/null || true;


shelldb:
		@docker exec -it mariadb_server /bin/bash 2>/dev/null || true
shellwp:
		@docker exec -it wordpress_server /bin/bash 2>/dev/null || true
shellngx:
		@docker exec -it nginx_server /bin/bash 2>/dev/null || true


.PHONY: all re clean shelldb shellwp shellngx stop start domain certs cleanvlm


#INFO

# WORDPRESS_IP/wp-admin to reach wordpress admin page
# docker exec -it <container-name> /bin/bash
# docker system prune -a delete all images and containers
# sudo docker build -t nginxx2 .
# sudo docker run -p 2538:443 nginxx2
# sudo docker ps
# sudo docker images
# sudo vim /etc/hosts
# sudo docker-compose logs -f // logs real time
# sudo systemctl restart NetworkManager
# sed -i '$ a <quellochevoglioinserire>' nomefiledamoddare
# mysql -uroot // login your database with root user
# mysqldump -u MYSQL_USER -p MYSQL_DATABASE > backup.sql
# mysql -u MYSQL_USER -p MYSQL_DATABASE < backup.sql
# set a password fro a database as root user MYSQL
# ALTER USER 'username'@'hostname' IDENTIFIED BY 'newpassword';
# FLUSH PRIVILEGES;


