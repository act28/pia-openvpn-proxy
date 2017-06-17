FROM alpine:latest
MAINTAINER Ignatius Teo <ignatius.teo@gmail.com>

EXPOSE 8080

RUN apk --update --no-cache add privoxy openvpn runit

COPY app /app

RUN find /app -name run | xargs chmod u+x

ENV REGION="US East" \
    USERNAME="" \
    PASSWORD="" \
    LOCAL_NETWORK=192.168.1.0/24

CMD ["runsvdir", "/app"]
