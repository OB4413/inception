FROM debian:12

RUN apt update && apt install nginx -y && apt install nginx openssl -y && rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/sites-available/default
COPY conf/index.html /var/www/html

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 \
-newkey rsa:2048 \
-keyout /etc/nginx/ssl/nginx.key \
-out /etc/nginx/ssl/nginx.crt \
-subj "/C=MA/ST=KH/L=KH/O=42/OU=42/CN=obarais.42.fr"

EXPOSE 8080

ENTRYPOINT [ "nginx", "-g", "daemon off;"]