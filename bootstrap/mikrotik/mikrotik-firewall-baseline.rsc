# 2026-10-26 by RouterOS 7.23.7
# software id = IN5Y-SSMF
# Baseline configuration export for MikroTik Linux segment firewall.
# This file documents the known good baseline configuration.
# To restore: log into RouterOS and run /import file=mikrotik-firewall-baseline.rsc
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
add address=10.30.10.13 comment=fs01 list=linux-servers
/ip route
add dst-address=0.0.0.0/0 gateway=10.30.1.2
