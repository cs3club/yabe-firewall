# RouterOS 7.23.7
# software id = IN5Y-SSMF
#
# Bootstrap configuration for MikroTik Linux segment firewall.
# PURPOSE: Restore minimum configuration so Ansible can connect.
# This file only configures interfaces, IPs, admin user and routing.
# All firewall rules are managed through Ansible — do NOT add them here.
#
# To restore: log into RouterOS console and run:
#   /import file=mikrotik-firewall-baseline.rsc

/ip address
add address=10.30.1.3/24 comment="outside to debian-router" interface=ether1 \
    network=10.30.1.0
add address=10.30.10.1/24 comment="inside linux segment gateway" interface=\
    ether2 network=10.30.10.0
/ip route
add dst-address=0.0.0.0/0 gateway=10.30.1.2
/ip service
set ssh address=10.30.10.22/32
/system identity
set name=mikrotik
