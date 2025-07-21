FROM debian:bullseye

# Install NGINX and OpenSSL
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Create directories for SSL certificates
RUN mkdir -p /etc/ssl/certs /etc/ssl/private

# Generate self-signed SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx.key \
    -out /etc/ssl/certs/nginx.crt \
    -subj "/C=FR/ST=Paris/L=Paris/O=42School/OU=mochamsa/CN=mochamsa.42.fr"

# Copy NGINX configuration
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/sites-available/default

# Create a symlink for the site
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

# Copy startup script
COPY tools/start_nginx.sh /usr/local/bin/start_nginx.sh
RUN chmod +x /usr/local/bin/start_nginx.sh

# Expose port
EXPOSE 443

# Start NGINX
ENTRYPOINT ["/usr/local/bin/start_nginx.sh"]
