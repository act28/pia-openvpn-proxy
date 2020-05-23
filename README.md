[![logo](https://www.privateinternetaccess.com/assets/PIALogo2x-09ca10950967bd3be87a5ef7730a69e07892d519cfc8f15228bec0a4f6102cc1.png)](https://www.privateinternetaccess.com/pages/network/dkrpia)

# Privoxy via Private Internet Access OpenVPN
An Alpine Linux container running Privoxy and OpenVPN via Private Internet Access

Protect your browsing activities through an encrypted and anonymized VPN proxy!

You will need a [PrivateInternetAccess](https://www.privateinternetaccess.com/pages/how-it-works/dkrpia) account.
If you don't have one, you can [sign up here](https://www.privateinternetaccess.com/pages/buy-vpn/dkrpia) for one.

## Starting the VPN Proxy

```Shell
docker run -d \
--cap-add=NET_ADMIN \
--device=/dev/net/tun \
--name=vpn_proxy \
--dns=209.222.18.218 --dns=209.222.18.222 \
--restart=always \
-e "REGION=<region>" \
-e "USERNAME=<pia_username>" \
-e "PASSWORD=<pia_password>" \
-e "LOCAL_NETWORK=192.168.1.0/24" \
-e "UID=1000" \
-e "GID=1000" \
-v /etc/localtime:/etc/localtime:ro \
-v </host/path/to/config/data>:/config \
-p 8118:8118 \
act28/pia-openvpn-proxy
```

Substitute the environment variables for `REGION`, `USERNAME`, `PASSWORD`, `LOCAL_NETWORK`, `UID`, `GID` as indicated.

**NOTE** UID/GID refer to the user id and group id on your host machine. You can use `id -u <your username>` to find your UID. And `id -g <your username>` to find your GID.

A `docker-compose-dist.yml` file has also been provided. Copy this file to `docker-compose.yml` and substitute the environment variables are indicated.

Then start the VPN Proxy via:

```Shell
docker-compose up -d
```

### Environment Variables
`REGION` is optional. The default region is set to `US East`. `REGION` should match the supported PIA `.opvn` region config.

See the [PIA VPN Tunnel Network page](https://www.privateinternetaccess.com/pages/network/dkrpia) for details.
Use the `Location` value for your `REGION`.

`USERNAME` / `PASSWORD` - Credentials to connect to PIA (different from your PIA customer login!)

`LOCAL_NETWORK` - The CIDR mask of the local IP addresses (e.g. 192.168.1.0/24, 10.1.1.0/24) which will be accessing the proxy. This is so the response to a request can be returned to the client (i.e. your browser).

`UID` / `GID` - Your UID/GID on your host machine.

## Connecting to the VPN Proxy

To connect to the VPN Proxy, set your browser proxy to 127.0.0.1:8118 (or 0.0.0.0:8118 if that does not work). If you override the docker port `-p`, make sure to use that port number instead.

Alternatively, you can use the Proxy SwitchyOmega extension/addon as a convenience.

[Proxy SwitchyOmega for Chrome](https://chrome.google.com/webstore/detail/proxy-switchyomega/padekgcemlokbadohgkifijomclgjgif)

[Proxy SwitchyOmega for Firefox](https://addons.mozilla.org/en-US/firefox/addon/switchyomega/)
