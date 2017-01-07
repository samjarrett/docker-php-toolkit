FROM node:alpine

RUN set -xe && \
    npm install --global yarn && \
    rm -rf /tmp/npm-* && \
    true

WORKDIR /app
CMD yarn