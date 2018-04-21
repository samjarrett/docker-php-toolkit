FROM ghost:1-alpine

ENV url="http://localhost" \
    database__client="mysql" \
    database__connection__host="db"

RUN set -xe && \
    apk add --no-cache tini && \
    true

ENTRYPOINT ["/sbin/tini", "--", "docker-entrypoint.sh"]
CMD ["node", "current/index.js"]

USER node
