DOCKER_REPO := docker.io/act28/pia-openvpn-proxy

-include make_env

CONTAINER_NAME ?= vpn_proxy
CONTAINER_INSTANCE ?= default
VPN_PROTOCOL ?= openvpn
REGION ?= switzerland
CONFIG_PATH ?= ./config
HTTP_PORT ?= 8118
SOCKS_PORT ?= 1080
LOCAL_NETWORK ?= 10.1.1.0/24
VERSION ?= latest

DNS ?= \
--dns=209.222.18.218 --dns=209.222.18.222 --dns=9.9.9.9 --dns=1.1.1.1

CAPS := \
--cap-add=NET_ADMIN \
--cap-add=NET_RAW \

OVPN_OPTS := \
$(CAPS) \
--cap-add=MKNOD \
--device=/dev/net/tun

WG_OPTS := \
$(CAPS) \
--sysctl="net.ipv4.conf.all.src_valid_mark=1" \
--privileged=true

ifeq ($(VPN_PROTOCOL),wireguard)
OPTS := $(WG_OPTS)
else
OPTS := $(OVPN_OPTS)
endif

ENV := \
-e USERNAME=$(USERNAME) \
-e PASSWORD=$(PASSWORD) \
-e VPN_PROTOCOL=$(VPN_PROTOCOL) \
-e REGION=$(REGION) \
-e GID=$$(id -g $$USER) \
-e UID=$$(id -u $$USER) \
-e LOCAL_NETWORK=$(LOCAL_NETWORK)

VOLUMES := \
-v $(CONFIG_PATH):/config \
-v /etc/localtime:/etc/localtime:ro


ifeq ($(shell printf '%s\n' "$(VERSION)" "2.1.3" | sort -V | head -n1),$(VERSION))
PORTS := \
-p $(HTTP_PORT):8118
else
PORTS := \
-p $(HTTP_PORT):8118 \
-p $(SOCKS_PORT):1080/tcp \
-p $(SOCKS_PORT):1080/udp
endif

.PHONY: shell build builder start stop rm release test

.DEFAULT_GOAL := start

shell:
	@docker exec -it $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) /bin/sh

build:
	@docker build -t $(DOCKER_REPO):$(VERSION) .

start:
	@docker run -d --restart=always --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) $(OPTS) $(DNS) $(PORTS) $(VOLUMES) $(ENV) $(DOCKER_REPO):$(VERSION)

stop:
	@docker stop $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) > /dev/null 2>&1 || true

rm: stop
	@docker rm $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) > /dev/null 2>&1 || true

builder:
	@docker buildx create --name container --driver=docker-container

release:
	@docker buildx build --builder=container --platform=linux/amd64,linux/arm64,linux/arm/v7 -t $(DOCKER_REPO):$(VERSION) -t $(DOCKER_REPO):latest --push .

test::
	# Test IP
	docker run --rm --network=container:$(CONTAINER_NAME)-$(CONTAINER_INSTANCE) docker.io/appropriate/curl -s ipecho.net/plain
	# Check resolv.conf
	docker exec $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) cat /etc/resolv.conf
	# Test DNS resolution goes through VPN
	docker exec $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) nslookup google.com
