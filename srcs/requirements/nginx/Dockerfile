FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    sudo \
    nginx \
    openssl \
    vim \
    && rm -rf /var/lib/apt/lists/*

COPY ./conf/nbordoni.42.conf /etc/nginx/conf.d

RUN mkdir -p /run/nginx

EXPOSE 443

CMD [ "nginx", "-g", "daemon off;" ]
