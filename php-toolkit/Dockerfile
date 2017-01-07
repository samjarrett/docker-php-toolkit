FROM php:7.0-fpm-alpine 

ENV PHP_TIMEZONE="Etc\UTC" \
    COMPOSER_ALLOW_SUPERUSER=1

RUN set -xe && \
    apk add --no-cache freetype libintl libpng libjpeg-turbo icu && \
    apk add --no-cache --virtual .build-deps zlib-dev freetype-dev libpng-dev libjpeg-turbo-dev icu-dev $PHPIZE_DEPS && \
    docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ && \
    NPROC=$(getconf _NPROCESSORS_ONLN) && \
    docker-php-ext-install -j${NPROC} zip iconv pdo pdo_mysql gd opcache mbstring bcmath intl pcntl && \
    pecl install apcu && \
    echo extension=apcu.so > /usr/local/etc/php/conf.d/apcu.ini && \
    apk del .build-deps && \
    # Install composer
    curl -sS https://getcomposer.org/installer | \
        php -- --install-dir=/usr/local/bin --filename=composer && \
    # Install Dockerize
    curl -sSL \
        https://github.com/jwilder/dockerize/releases/download/v0.2.0/dockerize-linux-amd64-v0.2.0.tar.gz | \
        tar -C /usr/local/bin -xzv && \
    true
    
COPY config /usr/local/etc/php/conf.d

CMD ["dockerize", "-template" "/usr/local/etc/php/conf.d/timezone.ini.template:/usr/local/etc/php/conf.d/timezone.ini", "php-fpm"]