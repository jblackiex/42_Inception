FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y \
    sudo \
    mariadb* \
    vim \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/mysqld

RUN chown -R mysql:mysql /var/run/mysqld \
&& chmod 777 /var/run/mysqld

EXPOSE 3306

COPY ./tools/mariadb.sh /usr/local/bin/
COPY ./conf/wordpress.sql /usr/local/bin/

RUN chmod +x /usr/local/bin/mariadb.sh
RUN chmod +x /usr/local/bin/wordpress.sql


ENTRYPOINT [ "/usr/local/bin/mariadb.sh" ]

CMD [ "mysqld", "--bind-address=0.0.0.0" ]