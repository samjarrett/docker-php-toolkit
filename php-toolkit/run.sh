#!/bin/sh

dockerize \
    -template /usr/local/etc/php/conf.d/timezone.ini.template:/usr/local/etc/php/conf.d/timezone.ini \
    -template /usr/local/etc/php-fpm.d/www.conf.template:/usr/local/etc/php-fpm.d/www.conf \
    $@