#!/bin/bash

echo "[*] Memulai Konfigurasi FTP Server pada Chisa..."

# 1. Buat folder shared
mkdir -p /var/wired/data

# 2. Buat user sistem jika belum ada
id -u alice &>/dev/null || useradd -d /var/wired/data -s /bin/bash alice
id -u mika &>/dev/null  || useradd -d /var/wired/data -s /bin/bash mika
id -u eiri &>/dev/null  || useradd -d /var/wired/data -s /bin/bash eiri

# Set password untuk masing-masing user
echo "alice:password123" | chpasswd
echo "mika:password123"  | chpasswd
echo "eiri:password123"  | chpasswd

# Set hak akses direktori shared
chown -R alice:alice /var/wired/data
chmod 775 /var/wired/data

# 3. Buat konfigurasi utama vsftpd (Sintaks Valid)
cat << 'EOF' > /etc/vsftpd.conf
listen=YES
listen_ipv6=NO
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022

# Blacklist Eiri via userlist
userlist_enable=YES
userlist_file=/etc/vsftpd.user_list
userlist_deny=YES

# Per-user config untuk Mika (Read-Only)
user_config_dir=/etc/vsftpd_user_conf
EOF

# 4. Blacklist user Eiri
echo "eiri" > /etc/vsftpd.user_list

# 5. Konfigurasi Read-Only untuk user Mika
mkdir -p /etc/vsftpd_user_conf
echo "write_enable=NO" > /etc/vsftpd_user_conf/mika

# 6. Restart Layanan vsftpd khusus Docker (tanpa systemctl)
service vsftpd restart

echo "[+] Konfigurasi FTP Server Selesai!"
