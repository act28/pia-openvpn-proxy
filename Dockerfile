FROM docker.io/alpine:3.15

RUN apk --no-cache add ca-certificates=~20211220 \
    && apk --no-cache add privoxy=~3.0 \
    && apk --no-cache add openvpn=~2.5 \
    && apk --no-cache add runit=~2.1 \
    && apk --no-cache add curl=~7.80 \
    && apk --no-cache add unzip=~6.0 \
    && apk --no-cache add wireguard-tools=~1.0 \
    && apk --no-cache add jq=~1.6 \
    && apk --no-cache add sudo=~1.9

COPY app /app
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
