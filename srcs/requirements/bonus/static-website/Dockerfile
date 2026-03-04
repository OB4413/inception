FROM debian:12

RUN apt update && apt install nginx -y && rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/sites-available/default
COPY conf/index.html /var/www/html

EXPOSE 8080

ENTRYPOINT [ "nginx", "-g", "daemon off;"]