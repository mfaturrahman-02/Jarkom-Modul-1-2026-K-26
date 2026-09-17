#!/bin/bash

cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
  address 192.224.1.2
  netmask 255.255.255.0
  gateway  192.224.1.1

EOF
echo "nameserver 8.8.8.8" > /etc/resolv.conf
apt update
which ftp &>/dev/null 2>&1 || apt install ftp lftp -y
