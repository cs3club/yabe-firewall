# 2026-10-13 19:05:33 by RouterOS 7.23.7
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
/ip firewall filter
add action=accept chain=input comment=input:establsihed/related \
    connection-state=established,related
add action=drop chain=input comment="input:drop invalid" connection-state=\
    invalid
add action=accept chain=input comment="input:allow ping" protocol=icmp
add action=accept chain=input comment=\
    "input: ssh and winbox from linux segment" dst-port=22,8291 protocol=tcp \
    src-address=10.30.10.0/24
add action=drop chain=input comment="input:default deny"
add action=accept chain=forward comment=forward:established/related \
    connection-state=established,related
add action=drop chain=forward comment="forward:drop invalid" \
    connection-state=invalid
add action=accept chain=forward comment="forward: Linux segment outbound" \
    in-interface=ether2 out-interface=ether1
add action=drop chain=forward comment="forward: default deny"
/system identity
set name=mikrotik
