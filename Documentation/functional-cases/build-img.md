# Build the system image(s) of meta-xt-prod-devel-rcar

[Back to **Table of Contents**](contents.md)

## List of functionalities

[place holder for start of short list of ## Functionalities]: # (This is used by tool to create a short content list as start point)

[Build the system image](#build-the-system-image)

[Flashing the firmware](#flashing-the-firmware)

[Flashing the system image](#flashing-the-system-image)

[place holder for end of short list of ## Functionalities]: # (This is used by tool to create a short content list as end point)


## Description

System images for different RCAR based target have to be created with YOCTO based build environment. 

The board specific image has to be flashed to an SD card or loaded from TFTP server. 

The firmware (including U-Boot) of Renesas board has to be flashed with specific firmware files of, since the original firmware lacks of support for XEN. 

At U-Boot, generated at build, a configuration to start the system is preconfigured, but has to be changed.

## Prerequisites

- A development PC with uptodate Ubuntu/Debian system
- Preparations and setup to build **Yocto** systems like described at [System Requirements](https://docs.yoctoproject.org/ref-manual/system-requirements.html)
- Alternatively Docker image for project described at **tbd**

## Functionalities
The following steps are described for Renesas RCAR Starter Kit Premium 3.0 (H3SK).

### Build the system image
The [Build description](https://github.com/xen-troops/meta-xt-prod-devel-rcar/blob/master/README.md) describes, how the system image has to be build.
The result is a sparsed file **full.img** (with information of file mapping) at project directory **<topdir\>**. With **ninja image-full full.img.gz full.img.bmap** or **ninja full.img.gz full.img.bmap** this image can be converted to a format for better deployment. This format (*.img.gz + *.img.bmap) can be flashed to an SD card with help of tool [bmaptool](https://github.com/intel/bmap-tools), available as package **bmap-tools** at UBUNTU and Debian build systems.

### Flashing the firmware
The firmware produced at **<topdir\>/yocto/build-domd/tmp/deploy/images/h3ulcb/firmware** can be flashed with help of description [Setup firmware at H3ULCB](https://elinux.org/R-Car/Boards/H3SK#Flashing_firmware). This firmware has to used because of specific setup for XEN.

### Flashing the system image
The system image can be flashed with

    bmaptool copy full.img.gz /dev/sdx

## Results

The target with inserted SD card is now ready to start. Have a look at [Start the system image of meta-xt-prod-devel-rcar](start-img.md)

## Additional hints
