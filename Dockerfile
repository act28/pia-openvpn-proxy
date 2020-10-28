FROM alpine:3.12

RUN apk --no-cache add ca-certificates=~20191127-r4
RUN apk --no-cache add privoxy=~3.0.28-r0
RUN apk --no-cache add openvpn=~2.4.9-r0
RUN apk --no-cache add runit=~2.1.2-r3
RUN apk --no-cache add wget=~1.20.3-r1
RUN apk --no-cache add unzip=~6.0-r7

COPY app /app
COPY etc /etc

RUN find /app -name "run" -exec chmod u+x {} \;

ENV REGION="US East" \
    USERNAME="" \
    PASSWORD="" \
    UID="" \
    GID="" \
    LOCAL_NETWORK=192.168.1.0/24

EXPOSE 8118
VOLUME /config

CMD ["runsvdir", "/app"]
