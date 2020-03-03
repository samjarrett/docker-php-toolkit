FROM ruby:2.6-alpine

RUN set -xe && \
    apk --no-cache --virtual .build-deps add gcc make g++ && \
    gem install travis && \
    apk del .build-deps && \
    rm -rf /usr/local/bundle/cache/*.gem /tmp/*

ENTRYPOINT [ "/usr/local/bundle/bin/travis" ]