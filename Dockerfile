FROM alpine:3.14

RUN apk --no-cache add ca-certificates=~20191127 \
    && apk --no-cache add privoxy=~3.0 \
    && apk --no-cache add openvpn=~2.5 \
    && apk --no-cache add runit=~2.1 \
    && apk --no-cache add wget=~1.21 \
    && apk --no-cache add unzip=~6.0

COPY app /app
COPY etc /etc

RUN find /app -name "run" -exec chmod u+x {} \;

ENV REGION="switzerland" \
    USERNAME="" \
    PASSWORD="" \
    UID="" \
    GID="" \
    LOCAL_NETWORK=192.168.1.0/24

EXPOSE 8118
VOLUME /config

CMD ["runsvdir", "/app"]
