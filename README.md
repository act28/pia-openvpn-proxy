# Privoxy via Private Internet Access OpenVPN/WireGuard

An Alpine Linux container running Privoxy and OpenVPN/WireGuard via Private Internet
Access

> **Announcements:**
>
> - 2026-04-13 added socks5 tcp/udp proxy, switched ovpn to use udp + aes-256-gcm, security hardening 
> - 2025-12-08 added linux/arm/v7 image support
> - 2024-03-18 added linux/arm64 image support
> - 2024-03-07 added wireguard support

## Starting the VPN Proxy

### Using `docker run`

#### OpenVPN Example

```Shell
docker run -d \
--cap-add=MKNOD \
--cap-add=NET_ADMIN \
--cap-add=NET_RAW \
--device=/dev/net/tun \
--name=vpn_proxy \
--dns=209.222.18.218 --dns=209.222.18.222 \
--restart=always \
-e "VPN_PROTOCOL=openvpn" \
-e "REGION=switzerland" \
-e "USERNAME=${USERNAME}" \
-e "PASSWORD=${PASSWORD}" \
-e "LOCAL_NETWORK=192.168.1.0/24" \
-e "UID=1000" \
-e "GID=1000" \
-v /etc/localtime:/etc/localtime:ro \
-v </host/path/to/config>:/config \
-p 8118:8118 \
-p 1080:1080 \
docker.io/act28/pia-openvpn-proxy
```

#### WireGuard Example

```Shell
docker run -d \
--cap-add=NET_ADMIN \
--cap-add=NET_RAW \
--sysctl="net.ipv4.conf.all.src_valid_mark=1" \
--privileged=true \
--name=vpn_proxy \
--dns=209.222.18.218 --dns=209.222.18.222 \
--restart=always \
-e "VPN_PROTOCOL=wireguard" \
-e "REGION=swiss" \
-e "USERNAME=${USERNAME}" \
-e "PASSWORD=${PASSWORD}" \
-e "LOCAL_NETWORK=192.168.1.0/24" \
-e "UID=1000" \
-e "GID=1000" \
-v /etc/localtime:/etc/localtime:ro \
-v </host/path/to/config>:/config \
-p 8118:8118 \
-p 1080:1080 \
docker.io/act28/pia-openvpn-proxy
```

**NOTE**
Substitute the environment variables for `VPN_PROTOCOL`, `REGION`, `USERNAME`,
`PASSWORD`, `LOCAL_NETWORK`, `UID`, `GID` as indicated.

### Using `docker-compose`

An example `docker-compose-dist.yml` file has been provided. Copy/rename this
file to `docker-compose.yml` and substitute the environment variables as
indicated.

Then start the VPN Proxy via:

```Shell
docker-compose up -d
```

## Environment Variables

| Variable Name | Description |
|---------------|-------------|
| `VPN_PROTOCOL` | `wireguard` or `openvpn` (Default: `openvpn`) |
| `REGION` | Default (OpenVPN): `switzerland`. See [Wireguard](#wireguard) section below for more information. |
| `USERNAME` | Your PIA Username |
| `PASSWORD` | Your PIA Password |
| `LOCAL_NETWORK` | The CIDR mask of your local IP addresses (e.g. 192.168.1.0/24,
10.1.1.0/24). |
| `UID` | Use `id -u $USER` to find your UID |
| `GID` | Use `id -g $USER` to find your GID. |

## Wireguard

PIA's wireguard uses a JSON API request over HTTPS to configure and setup the
tunnel connection. You will have to search through the returned JSON
data to find the `id` key of your preferred region.

You can find the current region list [here](https://serverlist.piaservers.net/vpninfo/servers/v6).

The open-source [PIA manual-connection](https://github.com/pia-foss/manual-connections)
script uses a latency check to determine the "best" region, which may not be
ideal, in certain circumstances. I have chosen not to include a latency check
at this time, but may consider it in another iteration.

## Connecting to the VPN Proxy

To connect to the VPN Proxy, set your browser proxy to 127.0.0.1:8118 (or
0.0.0.0:8118 if that does not work). If you override the docker port `-p`, make
sure to use that port number instead.

Alternatively, you can use the ZeroOmega extension/addon as a convenience.

[Proxy SwitchyOmega 3 (ZeroOmega) for Chrome](https://chromewebstore.google.com/detail/proxy-switchyomega-3-zero/pfnededegaaopdmhkdmcofjmoldfiped)

[ZeroOmega--Proxy SwitchyOmega V3 for FireFox](https://addons.mozilla.org/en-US/firefox/addon/zeroomega/)

## SOCKS5 Proxy

A SOCKS5 proxy has been provided to support tcp/udp routing through the VPN tunnel.
Use 127.0.0.1:1080 (or 0.0.0.0:1080)

## Like this project? Help support it.

[Donate](https://trocador.app/anonpay/?ticker_to=btc&network_to=Lightning&address=bc1qv8n70d4nu02j4aehwpaw47dguphdwv303hqdls&donation=True&simple_mode=True&amount=0.0001&name=act28&description=Docker+Hub+Donation&ticker_from=btc&network_from=Lightning&bgcolor=00000000)

[Onion](http://trocadorfyhlu27aefre5u7zri66gudtzdyelymftvr4yjwcxhfaqsid.onion/anonpay/?ticker_to=btc&network_to=Lightning&address=bc1qv8n70d4nu02j4aehwpaw47dguphdwv303hqdls&donation=True&simple_mode=True&amount=0.0001&name=act28&description=Docker+Hub+Donation&ticker_from=btc&network_from=Lightning&bgcolor=00000000)
