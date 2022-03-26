DOCKER_REPO := docker.io/act28/pia-openvpn-proxy

-include .makefiles/Makefile
-include .makefiles/pkg/docker/v1/Makefile

.makefiles/%:
	curl -sfL https://makefiles.dev/v1 | bash /dev/stdin "$@"

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

#--privileged \

.PHONY: shell run start stop rm release

shell:
	@docker exec -it $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) /bin/sh

start:
	@docker run -d --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) $(OPTS) $(PORTS) $(VOLUMES) $(ENV) $(DOCKER_REPO):$(DOCKER_TAGS)

stop:
	@docker stop $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) > /dev/null 2>&1 || true

rm: stop
	@docker rm $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) > /dev/null 2>&1 || true

release:
	DOCKER_TAGS=$(VERSION) make docker-push

test::
	docker run --rm --network=container:$(CONTAINER_NAME)-$(CONTAINER_INSTANCE) docker.io/appropriate/curl -s ipecho.net/plain
