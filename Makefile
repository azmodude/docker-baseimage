-include env.mk

env.mk: .env
		sed 's/"//g ; s/=/:=/' < $< > $@

.PHONY: all build push
.DEFAULT_GOAL := build

all: build push

build:
	sudo docker build --build-arg S6_OVERLAY_VERSION=$(S6_OVERLAY_VERSION) -t azmo/base .

push:
	sudo FFMPEG_BUILD=$(FFMPEG_BUILD) docker-compose push

encode:
	$(info ENCODEDIR=$(ENCODEDIR) RUID=$(RUID) RGID=$(RGID))
	sudo chown -R $(RUID):$(RGID) $(ENCODEDIR)/input && sudo FFMPEG_BUILD=$(FFMPEG_BUILD) docker-compose run --rm h265ize
