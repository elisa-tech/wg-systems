# Get parts of Apertis system

[Back to **Table of Contents**](Readme.md)

This description shows, how to get the parts, but will not provide them. This means, another systems can be used alternatively.

## General
Apertis images are created with **Debos** tool, available for Debian, description at <https://packages.debian.org/bullseye/debos>.
At <https://www.apertis.org/guides/image_building/> more information about image building at **Apertis** is available.

## Setup and build of project

**Debos** is working with so called images recipes (**.yaml**). 

    mkdir apertiscreate
    cd  apertiscreate
    git clone -b apertis/v2022 https://gitlab.apertis.org/infrastructure/apertis-image-recipes.git

## Apply the needed patch to get a valid InitRamfs
A patch for image recipes is provided at ![0001-Changes-for-Initrd.patch](./configs/0001-Changes-for-Initrd.patch) to create an InitRamfs system of **Apertis**.

    cd apertis-image-recipes/
    git am --whitespace=nowarn 0001-Changes-for-Initrd.patch
    cd ..

## Create an operational system package (ospack)
At **Apertis** the application is built at an **ospack*.tar.gz** file, which keeps all information but BSP and image setup. For the needed InitRamfs an archive **ospack-nano-arm64** is built.

    sudo -E debos -t architecture:arm64 -t ospack:ospack-nano-arm64 --debug-shell apertis-image-recipes/ospack-nano.yaml

## Create an initrd package (ospack)
The given image recipe creates an archive **irdsys.image-nano-initrd.tar.gz** with all needed parts to set up an InitRamfs based system of Apertis.

    sudo -E debos -t architecture:arm64 -t ospack:ospack-nano-arm64 -t image:image-nano-initrd --debug-shell apertis-image-recipes/image-initrd.yaml


## Extract the initrd package

    tar xf irdsys.image-nano-initrd.tar.gz # will be extracted to a directory image-nano-initrd

##  <a name="artefacts"></a>Artefacts to be used as parts

  * image-nano-initrd/**Image**
  * image-nano-initrd/**Initrd**




