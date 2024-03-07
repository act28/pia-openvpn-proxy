FROM alpine:3

RUN apk --no-cache add ca-certificates=~20230506-r0 \
    && apk --no-cache add privoxy=~3.0 \
    && apk --no-cache add openvpn=~2.6 \
    && apk --no-cache add runit=~2.1 \
    && apk --no-cache add curl=~8.5 \
    && apk --no-cache add unzip=~6.0 \
    && apk --no-cache add wireguard-tools=~1.0 \
    && apk --no-cache add jq=~1.7 \
    && apk --no-cache add sudo=~1.9 \
    && apk --no-cache add coreutils=~9.4 \
    && apk --no-cache add ncurses=~6.4 \
    && apk --no-cache add bash=~5.2 \
    && apk --no-cache add iptables=~1.8

COPY app/ovpn /app/ovpn
COPY app/wg /app/wg
COPY app/privoxy /app/privoxy
COPY etc /etc

RUN find /app -name "run" -exec chmod u+x {} \;

ENV VPN_PROTOCOL="openvpn" \
    REGION="switzerland" \
    USERNAME="" \
    PASSWORD="" \
    UID="" \
    GID="" \
    LOCAL_NETWORK=192.168.1.0/24

EXPOSE 8118
VOLUME /config

CMD ["runsvdir", "/app"]
