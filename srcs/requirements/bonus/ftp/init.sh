#!/bin/bash

mkdir -p /var/run/vsftpd/empty
chmod 755 /var/run/vsftpd/empty

useradd -m "${ftp_user}"
echo "${ftp_user}:${ftp_pass}" | chpasswd
usermod -aG www-data ${ftp_user}

exec vsftpd /etc/vsftpd.conf