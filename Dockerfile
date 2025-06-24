# Use an official PHP-FPM 7.3.13 image as the base
FROM php:7.3.13-fpm-alpine

# Set working directory inside the container
WORKDIR /var/www/html

# Define PHPIZE_DEPS (build dependencies for phpize)
ARG PHPIZE_DEPS="autoconf file g++ gcc libc-dev make pkgconf re2c"

# Install Nginx, Supervisor, and other necessary packages
# Also installs PHP extensions and Imagick, then cleans up build dependencies
RUN apk update && apk add --no-cache \
    nginx \
    supervisor \
    bash \
    curl \
    unzip \
    git \
    build-base \
    libpng-dev \
    jpeg-dev \
    freetype-dev \
    # ADDED 'imagemagick' here for runtime delegates
    imagemagick \
    imagemagick-dev \
    libzip-dev \
    icu-dev \
    # Explicitly add build tools required by phpize and pecl for compilation
    ${PHPIZE_DEPS} && \
    \
    # Install common PHP extensions (adjust as needed for your application)
    docker-php-ext-install pdo_mysql opcache gd exif bcmath zip intl mysqli && \
    \
    # Install imagick (requires ImageMagick-dev AND build tools)
    pecl install imagick && \
    docker-php-ext-enable imagick && \
    \
    # Clean up build dependencies and package cache to reduce image size
    apk del --no-cache ${PHPIZE_DEPS} && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/pear

# Copy custom Nginx configurations
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# Copy custom PHP configurations
COPY php/php.ini /usr/local/etc/php/php.ini
COPY php/www.conf /usr/local/etc/php-fpm.d/www.conf

# Copy Supervisor configuration
COPY supervisor/supervisord.conf /etc/supervisord.conf

# The 'COPY app/' line is commented out as you're using a bind mount for development.
# If you were to build this for production, you'd uncomment this and ensure your
# application code is within the 'app/' directory in your build context.
# COPY app/ /var/www/html/

RUN mkdir -p /tmp/sessions && \
    chown -R www-data:www-data /tmp/sessions && \
    chmod -R 775 /tmp/sessions

# Expose port 80 for Nginx
EXPOSE 80

# Create the logs directory and set permissions
RUN mkdir -p /var/www/html/logs && \
    chown -R www-data:www-data /var/www/html/logs && \
    chmod -R 775 /var/www/html/logs

# Set permissions for the entire application directory to be safe (read-only for Nginx, write for PHP where needed)
RUN chown -R www-data:www-data /var/www/html && \
    find /var/www/html -type d -exec chmod 775 {} + && \
    find /var/www/html -type f -exec chmod 664 {} +

# Command to run Supervisor when the container starts
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
