-include .env.mk

.env.mk: .env
		sed 's/"//g ; s/=/:=/' < $< > $@

.PHONY: all build push
.DEFAULT_GOAL := build

COMMIT_SHA=$(shell git rev-parse HEAD | cut -c 1-10)

all: build-ubuntu-latest build-ubuntu-rolling build-alpine

build-ubuntu-latest:
	$(info COMMIT_SHA=$(COMMIT_SHA))
	sudo docker build -f Dockerfile.ubuntu-latest --pull \
		--build-arg S6_OVERLAY_VERSION=$(S6_OVERLAY_VERSION) \
		--build-arg COMMIT_SHA=$(COMMIT_SHA) \
		-t azmo/base:ubuntu-latest \
		-t azmo/base:ubuntu-latest-$(COMMIT_SHA) .
build-ubuntu-rolling:
	$(info COMMIT_SHA=$(COMMIT_SHA))
	sudo docker build -f Dockerfile.ubuntu-rolling --pull \
		--build-arg S6_OVERLAY_VERSION=$(S6_OVERLAY_VERSION) \
		--build-arg COMMIT_SHA=$(COMMIT_SHA) \
		-t azmo/base:ubuntu-rolling \
		-t azmo/base:ubuntu-rolling-$(COMMIT_SHA) .
build-alpine:
	$(info COMMIT_SHA=$(COMMIT_SHA))
	sudo docker build -f Dockerfile.alpine --pull \
		--build-arg S6_OVERLAY_VERSION=$(S6_OVERLAY_VERSION) \
		--build-arg COMMIT_SHA=$(COMMIT_SHA) \
		-t azmo/base:alpine \
		-t azmo/base:alpine-$(COMMIT_SHA) .
