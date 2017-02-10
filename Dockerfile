FROM cloudposse/wp-cli:latest

ADD rootfs /

ENV GIT_REPO=
ENV GIT_BRANCH=
ENV DESTINATION=
ENV DB_URL=

RUN apk --update add git

ENTRYPOINT ["/init.sh"]
