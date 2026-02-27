FROM debian:12

RUN apt update && \
    apt install -y php php-mysqli wget && \
    mkdir -p /var/www/html && \
    wget https://www.adminer.org/static/download/5.2.1/adminer-5.2.1.php -O /var/www/html/index.php

WORKDIR /var/www/html

ENTRYPOINT ["php", "-S", "0.0.0.0:8081"]
