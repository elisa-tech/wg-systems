# Setup of XEN boot image for SD card

[Back to **Table of Contents**](Readme.md)

This description explains the setup of a boot image at SD card slot of ZCU102. This is only needed, when the ZCU102 board boots from SD card. Incase of booting from QSPI flash this step can be ignored.

## General
The image has a MSDOS partitioning scheme with one fat formatted partition. There are multiple ways to create such a SD card, but
this description bases on following tools:
<a name="debos"></a>
- Debos: Image creation tool, available at Debian. Description at <https://packages.debian.org/bullseye/debos>
- Bmaptool: Image writing tool. Description at <https://packages.debian.org/bullseye/bmap-tools>

## Create an image file
The related .yaml recipe is provided at [image_boot.yaml](configs/image_boot.yaml).
The image file can be created by

    sudo debos image_boot.yaml

which creates a file **xen-boot.img**.

## Setup the files

### Mount the image file
The image file can be mounted to a given mount directory with

    mkdir rootbootp1/
    LOOPDEV=$(sudo losetup -f)
    sudo losetup -P $LOOPDEV xen-boot.img
    sudo mount ${LOOPDEV}p1 rootbootp1/

### Copy the boot.bin

**Boot.bin** is created by [Build parts of Domain-0 with XEN](cr-xen-parts.md) and described at 
[Overview to all parts of XEN demo](overview2parts.md#bootbin).

The file has to be copied with

    sudo cp boot.bin rootbootp1/

### Unmount the image file

The image file can be umounted with 

    sudo umount rootbootp1/
    sudo losetup -d $LOOPDEV

## Create the bmapfile 

    bmaptool create xen-boot.img > xen-boot.img.bmap

## Compress the image file

For a better deployment the image file can be compressed.

   gzip xen-demo.img   # Name is changed to xen-demo.img.gz

# Flash the image file to an SD card

The image file can be flashed to SD card (/dev/sdx) with

    sudo bmaptool copy xen-boot.img.gz /dev/sdx

Bmaptool requires the file **xen-boot.bmap** at the same directory like **xen-boot.img** / **xen-boot.img.gz**


 

