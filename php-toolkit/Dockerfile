FROM php:7.1-fpm-alpine

ENV PHP_TIMEZONE="Etc\UTC" \
    FPM_PROCESS_MANAGER="dynamic" \
    FPM_MAX_CHILDREN=5 \
    FPM_START_SERVERS=2 \
    FPM_MIN_SPARE_SERVERS=1 \
    FPM_MAX_SPARE_SERVERS=3 \
    FPM_PROCESS_IDLE_TIMEOUT="10s" \
    COMPOSER_ALLOW_SUPERUSER=1

RUN set -xe && \
    apk add --no-cache --quiet freetype libintl libpng libjpeg-turbo icu grep && \
    apk add --no-cache --quiet --virtual .build-deps zlib-dev freetype-dev libpng-dev libjpeg-turbo-dev icu-dev $PHPIZE_DEPS && \
    sed -i 's#set -x#set +x#' /usr/local/bin/docker-php-ext-configure && \
    docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ && \
    NPROC=$(getconf _NPROCESSORS_ONLN) && \
    docker-php-ext-install -j${NPROC} zip iconv pdo pdo_mysql gd opcache mbstring bcmath intl pcntl && \
    sed -i 's#set +x#set -x#' /usr/local/bin/docker-php-ext-configure && \
    pecl install apcu && \
    echo extension=apcu.so > /usr/local/etc/php/conf.d/apcu.ini && \
    apk del --quiet .build-deps && \
    # Install composer
    curl -sS https://getcomposer.org/installer | \
        php -- --install-dir=/usr/local/bin --filename=composer && \
    # Install Dockerize
    curl -sSL \
        https://github.com/jwilder/dockerize/releases/download/v0.2.0/dockerize-linux-amd64-v0.2.0.tar.gz | \
        tar -C /usr/local/bin -xzv && \
    true
    
COPY config /usr/local/etc/php/conf.d
COPY www.conf /usr/local/etc/php-fpm.d/www.conf.template
COPY run.sh /run.sh

ENTRYPOINT /run.sh
CMD php-fpm
