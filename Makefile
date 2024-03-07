DOCKER_REPO := docker.io/act28/pia-openvpn-proxy

-include make_env

CONTAINER_NAME ?= vpn_proxy
CONTAINER_INSTANCE ?= default
VPN_PROTOCOL ?= openvpn

OPTS ?= \
--cap-add=MKNOD \
--cap-add=NET_ADMIN \
--device=/dev/net/tun \
--dns=209.222.18.218 --dns=209.222.18.222 --dns=1.1.1.1 --dns=1.0.0.1 --dns=9.9.9.9 --dns=205.204.88.60 \
--privileged \

.PHONY: shell build builder start stop rm release test

shell:
	@docker exec -it $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) /bin/sh

build:
	@docker build -t $(DOCKER_REPO):$(VERSION) .

start:
	@docker run -d --restart=always --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) $(OPTS) $(PORTS) $(VOLUMES) $(ENV) $(DOCKER_REPO):$(VERSION)

stop:
	@docker stop $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) > /dev/null 2>&1 || true

rm: stop
	@docker rm $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) > /dev/null 2>&1 || true

builder:
	@docker buildx create --name container --driver=docker-container

release:
	@docker buildx build --builder=container --platform=linux/amd64,linux/arm64 -t $(DOCKER_REPO):$(VERSION) -t $(DOCKER_REPO):latest --push .

test::
	docker run --rm --network=container:$(CONTAINER_NAME)-$(CONTAINER_INSTANCE) docker.io/appropriate/curl -s ipecho.net/plain
