# docker-yq

A tiny ~9MB* (uncompressed) statically linked yq docker image. A separate image tag is provided that comes packaged alongside
[busybox](https://busybox.net/).

*\* The busybox image variant adds an additional ~1MB to the image size.*

Supports *most* upstream [alpine](https://www.alpinelinux.org/) docker platforms:

- `linux/amd64`
- `linux/arm64`
- `linux/arm/v7`
- `linux/arm/v6`
- `linux/386`
- `linux/ppc64le`
- `linux/s390x`

## Why

This is a purpose-built image that works great as a [Kubernetes](https://kubernetes.io/) init container.

## Pull

### [ghcr.io](https://github.com/egladman/docker-yq/pkgs/container/yq)

```
docker pull ghcr.io/egladman/yq:4.27.2
docker pull ghcr.io/egladman/yq:4.27.2-busybox
```

### [docker.io](https://hub.docker.com/r/egladman/yq)

```
docker pull docker.io/egladman/yq:4.27.2
docker pull docker.io/egladman/yq:4.27.2-busybox
```

## Usage

```
docker run --rm yq:4.27.2 yq --version
```

## Build

```
make
make IMG_VARIANT=busybox
```

## Acknowledgements

- https://github.com/mikefarah/yq
