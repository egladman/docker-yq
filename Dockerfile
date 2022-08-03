ARG REGISTRY=docker.io/
ARG GO_VERSION=1.19
ARG UID=5355
ARG DESTDIR=/out
ARG VARIANT=core

FROM ${REGISTRY}golang:${GO_VERSION}-alpine as builder

RUN set -eux; \
    apk add \
        --no-cache \
        busybox-static \
        git \
    ;


FROM builder as core-addon

ARG DESTDIR
RUN set -eux; \
    mkdir -p ${DESTDIR}


FROM builder as busybox-addon

ARG DESTDIR
RUN set -eux; \
    mkdir -p ${DESTDIR}/bin; \
    /bin/busybox.static --install "${DESTDIR}/bin"


FROM ${VARIANT}-addon as selected-addon


FROM builder as runtime-rootfs

ARG DESTDIR
RUN set -eux; \
    mkdir -p ${DESTDIR}/bin


FROM builder as yq-build

ARG YQ_VERSION=4.27.2
ARG YQ_GIT_PREFIX=https://github.com/mikefarah
ARG YQ_GIT_TAG=v${YQ_VERSION}
ARG CGO_ENABLED=0
ARG DESTDIR

RUN set -eux; \
    mkdir "$DESTDIR"; \
    git clone ${YQ_GIT_PREFIX}/yq src; \
    cd src; \
    git reset --hard $YQ_GIT_TAG; \
    go build \
      -ldflags="-s -w -extldflags=-static" \
      -o "$DESTDIR" \
      . \
    ;


FROM scratch

ARG DESTDIR
ARG UID

COPY --from=runtime-rootfs ${DESTDIR}/ /
COPY --from=yq-build ${DESTDIR}/ /bin
COPY --from=selected-addon ${DESTDIR}/ /

USER $UID

CMD ["/bin/yq"]
