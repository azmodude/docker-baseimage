FROM golang:latest as remco

ENV GOPATH /go

RUN go get github.com/HeavyHorst/remco/cmd/remco && \
        go install github.com/HeavyHorst/remco/cmd/remco && \
        mv ${GOPATH}/bin/remco /remco

FROM debian:stable-slim
LABEL maintainer "Gordon Schulz <gordon.schulz@gmail.com>"

COPY --from=remco /remco /usr/local/bin/remco

RUN apt-get update && apt-get -y --no-install-recommends install \
        apt-transport-https curl ca-certificates && \
        apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG S6_OVERLAY_VERSION
RUN curl -s -S -L -o /tmp/s6-overlay-amd64.tar.gz \
        https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz && \
        tar xvzf /tmp/s6-overlay-amd64.tar.gz -C / && \
        rm /tmp/s6-overlay-amd64.tar.gz

ENTRYPOINT ["/init"]
