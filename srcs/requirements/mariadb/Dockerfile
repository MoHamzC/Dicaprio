FROM debian:bullseye

# Install MariaDB server and gosu
RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    gosu \
    && rm -rf /var/lib/apt/lists/*

# Create necessary directories and set permissions
RUN mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld \
    && chmod 755 /var/run/mysqld

# Copy configuration files
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/init_db.sh /usr/local/bin/init_db.sh

# Make script executable
RUN chmod +x /usr/local/bin/init_db.sh

# Set ownership
RUN chown -R mysql:mysql /var/lib/mysql

# Expose port
EXPOSE 3306

# Don't set user here - we need root to read secrets first
# USER mysql

# Run initialization script (will switch to mysql user internally)
ENTRYPOINT ["/usr/local/bin/init_db.sh"]
