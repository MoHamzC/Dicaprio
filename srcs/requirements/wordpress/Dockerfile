FROM debian:bullseye

# Install PHP-FPM and required extensions
RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-curl \
    php7.4-gd \
    php7.4-intl \
    php7.4-mbstring \
    php7.4-soap \
    php7.4-xml \
    php7.4-xmlrpc \
    php7.4-zip \
    php-fpm \
    curl \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Download and install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/wp-cli/v2.8.1/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Create necessary directories
RUN mkdir -p /var/www/html \
    && mkdir -p /run/php \
    && chown -R www-data:www-data /var/www/html

# Copy configuration files
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY tools/wp_setup.sh /usr/local/bin/wp_setup.sh

# Make script executable
RUN chmod +x /usr/local/bin/wp_setup.sh

# Set working directory
WORKDIR /var/www/html

# Expose port
EXPOSE 9000

# Run setup script
ENTRYPOINT ["/usr/local/bin/wp_setup.sh"]
