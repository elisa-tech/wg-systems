# Build parts of Domain-0 with XEN

[Back to **Table of Contents**](Readme.md)

This description will show the setup of all required parts for Domain-0 with XEN system at Xilinx ZCU102 board.

## Starting point

This system bases on instructions at 
[Building Xen Hypervisor through Yocto Flow](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/1696137838/Building+Xen+Hypervisor+through+Yocto+Flow)


## Setup of Yocto build system

This step is not described explicitely.

## Set up of Yocto project

    mkdir xen.v2023.1
    cd xen.v2023.1
    repo init -u https://github.com/Xilinx/yocto-manifests.git -b rel-v2023.1
    repo sync
    source setupsdk

### Adopt the build configuration

    # Edit conf/local.conf and Add the below line
    IMAGE_FSTYPES += "cpio.gz"

### Add layer "meta-user"

    bitbake-layers create-layer --priority 99 ../sources/meta-user
    bitbake-layers add-layer ../sources/meta-user

### Add configuration for adaptations of /etc/fstab

The changes are provided by [meta-user-changes.tar.gz](./configs/meta-user-changes.tar.gz) and can be applied with

    tar xf meta-user-changes.tar.gz -C ..

After this the following lines are added at **/etc/fstab**

    LABEL=boot       /media/card          auto       defaults,sync  0  2
    LABEL=system      /media/card2         auto       defaults,sync  0  2

    /media/card2/etc /etc none bind

Additionally some configuration is set to enable XEN features at devive tree.

## Build the project

It's assumed, the yocto project is still the active working directory. Then the project can be built with

    MACHINE=zcu102-zynqmp bitbake xen-image-minimal

##  <a name="artefacts"></a>Artefacts to be used as parts

To prevent a complex name handling, the filenames are simplified.

  * build/tmp/deploy/images/zcu102-zynqmp/**boot.bin**
  * build/tmp/deploy/images/zcu102-zynqmp/**xen-zcu102-zynqmp** has to be renamed to **xen**
  * build/tmp/deploy/images/zcu102-zynqmp/**xen-image-minimal-zcu102-zynqmp-*.rootfs.cpio.gz** has to be renamed to **xen-rootfs.cpio.gz**
  * build/tmp/deploy/images/zcu102-zynqmp/devicetree/**system-top.dtb** has to be renamed to **system.dtb**
  * build/tmp/deploy/images/zcu102-zynqmp/**Image-*.bin** has to be renamed to **Image**

## <a name="artefactsqemu"></a>Artifacts to be used with Qemu(Xilinx)

Please have a look to run **Qemu** at [Setup Qemu system with demo and boot image](setup-qemu.md)

### arm-trusted-firmware.elf
  * build/tmp/deploy/images/zcu102-zynqmp/arm-trusted-firmware.elf

### pmu-firmware-zcu102-zynqmp.elf
  * build/tmp/deploy/images/zcu102-zynqmp/pmu-firmware-zcu102-zynqmp.elf

### pmu-rom.elf
  * build/tmp/deploy/images/zcu102-zynqmp/pmu-rom.elf

### u-boot.elf
  * build/tmp/deploy/images/zcu102-zynqmp/u-boot.elf

### zcu102-arm.dtb
  * build/tmp/deploy/images/zcu102-zynqmp/qemu-hw-devicetrees/zcu102-arm.dtb

### zynqmp-pmu.dtb
  * build/tmp/deploy/images/zcu102-zynqmp/qemu-hw-devicetrees/zynqmp-pmu.dtb









