#!/bin/bash

[ -d /tmp/tmpt7z53_ew ] || mkdir /tmp/tmpt7z53_ew

dir="$(dirname $0)"
cd "$dir"

qemu-system-microblazeel \
-M microblaze-fdt -display none \
-hw-dtb zynqmp-pmu.dtb \
-kernel pmu-rom.elf \
-device loader,file=pmu-firmware-zcu102-zynqmp.elf \
-device loader,addr=0xfd1a0074,data=0x1011003,data-len=4 -device loader,addr=0xfd1a007C,data=0x1010f03,data-len=4 \
-machine-path /tmp/tmpt7z53_ew
