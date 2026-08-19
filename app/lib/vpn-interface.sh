#!/bin/sh

# Determine VPN interface based on VPN_PROTOCOL if VPN_INTERFACE not set
: ${VPN_PROTOCOL:=openvpn}

# Set default VPN_INTERFACE based on protocol
if [ "$VPN_PROTOCOL" = "openvpn" ]; then
    : ${VPN_INTERFACE:=tun0}
elif [ "$VPN_PROTOCOL" = "wireguard" ]; then
    : ${VPN_INTERFACE:=pia}
fi

is_vpn_up() {
    local interface=$1
    ip link show "$interface" >/dev/null 2>&1
}

wait_for_vpn_down() {
    local interface=$1
    while is_vpn_up "$interface"; do
        sleep 60
    done
}