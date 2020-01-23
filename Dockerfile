FROM alpine:3.11
MAINTAINER Ignatius Teo <ignatius.teo@gmail.com>

EXPOSE 8118

RUN apk update && apk add privoxy openvpn runit unzip

COPY app /app

RUN find /app -name run | xargs chmod u+x

ENV REGION="US East" \
    USERNAME="" \
    PASSWORD="" \
    UID="" \
    GID="" \
    LOCAL_NETWORK=192.168.1.0/24

VOLUME /config

CMD ["runsvdir", "/app"]
