FROM nginx:alpine

COPY default.template /etc/nginx/conf.d/default.template

ENV PHP_HOST=app
CMD envsubst '$PHP_HOST' < /etc/nginx/conf.d/default.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'