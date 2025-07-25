#!/usr/bin/env bash

# exit on any error
set -e

WORK_DIR="build"

# clean up workdir if exists and recreate it
if [ -d "$WORK_DIR" ]; then rm -Rf $WORK_DIR; fi
mkdir $WORK_DIR

# download ubuntu rootfs.img
wget -O $WORK_DIR/rootfs.tar.gz https://cdimage.ubuntu.com/ubuntu-base/releases/25.04/release/ubuntu-base-25.04-base-arm64.tar.gz

# extract rootfs
mkdir $WORK_DIR/temprootfs
bsdtar -xpf $WORK_DIR/rootfs.tar.gz -C $WORK_DIR/temprootfs

# make temporary project path in build and copy source to it
mkdir $WORK_DIR/temprootfs/refind
rsync -av --progress ./ ./$WORK_DIR/temprootfs/refind --exclude $WORK_DIR

# create resolv.conf in temporary chroot
rm $WORK_DIR/temprootfs/etc/resolv.conf
echo "nameserver 1.1.1.1" >> $WORK_DIR/temprootfs/etc/resolv.conf

# mount necessary directories
mount --bind /dev $WORK_DIR/temprootfs/dev
mount --bind /dev/pts $WORK_DIR/temprootfs/dev/pts
mount --bind /proc $WORK_DIR/temprootfs/proc
mount --bind /sys $WORK_DIR/temprootfs/sys

# enable source packages
chroot $WORK_DIR/temprootfs /bin/bash -c "sed -i '/deb-src/s/^# //' /etc/apt/sources.list && apt update && apt-get update"

# download build-deps of refind
chroot $WORK_DIR/temprootfs /bin/bash -c "apt-get -y install build-essential"
chroot $WORK_DIR/temprootfs /bin/bash -c "apt-get -y build-dep refind"

# build refind
chroot $WORK_DIR/temprootfs /bin/bash -c "cd refind && make OMIT_SBAT=1"

cp $WORK_DIR/temprootfs/refind/refind/refind_aa64.efi refind-nabu.efi

# unmount everything
umount $WORK_DIR/temprootfs/sys
umount $WORK_DIR/temprootfs/proc
umount $WORK_DIR/temprootfs/dev/pts
umount $WORK_DIR/temprootfs/dev

# cleanup
rm -rf $WORK_DIR
