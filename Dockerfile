FROM soifou/wpcli-alpine

ADD rootfs /

RUN set -ex \
      && apk update \
      && apk add \
        git

ENTRYPOINT ["/init.sh"]
