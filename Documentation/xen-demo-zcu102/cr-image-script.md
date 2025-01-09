# Create XEN demo and boot images with a simple script

[Back to **Table of Contents**](Readme.md)

This description explains the usage of the script [cr-image-script.sh](configs/cr-image-script.sh) as implementation example for [Setup of XEN demo image for USB stick or SD card (restricted function)](cr-demo-image.md) and [Setup of XEN boot image for SD card](cr-boot-image.md).

## General
The script [cr-image-script.sh](configs/cr-image-script.sh) is created by a tool. So its documentation state is not sufficient. But it works and demonstrates all aspects of creating XEN demo and boot images.

## Prelimanaries

### Installed packages

The script is developed for **Bash**, but should also run with other command processors.
The installation of **Debos** and **bmap-tools** (described at [Setup of XEN boot image for SD card:Debos](cr-boot-image.md#debos) is assumed.
The package **mountimage** from [https://github.com/mtt2hi/mountimage](https://github.com/mtt2hi/mountimage) should be built and installed. 
It's can be used at all Debian derivates. For other systems there are no installation rules but to copy *usr/bin/mountimage* to */usr/bin/*. But then no man page and predefined profiles at */etc/mountimage/* are installed. But for this use case it will be enough.

### Workspace

A work directory with more than 10GB should fit.

## Install the script

There are no restrictions to install the script. The script calls some tools with **sudo**. Take care for his.

## Directories with data for script

### ARTIFACTS/

**ARTIFACTS/** keeps all binaries artifacts.
Atm the following files are assumed:

#### XEN DOM0 (have a look to [Build parts of Domain-0 with XEN](cr-xen-parts.md#artefacts))

- <ARTIFACTS\>/image/xen-rootfs.cpio.gz
- <ARTIFACTS\>/image/xen
- <ARTIFACTS\>/image/boot.bin
- <ARTIFACTS\>/image/Image
- <ARTIFACTS\>/image/system.dtb

#### DTB snippets (have a look to [Overview to all parts of XEN demo](overview2parts.md#dtbsnippets))

- <ARTIFACTS\>/dtb-snippets/passthrough-example-part_mmc.dtb
- <ARTIFACTS\>/dtb-snippets/passthrough-example-part.dtb

#### Petalinux (have a look to [Get parts of Petalinux system](get-petalinux-parts.md#artefacts)

- <ARTIFACTS\>/petalinux/rootfs.cpio.gz
- <ARTIFACTS\>/petalinux/rootfs.tar.gz
- <ARTIFACTS\>/petalinux/Image

#### Zephyr (have a look to [Get parts of Zephyr system](get-zephyr-parts.md#artefacts)

- <ARTIFACTS\>/zephyr/zephyr-domz

#### Apertis (have a look to [Get parts of Apertis system](get-apertis-parts.md#artefacts)

- <ARTIFACTS\>/apertis/Image
- <ARTIFACTS\>/apertis/Initrd
 
### CONFIGS/

**CONFIGS/** keeps the data from ![configs/](./configs).

## OUTPUT/

At **OUTPUT/** the results of the script will be created

### XEN Demo image

- <OUTPUT\>/xen-demo.img.gz
- <OUTPUT\>/xen-demo.img.bmap
- <OUTPUT\>/xen-demo.img

### XEN Boot image

- <OUTPUT\>/xen-boot.img.gz
- <OUTPUT\>/xen-boot.img.bmap
- <OUTPUT\>/xen-boot.img

## Excution of script [cr-image-script.sh](configs/cr-image-script.sh)

The script can be called in two ways.

### Call with parameters

        cr-image-script.sh <ARTIFACTS> <CONFIGS> <OUTDIR>

### Call with predefined variables

        export ARTIFACTS=<ARTIFACTS>
        export CONFIGS=<CONFIGS>
        export OUTDIR=<OUTDIR>
 
        cr-image-script.sh



 