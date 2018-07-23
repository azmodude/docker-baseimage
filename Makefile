-include .env.mk

.env.mk: .env
		sed 's/"//g ; s/=/:=/' < $< > $@

.PHONY: all build push
.DEFAULT_GOAL := build

GIT_COMMIT=$(shell git rev-parse HEAD | cut -c 1-10)

all: build push

build:
	$(info GIT_COMMIT=$(GIT_COMMIT))
	sudo docker build --pull --build-arg S6_OVERLAY_VERSION=$(S6_OVERLAY_VERSION) \
		--build-arg GOSU_VERSION=$(GOSU_VERSION) -t azmo/base:ubuntu-latest -t azmo/base:ubuntu-latest-$(GIT_COMMIT) .

push:
	sudo docker push azmo/base:ubuntu-latest
