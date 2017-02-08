FROM soifou/wpcli-alpine

ADD rootfs /


ENTRYPOINT ["/init.sh"]
