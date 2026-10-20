# 2026-10-14 22:06:03 by RouterOS 7.23.7
# software id = IN5Y-SSMF
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/iot wiliot servers
set *1 address=mqtt.us-east-2.prod.wiliot.cloud name="Wiliot US East"
/ip address
add address=10.30.1.3/24 comment="outside to debian-router" interface=ether1 \
    network=10.30.1.0
add address=10.30.10.1/24 comment="inside linux segment gateway" interface=\
    ether2 network=10.30.10.0
/ip firewall address-list
add address=10.30.10.10 comment=web01 list=linux-servers
add address=10.30.10.11 comment=mail01 list=linux-servers
add address=10.30.10.12 comment=db01 list=linux-servers
add address=10.30.10.13 comment=fs01 list=linux-servers
/ip firewall filter
add action=accept chain=input comment=input:established/related \
    connection-state=established,related
add action=drop chain=input comment="input:drop invalid" connection-state=\
    invalid
add action=accept chain=input comment="input:allow ping" protocol=icmp \
    src-address=10.30.10.0/24
add action=accept chain=input comment=\
    "input: ssh and winbox from linux segment" dst-port=22,8291 protocol=tcp \
    src-address=10.30.10.22
add action=drop chain=input comment="input:default deny"
add action=accept chain=forward comment=forward:established/related \
    connection-state=established,related
add action=drop chain=forward comment=spoof-loopback in-interface=ether1 \
    src-address=127.0.0.0/8
add action=drop chain=forward comment="forward:drop invalid" \
    connection-state=invalid
add action=accept chain=forward comment="forward: Linux segment outbound" \
    in-interface=ether2 out-interface=ether1
add action=add-src-to-address-list address-list=port-scanners \
    address-list-timeout=1d chain=forward comment=detect-port-scan \
    in-interface=ether1 protocol=tcp psd=21,3s,3,1
add action=drop chain=forward comment=drop-port-scanners src-address-list=\
    port-scanners
add action=accept chain=forward comment="forward: scored HTTP/HTTPS to web01" \
    dst-address=10.30.10.10 dst-port=80,443 in-interface=ether1 \
    out-interface=ether2 protocol=tcp
add action=accept chain=forward comment=scored-mail01 dst-address=10.30.10.11 \
    dst-port=25,587,110,143,993,995 in-interface=ether1 out-interface=ether2 \
    protocol=tcp
add action=accept chain=forward comment=scored-fs01 dst-address=10.30.10.13 \
    dst-port=21,990 in-interface=ether1 out-interface=ether2 protocol=tcp
add action=accept chain=forward comment=scored-ssh dst-address-list=\
    linux-servers dst-port=22 in-interface=ether1 out-interface=ether2 \
    protocol=tcp
add action=drop chain=forward comment="forward: default deny"
/ip route
add dst-address=0.0.0.0/0 gateway=10.30.1.2
/ip service
set ftp disabled=yes
set ssh address=10.30.10.22/32
set telnet disabled=yes
set www disabled=yes
set winbox address=10.30.10.22/32
set api disabled=yes
set api-ssl disabled=yes
/system identity
set name=mikrotik
