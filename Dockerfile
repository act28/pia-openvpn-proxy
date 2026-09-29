FROM alpine:3.24

RUN apk --no-cache add ca-certificates=20260909-r0 \
    && apk --no-cache add curl=8.22.0-r0 \
    && apk --no-cache add dante-server=1.4.4-r1 \
    && apk --no-cache add iptables=1.8.13-r0 \
    && apk --no-cache add jq=1.8.2-r0 \
    && apk --no-cache add openvpn=2.7.7-r0 \
    && apk --no-cache add privoxy=4.0.0-r0 \
    && apk --no-cache add runit=2.3.1-r0 \
    && apk --no-cache add sudo=1.9.17_p2-r1 \
    && apk --no-cache add unzip=6.0-r16 \
    && apk --no-cache add wireguard-tools=1.0.20260223-r0

COPY app/ovpn /app/ovpn
COPY app/wg /app/wg
COPY app/privoxy /app/privoxy
COPY app/socks /app/socks
COPY app/lib /opt/pia/lib
COPY etc /etc

RUN find /app -name "run" -exec chmod u+x {} \;
# Neutralize resolvconf to prevent init system and signature errors in Docker
RUN printf '#!/bin/sh\nexit 0\n' > /usr/sbin/resolvconf && chmod +x /usr/sbin/resolvconf

ENV VPN_PROTOCOL="openvpn" \
    REGION="switzerland" \
    USERNAME="" \
    PASSWORD="" \
    UID="" \
    GID="" \
    LOCAL_NETWORK=192.168.1.0/24 \
    ENABLE_SOCKS="false"

EXPOSE 1080/tcp
EXPOSE 1080/udp
EXPOSE 8118
VOLUME /config

CMD ["runsvdir", "/app"]
