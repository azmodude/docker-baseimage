FROM golang:latest as confd

ENV GOPATH /go

RUN mkdir -p $GOPATH/src/github.com/bacongobbler && \
        git clone https://github.com/bacongobbler/confd.git $GOPATH/src/github.com/bacongobbler/confd && \
        cd $GOPATH/src/github.com/bacongobbler/confd && \
        ./build && \
        mv bin/confd /

FROM debian:stable-slim
LABEL maintainer "Gordon Schulz <gordon.schulz@gmail.com>"

COPY --from=confd /confd /usr/local/bin/confd

RUN apt-get update && apt-get -y --no-install-recommends install curl ca-certificates && \
        apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG S6_OVERLAY_VERSION
RUN curl -L -o /tmp/s6-overlay-amd64.tar.gz \
        https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz && \
        tar xzf /tmp/s6-overlay-amd64.tar.gz -C / --exclude="./bin" && \
        tar xzf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin && \
        rm /tmp/s6-overlay-amd64.tar.gz

ENTRYPOINT ["/init"]
