-include .env.mk

.env.mk: .env
		sed 's/"//g ; s/=/:=/' < $< > $@

.PHONY: all build push
.DEFAULT_GOAL := build

GIT_COMMIT=$(shell git rev-parse HEAD | cut -c 1-10)

all: build push

build:
	$(info GIT_COMMIT=$(GIT_COMMIT))
	sudo docker build --build-arg S6_OVERLAY_VERSION=$(S6_OVERLAY_VERSION) -t azmo/base:debian-slim -t azmo/base:debian-slim-$(GIT_COMMIT) -t azmo/base:debian-s6-remco .

push:
	sudo docker push azmo/base:debian-slim
	sudo docker push azmo/base:debian-s6-remco
