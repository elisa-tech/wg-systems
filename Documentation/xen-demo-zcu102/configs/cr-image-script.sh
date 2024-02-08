#!/bin/bash

SNIPDIR="$(realpath ..)"

ARTIFACTS=${1:-$ARTIFACTS}
CONFIGS=${2:-$CONFIGS}
OUTDIR=${3:-$OUTDIR}

echo "ARTIFACTS=$ARTIFACTS"
echo "CONFIGS=$CONFIGS"
echo "OUTDIR=$OUTDIR"

function undo_00_Prepare()
{
  :
}
function do_00_Prepare()
{
  [ -d "$OUTDIR" ] || mkdir -p  "$OUTDIR"
}


# Build boot image

function undo_01_Build_bootimage()
{
  pushd $OUTDIR
  rm -f xen-boot.img
  popd
}
function do_01_Build_bootimage()
{
  pushd $OUTDIR
  sudo debos "${CONFIGS}/image_boot.yaml"
  popd
}



# Build demo image

function undo_01_Build_demoimage()
{
  pushd $OUTDIR
  rm -f xen-demo.img
  popd
}
function do_01_Build_demoimage()
{
  pushd $OUTDIR
  sudo debos "${CONFIGS}/image_demo.yaml"
  popd
}


# Mount boot image

function undo_03_Mount_bootimage()
{
  sudo mountimage -u xen-boot.mnt
  rm -rf xen-boot.mnt
}
function do_03_Mount_bootimage()
{
  [ -d xen-boot.mnt ] || mkdir xen-boot.mnt
  sleep 1
  sudo mountimage -r xendemo -m xen-boot.mnt ${OUTDIR}/xen-boot.img
}


# Mount demo image

function undo_03_Mount_demoimage()
{
  sudo mountimage -u xen-demo.mnt
  rm -rf xen-demo.mnt
}
function do_03_Mount_demoimage()
{
  [ -d xen-demo.mnt ] || mkdir xen-demo.mnt
  sleep 1
  sudo mountimage -r xendemo  -m xen-demo.mnt ${OUTDIR}/xen-demo.img
}


# Cp artifacts

function undo_05_Copy_artifacts_to_bootimage()
{
  pushd $(pwd)/xen-boot.mnt/boot/
  ls -A1 | sudo xargs rm -rf
  popd
}
function do_05_Copy_artifacts_to_bootimage()
{
local mntimage=$(pwd)/xen-boot.mnt

  pushd "$ARTIFACTS"
  sudo cp -r image/boot.bin ${mntimage}/boot
  popd
}


# Cp artifacts for demo image

function undo_05_Copy_artifacts_to_demoimage()
{
  pushd $(pwd)/xen-demo.mnt/boot/
  ls -A1 | sudo xargs rm -rf
  popd
}

function do_05_Copy_artifacts_to_demoimage()
{
local mntimage=$(pwd)/xen-demo.mnt
local f

  pushd "$ARTIFACTS"
  sudo cp -r image/* ${mntimage}/boot
  sudo mkdir ${mntimage}/boot/guestvm
  sudo cp petalinux/{rootfs.cpio.gz,Image} ${mntimage}/boot/guestvm/
  sudo mkdir ${mntimage}/boot/apertis
  sudo cp apertis/{Image,Initrd} ${mntimage}/boot/apertis/
  sudo cp -r dtb-snippets/* ${mntimage}/boot
  popd
  pushd "$CONFIGS"
  sudo cp *.source *.sh *.cfg ${mntimage}/boot
  popd
  pushd ${mntimage}/boot
  for f in *.source; 
  do 
    sudo mkimage -A arm64 -T script -O linux -d $f $(basename ${f%.source}.scr)  
  done
  popd
}


# Setup etc/

function undo_06_Setup_etc_of_demoimage()
{
local mntimage=$(pwd)/xen-demo.mnt

  sudo rm -rf ${mntimage}/config/etc
}

function do_06_Setup_etc_of_demoimage()
{
local mntimage=$(pwd)/xen-demo.mnt

  pushd ${mntimage}/config
  sudo rm -rf etc
  sudo mkdir etc
  zcat ${mntimage}/boot/xen-rootfs.cpio.gz  | sudo cpio -m --no-preserve-owner -i "etc/*"
  popd
}


# Cp artifacts for demo image

function undo_07_Extract_rootfs_to_demoimage()
{
  pushd $(pwd)/xen-demo.mnt/rootfsdemo/
  ls -A1 | sudo xargs rm -rf
  popd
}

function do_07_Extract_rootfs_to_demoimage()
{
local mntimage=$(pwd)/xen-demo.mnt

  pushd "$ARTIFACTS"
  sudo tar xf petalinux/rootfs.tar.gz -C  ${mntimage}/rootfsdemo/
  popd
}


# Umount boot image

function undo_10_Umount_bootimage()
{
  rm -f ${OUTDIR}/xen-boot.img.gz ${OUTDIR}/xen-boot.img.bmap
  [ -d xen-boot.mnt ] || mkdir xen-boot.mnt
  sleep 1
  sudo mountimage -r xendemo -m xen-boot.mnt ${OUTDIR}/xen-boot.img
}
function do_10_Umount_bootimage()
{
  sudo mountimage -u xen-boot.mnt
  rm -rf xen-boot.mnt
  bmaptool create ${OUTDIR}/xen-boot.img > ${OUTDIR}/xen-boot.img.bmap
  rm -f ${OUTDIR}/xen-boot.img.gz
  gzip -c ${OUTDIR}/xen-boot.img > ${OUTDIR}/xen-boot.img.gz
}



# Umount demo image

function undo_10_Umount_demoimage()
{
  rm -f ${OUTDIR}/xen-demo.img.gz ${OUTDIR}/xen-demo.img.bmap
  [ -d xen-demo.mnt ] || mkdir xen-demo.mnt
  sleep 1
  sudo mountimage -r xendemo  -m xen-demo.mnt ${OUTDIR}/xen-demo.img
}
function do_10_Umount_demoimage()
{
  sudo mountimage -u xen-demo.mnt
  rm -rf xen-demo.mnt
  bmaptool create ${OUTDIR}/xen-demo.img > ${OUTDIR}/xen-demo.img.bmap
  rm -f ${OUTDIR}/xen-demo.img.gz
  gzip -c ${OUTDIR}/xen-demo.img >  ${OUTDIR}/xen-demo.img.gz
}

echo "Do Prepare"
do_00_Prepare
rv=$?
if [ "$rv" != "0" ]; then
  exit $rv
fi

echo "Do Build bootimage"
do_01_Build_bootimage
rv=$?
if [ "$rv" != "0" ]; then
  exit $rv
fi

echo "Do Build demoimage"
do_01_Build_demoimage
rv=$?
if [ "$rv" != "0" ]; then
  exit $rv
fi

echo "Do Mount bootimage"
do_03_Mount_bootimage
rv=$?
if [ "$rv" != "0" ]; then
  exit $rv
fi

echo "Do Mount demoimage"
do_03_Mount_demoimage
rv=$?
if [ "$rv" != "0" ]; then
  exit $rv
fi

echo "Do Copy artifacts to bootimage"
do_05_Copy_artifacts_to_bootimage
rv=$?
if [ "$rv" != "0" ]; then
  exit $rv
fi

echo "Do Copy artifacts to demoimage"
do_05_Copy_artifacts_to_demoimage
rv=$?
if [ "$rv" != "0" ]; then
  exit $rv
fi

echo "Do Setup etc of demoimage"
do_06_Setup_etc_of_demoimage
rv=$?
if [ "$rv" != "0" ]; then
  exit $rv
fi

echo "Do Extract rootfs to demoimage"
do_07_Extract_rootfs_to_demoimage
rv=$?
if [ "$rv" != "0" ]; then
  exit $rv
fi

echo "Do Umount bootimage"
do_10_Umount_bootimage
rv=$?
if [ "$rv" != "0" ]; then
  exit $rv
fi

echo "Do Umount demoimage"
do_10_Umount_demoimage
rv=$?
if [ "$rv" != "0" ]; then
  exit $rv
fi

