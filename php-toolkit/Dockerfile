FROM php:7.0-fpm

MAINTAINER Sam Marley-Jarrett <hi@samjarrett.com.au>

ENV PHP_TIMEZONE "Australia/Melbourne"

RUN set -xe && \
    # Add a variety of standard PHP dependencies: gd, opcache, pdo/mysql, mbstring, bcmath
    apt-get -qq update && \
    apt-get -qq install \
        git \
        zlib1g-dev \
        libjpeg-dev \
        libpng12-dev \
        libicu-dev \
        --no-install-recommends && \
    docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr > /dev/null && \
    docker-php-ext-install zip pdo pdo_mysql gd opcache mbstring bcmath intl pcntl > /dev/null && \
    # Add php dep: APCU
    pecl install apcu && \
    echo extension=apcu.so > /usr/local/etc/php/conf.d/apcu.ini && \
    # Clean up
    apt-get clean && \
    rm -r /var/lib/apt/lists/* && \
    # Install composer
    curl -sS https://getcomposer.org/installer | \
        php -- --install-dir=/usr/local/bin --filename=composer && \
    # Install Dockerize
    curl -o /tmp/dockerize.tar.gz -L \
        https://github.com/jwilder/dockerize/releases/download/v0.2.0/dockerize-linux-amd64-v0.2.0.tar.gz && \
    tar -C /usr/local/bin -xzvf /tmp/dockerize.tar.gz && \
    rm /tmp/dockerize.tar.gz && \
    true

COPY config/timezone.ini config/opcache.ini config/realpath-cache.ini /usr/local/etc/php/conf.d/

CMD ["dockerize", "-template" "/usr/local/etc/php/conf.d/timezone.ini:/usr/local/etc/php/conf.d/timezone.ini", "php-fpm"]