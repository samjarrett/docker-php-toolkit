FROM nginx:alpine

ENV BACKEND_HOST=app

RUN set -xe && \
    apk add --no-cache tini && \
    true

COPY global-settings.template /etc/nginx/conf.d/global-settings.template
COPY default.conf /etc/nginx/conf.d/default.conf
COPY docker-entrypoint /docker-entrypoint

ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint"]
CMD ["nginx", "-g", "daemon off;"]
