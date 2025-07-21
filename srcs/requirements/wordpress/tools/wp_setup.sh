#!/bin/bash
set -e

# Read secrets
DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/credentials | tail -n 1)

# Wait for database to be ready
echo "Waiting for database to be ready..."
while ! mysqladmin ping -h"${DB_HOST%:*}" -P"${DB_HOST#*:}" --silent; do
    sleep 2
done
echo "Database is ready!"

# Change to WordPress directory
cd /var/www/html

# Download WordPress if not exists
if [ ! -f wp-config.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root
    
    # Create wp-config.php
    echo "Creating wp-config.php..."
    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${DB_PASSWORD}" \
        --dbhost="${DB_HOST}" \
        --allow-root

    # Install WordPress
    echo "Installing WordPress..."
    wp core install \
        --url="${DOMAIN_NAME}" \
        --title="Inception WordPress" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root

    # Create additional user
    echo "Creating additional user..."
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=editor \
        --allow-root

    echo "WordPress installation completed!"
fi

# Set correct permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Start PHP-FPM
echo "Starting PHP-FPM..."
exec php-fpm7.4 -F
