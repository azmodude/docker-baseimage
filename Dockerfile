FROM fedora:latest
LABEL maintainer="Gordon Schulz <gordon@gordonschulz.de>"

ARG S6_OVERLAY_VERSION
RUN curl -s -S -L -o /tmp/s6-overlay-amd64.tar.gz \
        https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz && \
        tar xzf /tmp/s6-overlay-amd64.tar.gz -C / --exclude="./bin" && \
        tar xzf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin && \
        rm /tmp/s6-overlay-amd64.tar.gz

ENTRYPOINT ["/init"]

ARG COMMIT_SHA=unspecified
LABEL commit_sha=${COMMIT_SHA}
