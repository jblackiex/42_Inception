FROM debian:bullseye

# Install php-fpm and required PHP extensions
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    sudo \
    wget \
    curl \
    bash \
    vim \
    php-fpm \
    php-mysql \
    php-cgi \
	php-pdo \
	php-gd \
    php-cli \
	php-mbstring \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

COPY ./tools/wp_check.sh /usr/local/bin/

RUN mkdir -p /run/php

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/

RUN chmod +x /usr/local/bin/wp_check.sh

ENTRYPOINT [ "/usr/local/bin/wp_check.sh" ]

EXPOSE 9000

WORKDIR /var/www/html/

CMD [ "/usr/sbin/php-fpm7.4", "-F" ]
