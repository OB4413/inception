#!/bin/bash
set -e

echo "Waiting for MariaDB..."

until mysql -h "$DB_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SELECT 1" >/dev/null 2>&1; do
    sleep 2
done

echo "MariaDB is up!"

# Download WordPress if not installed
if [ ! -f wp-load.php ]; then
    wp core download --allow-root
    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="$DB_HOST" \
        --allow-root
fi

# Install WordPress
if ! wp core is-installed --allow-root; then
    wp core install \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root
    wp user create \
        $WP_USER $WP_USER_EMAIL \
        --user_pass=$WP_USER_PASSWORD \
        --role=author \
        --allow-root

    wp config set WP_REDIS_HOST redis --allow-root
    wp config set WP_REDIS_PORT 6379 --allow-root
    wp plugin install redis-cache --activate --allow-root
    wp redis enable --allow-root
fi

chown -R www-data:www-data /var/www/html
chmod -R 775 /var/www/html

exec php-fpm8.2 -F