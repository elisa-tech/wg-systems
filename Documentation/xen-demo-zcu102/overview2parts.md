# Overview to all parts of XEN demo

[Back to **Table of Contents**](Readme.md)

## Boot system and Domain-0 with XEN

Description to create all parts at [Build parts of Domain-0 with XEN](cr-xen-parts.md)

### <a name="bootbin"></a>boot.bin

Boot file for ZCU102 with U-Boot bootloader. 

### Image

Linux image for Domain-0. 

### system.dtb
System device tree for XEN image.

### xen
XEN image. 
 
### xen-rootfs.cpio.gz
InitramFS for Domain-0. 

## Boot scripts 

Description to usage of boot scripts at [Setup of XEN demo image for USB stick or SD card (restricted function)](cr-demo-image.md). All boot scripts can be created from basing files with

    mkimage -A arm64 -T script -O linux -d <scriptname>.source <scriptname>.scr

### boot.scr

Top level boot script. With setting of environment variable at U-Boot Domain-0 can be configured.
Based on ![boot.source](./configs/boot.source). The file can be created by 

### boot_n.scr
Boot script to start XEN and Domain-0 for "not passthrough" demo cases.
Based on ![boot_n.source](./configs/boot_n.source).

### bootpt_eth.scr
Boot script to start XEN and Domain-0 with NIC controller excluded for normal usage and marked for "pass through" use case.
Based on ![bootpt_eth.source](./configs/bootpt_eth.source).

### bootpt_mmc.scr
Boot script to start XEN and Domain-0 with NIC controller excluded for normal usage and marked for "pass through" use case.
Based on ![bootpt_mmc.source](./configs/bootpt_mmc.source).

## Petalinux VM

Description to get all parts at [Get parts of Petalinux system](get-petalinux-parts.md). It's a sample system and can be easily replaced with other implementations to show a sample for installed VM's.

### guestvm/Image
Linux image for Petalinux VM.

### guestvm/rootfs.cpio.gz
InitramFS for Petalinux.

### rootfs.tar.gz
Same like before, but as tar archive. This system will be extracted to P3 of demo image.

## Apertis VM

Description to get all parts at [Get parts of Apertis system](get-apertis-parts.md). It's a sample system and can be easily replaced with other implementations to show a sample for installed VM's.

### apertis/Image
Linux image for Apertis VM.

### apertis/Initrd
InitramFS for Apertis VM.

## Zephyr VM

Description to get the part at [Get parts of Zephyr system](get-zephyr-parts.md). It's a sample system and can be easily replaced with other implementations to show a sample for installed VM's.

### zephyr-domz

Boot image for Zephyr demo. The original image file built at [Get parts of Zephyr system](get-zephyr-parts.md) is **zephyr.bin**.
At ![example_zephyr.cfg](./configs/example_zephyr.cfg) the filename is used.

## XEN configuration files for different demo cases

### example-simple.cfg

Configuration file for XEN to start VM for [Demo case with simple Linux VM (Petalinux)](test-simple.md). Provided by ![example-simple.cfg](./configs/example-simple.cfg).

### example_zephyr.cfg

Configuration file for XEN to start VM for [Demo case with Zephyr VM](test-zephyr.md). Provided by ![example_zephyr.cfg](./configs/example_zephyr.cfg).

### example-apertis.cfg

Configuration file for XEN to start VM for [Demo case with Linux VM (Apertis)](test-apertis.md). Provided by ![example-apertis.cfg](./configs/example-apertis.cfg).

### example-pvdisk.cfg
Configuration file for XEN to start VM for [Demo case with paravirtualized partition](test-pv-disk.md). Provided by ![example-pvdisk.cfg](./configs/example-pvdisk.cfg).

### example-pvnet.cfg
Configuration file for XEN to start VM for [Demo case with paravirtualized network](test-pv-net.md). Provided by ![example-pvnet.cfg](./configs/example-pvnet.cfg).

### <a name="brcreatesh"></a>brcreate.sh

Shell script to set up network bridge ***xenbr0***, used at [Demo case with paravirtualized network](test-pv-net.md). Provided by ![brcreate.sh](./configs/brcreate.sh).

### example-passmmc.cfg

Configuration file for XEN to start VM for [Demo case with passed through SD controller](test-pt-disk.md). Provided by ![example-passmmc.cfg](./configs/example-passmmc.cfg).

<a name="dtbsnippets"></a>

### passthrough-example-part_mmc.dtb
Device tree snippet for [Demo case with passed through SD controller](test-pt-disk.md). This file is generated from <https://github.com/Xilinx/xen-passthrough-device-trees/blob/master/device-trees-2021.2/zcu102/mmc%40ff170000.dts> and has to be created by

    dtc -I DTS -O DTB mmc%40ff170000.dts -o passthrough-example-part_mmc.dtb      

### example-passnet.cfg

Configuration file for XEN to start VM for [Demo case with passed through NIC controller](test-pt-net.md). Provided by ![example-passnet.cfg](./configs/example-passnet.cfg).

### passthrough-example-part.dtb
Device tree snippet for [Demo case with passed through NIC controller](test-pt-net.md). This file is generated from <https://github.com/Xilinx/xen-passthrough-device-trees/blob/master/device-trees-2021.2/zcu102/ethernet%40ff0e0000.dts> and has to be created by

    dtc -I DTS -O DTB ethernet%40ff0e0000.dts -o passthrough-example-part.dtb




