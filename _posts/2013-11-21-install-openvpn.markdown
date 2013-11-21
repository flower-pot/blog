---
layout: post
title: Installing open-vpn
teaser: notes on how I installed open-vpn on my server
---

    apt-get install openvpn

    cp -r /usr/share/doc/openvpn/examples/easy-rsa/2.0 /etc/openvpn/easy-rsa
    cd /etc/openvpn/easy-rsa

    export KEY_SIZE=4096

    . ./vars

    ./clean-all

    ./build-ca

    **input data**

    ./build-key-server server

    **input data**

    ./build-key client1

    ./build-dh

    openvpn --genkey --secret ta.key

/etc/openvpn/server.conf

    port 443
    proto tcp
    dev tun
    ca /etc/openvpn/easy-rsa/keys/ca.crt
    cert /etc/openvpn/easy-rsa/keys/server.crt
    key /etc/openvpn/easy-rsa/keys/server.key  # This file should be kept secret
    dh /etc/openvpn/easy-rsa/keys/dh4096.pem
    server 10.8.0.0 255.255.255.0
    ifconfig-pool-persist ipp.txt
    push "redirect-gateway def1 bypass-dhcp"
    keepalive 10 120
    tls-auth /etc/openvpn/easy-rsa/keys/ta.key 0 # This file is secret
    comp-lzo
    user nobody
    group nogroup
    persist-key
    persist-tun
    status openvpn-status.log
    log-append openvpn.log
    verb 3
