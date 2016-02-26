#!/bin/bash
yum install lvm2
vgcreate cason /dev/xvdb

lvcreate -l 50%VG cason -n web
mkfs.ext4 /dev/cason/web
lvcreate -l 50%VG cason -n data
mkfs.ext4 /dev/cason/data

mkdir -p /data
mkdir -p /web

echo "/dev/cason/data /data                 ext4    defaults        0 0" >> /etc/fstab
echo "/dev/cason/web  /web                  ext4    defaults        0 0" >> /etc/fstab

mount /data
mount /web
