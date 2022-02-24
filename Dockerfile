FROM alpine:latest

ARG CONFIG_PATH

# Installing PACKAGES
RUN apk --no-cache add \
                   nginx \
                   php8 \
                   php8-common \
                   php8-cli \
                   php8-fpm \
                   php8-dom \
                   php8-gd \
                   php8-mbstring \
                   php8-xml \
                   php8-intl \
                   php8-curl \
                   php8-gmp \
                   php8-xml \
                   php8-bcmath \
                   php8-pcntl \
                   php8-posix \
                   php8-zip \
                   php8-redis \
                   php8-phar \
                   php8-openssl \
                   php8-ctype \
                   php8-json \
                   php8-opcache \
                   php8-session \
                   php8-zlib \
                   php8-tokenizer \
                   php8-fileinfo \
                   wget \
                   unzip \
                   gcc \
                   bzip2 \
                   git \
                   openssl \
                   curl \
                   vim \
                   supervisor \
                   python3 \
                   python3-dev

RUN npm install -g yarn node-gyp

# Create symlink so programs on php would know
RUN ln -s /usr/bin/php8 /usr/bin/php

# Make directories
RUN mkdir -p /var/www/html

# Configs
COPY config/supervisord.conf /etc/supervisord.conf
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/fpm-pool.conf /etc/php8/php-fpm.d/www.conf
COPY config/php.ini /etc/php8/conf.d/custom.ini

# Entrypoint
COPY --chown=nginx config/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set Permissions
RUN chown -R nginx /var/www/html && \
    chown -R nginx /run && \
    chown -R nginx /var/lib/nginx && \
    chown -R nginx /var/lib/nginx

# Switch to use non-root user \
USER nginx

# Build the app
COPY --chown=nginx src/www /var/www
COPY --chown=nginx ${CONFIG_PATH}/.env /var/www/html

# Install packages
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN cd /var/www/html && /usr/bin/composer install --optimize-autoloader --no-dev --no-interaction --no-progress

EXPOSE 8080
EXPOSE 8443

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n"]