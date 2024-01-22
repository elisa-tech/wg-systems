# Get parts of Zephyr system

[Back to **Table of Contents**](Readme.md)

This description shows, how to get the parts, but will not provide them. This means, another systems can be used alternatively.

## Setup of build environment
Installation of west environment according <https://docs.zephyrproject.org/latest/develop/getting_started/index.html>

## Setup and build of project

    west init zephyrproject
    cd zephyrproject/
    west update
    west zephyr-export
    cd zephyr/
    west build -p always -b xenvm sample/synchronization

##  <a name="artefacts"></a>Artefacts to be used as parts

  * build/zephyr/**zephyr.bin** has to be renamed to **zephyr-domz**

Alternatively the configuration file ![example_zephyr.cfg](./configs/example_zephyr.cfg) can be changed.


