FROM alpine:3.7
MAINTAINER Morton Jonuschat <m.jonuschat@mojocode.de>

COPY image /build

RUN /build/install.sh

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_CTYPE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

ENTRYPOINT ["/init"]
