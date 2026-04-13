#!/bin/sh

# Determine VPN interface based on VPN_PROTOCOL if VPN_INTERFACE not set
: ${VPN_PROTOCOL:=openvpn}

# Set default VPN_INTERFACE based on protocol
if [ "$VPN_PROTOCOL" = "openvpn" ]; then
    : ${VPN_INTERFACE:=tun0}
elif [ "$VPN_PROTOCOL" = "wireguard" ]; then
    : ${VPN_INTERFACE:=pia}
fi
