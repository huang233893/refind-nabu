[![refind_nabu](https://github.com/ClearStaff/refind-nabu/actions/workflows/main.yaml/badge.svg)](https://github.com/ClearStaff/refind-nabu/actions/workflows/main.yaml)

Refind for Xiaomi Mi Pad 5
==========================
This is a fork of refind with remapped keys, and perhaps some other fine
tuning for UEFI on Xiaomi Mi Pad 5.

To successfully build it manually for Xiaomi Mi Pad 5:
- use current Ubuntu LTS or Stable release channel for ARM64 (in chroot)
- enable source repositories:
  ```sed -i '/deb-src/s/^# //' /etc/apt/sources.list && apt update && apt-get update```
- install build-deps required for building refind
  ```apt-get build-dep refind```
- clone this repository and cd into it
- ```make OMIT_SBAT=1```

OMIT_SBAT is required unless i figure out how to enroll secure boot keys for it

Workflow
========
There is an ongoing progress to create GitHub workflow that
builds refind for Xiaomi Mi Pad 5, and (later) builds EFI partition image
to use with fastboot flash.

Original Sources
================================================
rEFInd original source code can be obtained from
https://sourceforge.net/projects/refind/

This fork has no relationships to the
main refind project other than being based on it.
