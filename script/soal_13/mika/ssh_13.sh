#!/bin/bash

# 1. Buat user mika_admin di Mika jika belum ada
useradd -m -s /bin/bash mika_admin
echo "mika_admin:password123" | chpasswd

# 2. Masuk sebagai user mika_admin
su - mika_admin

# 3. Generate pasangan kunci SSH (tekan Enter untuk semua prompt default/tanpa passphrase)
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""
