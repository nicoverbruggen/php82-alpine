FROM php:8.2-alpine
# https://hub.docker.com/_/php/tags?page=1&name=8.2-alpine

# Install PHP modules and clean up
RUN apk add --no-cache $PHPIZE_DEPS \
	imagemagick-dev icu-dev zlib-dev jpeg-dev libpng-dev libzip-dev libgomp linux-headers; \
    docker-php-ext-configure gd --with-jpeg; \
	docker-php-ext-install intl pcntl gd exif zip; \
    # Xdebug
    wget https://xdebug.org/files/xdebug-3.2.0.tgz; \
    tar -xzf xdebug-3.2.0.tgz; \
    cd xdebug-3.2.0; \
    phpize; \
    ./configure --enable-xdebug; \
    make; make install; \
    # --------------------------------
    # pecl install xdebug; \
    # docker-php-ext-enable xdebug; \
    # --------------------------------
    echo $'zend_extension=xdebug\nxdebug.mode=coverage' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    pecl install imagick; \
    docker-php-ext-enable imagick; \
    apk del $PHPIZE_DEPS; \
    rm -rf /tmp/pear;

# Install other dependencies
RUN apk add --no-cache git curl sqlite nodejs npm nano