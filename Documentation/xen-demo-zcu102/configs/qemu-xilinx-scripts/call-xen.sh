#!/bin/bash

[ -d /tmp/tmpt7z53_ew ] || mkdir /tmp/tmpt7z53_ew

dir="$(dirname $0)"
cd "$dir"


qemu-system-aarch64 \
-drive if=sd,index=1,file=xen-boot.img,format=raw \
-drive if=none,index=1,file=xen-demo.img,id=stick,format=raw \
-nographic \
-serial mon:stdio \
-serial null \
-hw-dtb zcu102-arm.dtb \
-net nic -net nic -net nic -net nic,netdev=net0,macaddr=52:54:00:12:34:02 \
-netdev tap,id=net0,ifname=tap1,script=no,downscript=no \
-device usb-storage,bus=usb3@0xFE200000.0,port=1,id=usb_dev1,drive=stick \
-global xlnx,zynqmp-boot.cpu-num=0 -global xlnx,zynqmp-boot.use-pmufw=true \
-device loader,addr=0xfffc0000,data=0x584c4e5801000000,data-be=true,data-len=8 \
-device loader,addr=0xfffc0008,data=0x0000000800000000,data-be=true,data-len=8 \
-device loader,addr=0xfffc0010,data=0x1000000000000000,data-be=true,data-len=8 \
-device loader,addr=0xffd80048,data=0xfffc0000,data-len=4,attrs-secure=on \
-device loader,file=arm-trusted-firmware.elf,cpu-num=0 \
-device loader,file=u-boot.elf \
-device loader,file=system.dtb,addr=0x100000,force-raw=on \
-boot mode=5 \
-machine arm-generic-fdt \
-accel tcg,thread=multi \
-m 4096 \
-accel tcg,thread=multi \
-machine-path /tmp/tmpt7z53_ew

