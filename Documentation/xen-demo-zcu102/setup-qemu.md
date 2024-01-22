# Setup Qemu system with demo and boot image

[Back to **Table of Contents**](Readme.md)

This description explains the setup of qemu system for Xilinx ZCU102.

## General
Qemu for Xilinx differs from real hardware at this use case:

- About 5 times slowers
- USB ethernet adapter can not be simulated. So the test case described at [Demo case with passed through NIC controller](test-pt-net.md) only works without network interaction  between Domain-0 and VM.

## Install Qemu for Xilinx

Qemu for Xilinx can be got from [https://github.com/Xilinx/qemu.git](https://github.com/Xilinx/qemu.git). A tag v2022.2 is working, but pretty sure also newer versions can be used.
Build instructions can be found at [https://wiki.qemu.org/Hosts/Linux](https://wiki.qemu.org/Hosts/Linux).

### Executables
From Qemu install only the following executables are needed.

- **qemu-system-microblazeel** to setup ZCU system
- **qemu-system-aarch64** to run XEN system

### Network configuration

There is a tap device **tap1** needed, which is connected to a network bridge (e.g. **br0**), which attaches the network interface for internet connection.

Some technical instructions can be found e.g. at [https://gist.github.com/extremecoders-re/e8fd8a67a515fee0c873dcafc81d811c#setup](https://gist.github.com/extremecoders-re/e8fd8a67a515fee0c873dcafc81d811c#setup).

## Work directory

Probably it's possible to start **Qemu** without a work directory, but for further explanation such a directory is assumed as **<qemu-workdir\>**.

## Prepare some artifacts to run Qemu

The artefacts, described at [Build parts of Domain-0 with XEN](cr-xen-parts.md#artefactsqemu), have to be loaded at directory **<qemu-workdir\>**

- arm-trusted-firmware.elf
- pmu-firmware-zcu102-zynqmp.elf
- pmu-rom.elf
- u-boot.elf
- zcu102-arm.dtb
- zynqmp-pmu.dtb

## Provide images xen-boot.img and xen-demo.img

At [Build parts of Domain-0 with XEN](cr-xen-parts.md) the parts to setup both [**xen-boot.img**](cr-boot-image.md) (SD card) and [**xen-demo.img**](cr-demo-image.md) (USB stick or restricted functionality at SD card) arre described.

At [Create XEN demo and boot images with a simple script](cr-image-script.md) a simple script to create the images is described. 
The created files **xen-demo.img** and **xen-boot.img** have to be copied to **<qemu-workdir\>**.

Alternatively it is possible to create a new image and extract **xen-*.img.gz/bmap** with **bmaptool** to new created image file.

Example:

```
truncate -r xen-demo.img new.img
bmaptool copy xen-demo.img.gz new.img
```


## Start Qemu

Qemu with XEN is started with two steps. TThere are two scripts prepared to show the parameters.
The directory **/tmp/tmpt7z53_ew** is nothing special and can be replaced with any empty and user accessible directory.

### Start part 1 with *qemu-system-microblazeel*

The script ![call-env.sh](./configs/qemu-xilinx-scripts/call-env.sh) shows, how to run **qemu-system-microblazeel**  to setup ZCU102 machine and has to be copied to **<qemu-workdir\>**.

It expects all mentioned files at **<qemu-workdir\>**. 

After start of environment it waits for part 2. At single command shell the script can be started at background (**call-env.sh &**).

### Start part 2 with *qemu-system-aarch64*

The script ![call-xen.sh](./configs/qemu-xilinx-scripts/call-xen.sh) shows, how to run **qemu-system-aarch64**  to start XEN at Qemu and has to be copied to **<qemu-workdir\>**.

It expects all mentioned files at **<qemu-workdir\>** and a successfully started part 1.

After start somthing like  ![bootlog-example.log](./configs/qemu-xilinx-scripts/bootlog-example.log) should be displayed.

The implemented user **petalinux** requires at very first start a new password. 

Then the first test like [Demo case with simple Linux VM (Petalinux)](test-simple.md) can be executed.






 






