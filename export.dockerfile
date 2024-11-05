FROM alpine:3.17

RUN apk add e2fsprogs

COPY --from=alpine_root / /tmp

RUN mkfs.ext2 -b 4096 -d /tmp /export/image.ext2 1500M



