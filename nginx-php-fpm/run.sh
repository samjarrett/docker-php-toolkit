#!/bin/sh -xe

envsubst '$PHP_HOST' < /etc/nginx/conf.d/default.template > /etc/nginx/conf.d/default.conf

exec "$@"