
#!/bin/bash

cat <<EOF > /etc/network/interfaces
auto eth1
iface eth1 inet static
  address 192.224.1.1
  netmask 255.255.255.0

auto eth2
iface eth2 inet static
  address 192.224.2.1
  netmask 255.255.255.0

auto eth3
iface eth3 inet static
  address 192.224.3.1
  netmask 255.255.255.0

EOF

echo nameserver 192.168.122.1 > /etc/resolv.conf
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

apt update
which iptables &>/dev/null || apt install iptables -y
which vsftpd &>/dev/null || apt install vsftpd -y
which sshd &>/dev/null || apt install openssh-server -y
