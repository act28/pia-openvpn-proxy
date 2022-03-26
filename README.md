# Privoxy via Private Internet Access OpenVPN

> **Note:**
>
> Wireguard is not currently supported.

An Alpine Linux container running Privoxy and OpenVPN via Private Internet
Access

## Starting the VPN Proxy

### Using `docker run`

```Shell
docker run -d \
--cap-add=MKNOD \
--cap-add=NET_ADMIN \
--device=/dev/net/tun \
--name=vpn_proxy \
--dns=209.222.18.218 --dns=209.222.18.222 \
--restart=always \
-e "VPN_PROTOCOL=${VPN_PROTOCOL}" \
-e "REGION=${REGION}" \
-e "USERNAME=${USERNAME}}" \
-e "PASSWORD=${PASSWORD}" \
-e "LOCAL_NETWORK=192.168.1.0/24" \
-e "UID=1000" \
-e "GID=1000" \
-v /etc/localtime:/etc/localtime:ro \
-v </host/path/to/config>:/config \
-p 8118:8118 \
docker.io/act28/pia-openvpn-proxy
```

Substitute the environment variables for `VPN_PROTOCOL`, `REGION`, `USERNAME`,
`PASSWORD`, `LOCAL_NETWORK`, `UID`, `GID` as indicated.

**NOTE** UID/GID refer to the user id and group id on your host machine. You can
use `id -u <your username>` to find your UID, and `id -g <your username>` to
find your GID.

### Using `docker-compose`

An example `docker-compose-dist.yml` file has been provided. Copy/rename this
file to `docker-compose.yml` and substitute the environment variables as
indicated.

Then start the VPN Proxy via:

```Shell
docker-compose up -d
```

## Environment Variables

`VPN_PROTOCOL` defaults to `openvpn`. Alternatively, you can set this to `wireguard`.

`REGION` is optional. The default region is set to `Switzerland`. `REGION`
should match the supported PIA `.opvn` region config.

`USERNAME` / `PASSWORD` - Credentials to connect to PIA (different from your PIA
customer login!)

`LOCAL_NETWORK` - The CIDR mask of the local IP addresses (e.g. 192.168.1.0/24,
10.1.1.0/24) which will be accessing the proxy. This is so the response to a
request can be returned to the client (i.e. your browser).

`UID` / `GID` - Your UID/GID on your host machine.

## Connecting to the VPN Proxy

To connect to the VPN Proxy, set your browser proxy to 127.0.0.1:8118 (or
0.0.0.0:8118 if that does not work). If you override the docker port `-p`, make
sure to use that port number instead.

Alternatively, you can use the Proxy SwitchyOmega extension/addon as a
convenience.

[Proxy SwitchyOmega for
Chrome](https://chrome.google.com/webstore/detail/proxy-switchyomega/padekgcemlokbadohgkifijomclgjgif)

[Proxy SwitchyOmega for
Firefox](https://addons.mozilla.org/en-US/firefox/addon/switchyomega/)

## Like this project?

Consider signing up for a PIA plan thru my [affiliate
link](https://www.privateinternetaccess.com/pages/buy-vpn/dkrpia).
