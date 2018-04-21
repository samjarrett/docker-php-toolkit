FROM nginx:alpine

ENV PHP_HOST=app

RUN set -xe && \
    apk add --no-cache tini && \
    true

COPY default.template /etc/nginx/conf.d/default.template
COPY run.sh /run.sh

ENTRYPOINT ["/sbin/tini", "--", "/run.sh"]
CMD ["nginx", "-g", "daemon off;"]
