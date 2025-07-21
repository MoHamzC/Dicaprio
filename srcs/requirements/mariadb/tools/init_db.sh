#!/bin/bash
set -e

# Read secrets
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_PASSWORD=$(cat /run/secrets/db_password)

# Initialize database if not exists
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Start MariaDB temporarily
    mysqld_safe --user=mysql --datadir=/var/lib/mysql --socket=/var/run/mysqld/mysqld.sock &
    sleep 5

    # Wait for MariaDB to start
    while ! mysqladmin ping --silent; do
        sleep 1
    done

    # Set root password and create database
    mysql -u root <<-EOSQL
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
    mysqladmin -u root -p"${DB_ROOT_PASSWORD}" shutdown
fi

# Start MariaDB normally
exec mysqld_safe --user=mysql --datadir=/var/lib/mysql
