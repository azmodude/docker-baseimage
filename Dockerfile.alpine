FROM alpine:latest
LABEL maintainer="Gordon Schulz <gordon@gordonschulz.de>"

RUN apk add --update --no-cache curl tar shadow util-linux

ARG S6_OVERLAY_VERSION
RUN curl -s -S -L \
        https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz | \
        tar xzf - -C /

ENTRYPOINT ["/init"]

ARG COMMIT_SHA=unspecified
LABEL commit_sha=${COMMIT_SHA}
