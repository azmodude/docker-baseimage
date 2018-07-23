FROM golang:latest as builder

ENV GOPATH /go

RUN go get github.com/HeavyHorst/remco/cmd/remco && \
        go install github.com/HeavyHorst/remco/cmd/remco && \
        mv ${GOPATH}/bin/remco /remco

ARG GOSU_VERSION
RUN set -ex; \
	\
	fetchDeps=' \
		ca-certificates \
		wget \
	'; \
	apt-get update; \
	apt-get install -y --no-install-recommends $fetchDeps; \
	rm -rf /var/lib/apt/lists/*; \
	\
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	wget -O /gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	wget -O /gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
	\
# verify the signature
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --keyserver hkp://eu.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
	gpg --batch --verify /gosu.asc /gosu; \
	rm -r "$GNUPGHOME" /gosu.asc; \
	\
	chmod +x /gosu; \
# verify that the binary works
	/gosu nobody true; \
	\
	apt-get purge -y --auto-remove $fetchDeps

FROM ubuntu:latest
LABEL maintainer="Gordon Schulz <gordon.schulz@gmail.com>"

COPY --from=builder /remco /usr/local/bin/remco
COPY --from=builder /gosu /usr/local/bin/gosu

RUN apt-get update && apt-get -y --no-install-recommends install \
        apt-transport-https curl ca-certificates software-properties-common && \
        apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG S6_OVERLAY_VERSION
RUN curl -s -S -L -o /tmp/s6-overlay-amd64.tar.gz \
        https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz && \
        tar xzf /tmp/s6-overlay-amd64.tar.gz -C / && \
        rm /tmp/s6-overlay-amd64.tar.gz

ENTRYPOINT ["/init"]
