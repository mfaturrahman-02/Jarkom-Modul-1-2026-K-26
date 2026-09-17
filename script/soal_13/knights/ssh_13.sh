#!/bin/bash
# 1. Buat user mika_admin di Knights agar memiliki home directory
useradd -m -s /bin/bash mika_admin
echo "mika_admin:password123" | chpasswd

# 2. Buat folder .ssh untuk mika_admin di Knights
mkdir -p /home/mika_admin/.ssh
chmod 700 /home/mika_admin/.ssh
chown -R mika_admin:mika_admin /home/mika_admin/.ssh
