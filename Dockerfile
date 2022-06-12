ARG ALPINE_VERSION=3.15
FROM alpine:${ALPINE_VERSION}

ENV AUTOUPDATE=yes

ARG BUILD_DATE
ARG VCS_REF
ARG YOUTUBE_DL_OVERWRITE=
LABEL \
    org.opencontainers.image.authors="hoanghiepitvnn@gmail.com" \
    org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.version="${YOUTUBE_DL_OVERWRITE}" \
    org.opencontainers.image.url="https://github.com/dhhiep/youtube-dlp-aio-docker" \
    org.opencontainers.image.documentation="https://github.com/dhhiep/youtube-dlp-aio-docker/blob/master/README.md" \
    org.opencontainers.image.source="https://github.com/dhhiep/youtube-dlp-aio-docker" \
    org.opencontainers.image.title="youtube-dlp-aio-docker" \
    org.opencontainers.image.description="Download with youtube-dlp using command line arguments or configuration files"

HEALTHCHECK --interval=10m --timeout=10s --retries=1 CMD [ "$(wget -qO- https://duckduckgo.com 2>/dev/null)" != "" ] || exit 1

RUN apk add -q --progress --update --no-cache ca-certificates ffmpeg python3 && \
    rm -rf /var/cache/apk/*
RUN apk add -q --progress --update --no-cache --virtual deps gnupg && \
    ln -s /usr/bin/python3 /usr/local/bin/python && \
    LATEST=${YOUTUBE_DL_OVERWRITE:-latest} && \
    wget -q https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/youtube-dlp && \
    apk del deps && \
    rm -rf /var/cache/apk/* && \
    chmod 777 /usr/local/bin/youtube-dlp

ENTRYPOINT ["/entrypoint.sh"]
CMD ["-h"]
COPY entrypoint.sh /
RUN chown 1000 /entrypoint.sh /usr/local/bin/youtube-dlp && \
    chmod 555 /entrypoint.sh

USER 1000
