#!/bin/bash
set -e

# Read secrets as root (they are only readable by root)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_PASSWORD=$(cat /run/secrets/db_password)

# Export them so they can be used by mysql user
export DB_ROOT_PASSWORD
export DB_PASSWORD

# Ensure proper ownership of mysql directories
chown -R mysql:mysql /var/lib/mysql
chown -R mysql:mysql /var/run/mysqld

# Initialize database if not exists
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    su-exec mysql mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Start MariaDB temporarily as mysql user
    su-exec mysql mysqld_safe --user=mysql --datadir=/var/lib/mysql --socket=/var/run/mysqld/mysqld.sock &
    sleep 5

    # Wait for MariaDB to start
    while ! su-exec mysql mysqladmin ping --silent; do
        sleep 1
    done

    # Set root password and create database
    su-exec mysql mysql -u root <<-EOSQL
        UPDATE mysql.user SET Password=PASSWORD('${DB_ROOT_PASSWORD}') WHERE User='root';
        DELETE FROM mysql.user WHERE User='';
        DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
        DROP DATABASE IF EXISTS test;
        DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
        CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
        FLUSH PRIVILEGES;
EOSQL

    # Stop temporary MariaDB
    su-exec mysql mysqladmin -u root -p"${DB_ROOT_PASSWORD}" shutdown
fi

# Start MariaDB normally as mysql user
exec su-exec mysql mysqld_safe --user=mysql --datadir=/var/lib/mysql
