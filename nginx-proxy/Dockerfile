FROM nginx:alpine

ENV BACKEND_HOST=app

RUN set -xe && \
    apk add --no-cache tini && \
    true

COPY default.template /etc/nginx/conf.d/default.template
COPY docker-entrypoint /docker-entrypoint

ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint"]
CMD ["nginx", "-g", "daemon off;"]
