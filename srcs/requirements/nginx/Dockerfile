FROM debian:12


RUN apt update && apt upgrade -y &&\
    apt install nginx openssl -y

COPY conf/nginx.conf /etc/nginx/sites-available/default

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 \
-newkey rsa:2048 \
-keyout /etc/nginx/ssl/nginx.key \
-out /etc/nginx/ssl/nginx.crt \
-subj "/C=MA/ST=KH/L=KH/O=42/OU=42/CN=obarais.42.fr"

EXPOSE 443

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]