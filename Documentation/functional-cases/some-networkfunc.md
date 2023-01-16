# Some network tests

[Back to contents](contents.md)

## List of functionalities

[place holder for start of short list of ## Functionalities]: # (This is used by tool to create a short content list as start point)

[Look network configuration at DomD](#look-network-configuration-at-domd)

[Look network configuration at DomU](#look-network-configuration-at-domu)

[Get ssh access to DomD](#get-ssh-access-to-domd)

[Get ssh access to DomU](#get-ssh-access-to-domu)

[place holder for end of short list of ## Functionalities]: # (This is used by tool to create a short content list as end point)

## Description

The XEN system with DomD and DomU provides some interesting functions like SSH connections between the domains and from outside.

## Prerequisites

- System setup like described at [Start the system image of meta-xt-prod-devel-rcar](start-img.md)
- Router with active internet connection connected to ethernet interface of Renesas target.

## Functionalities

### Look network configuration at DomD

At first change to DomD like described at [Attach console to DomD](Dom0-1stactivities.md#attach-console-to-domd). Then get the state of the nework with **ifconfig**.

Example for function:

```
root@h3ulcb-domd:~# ifconfig
eth0      Link encap:Ethernet  HWaddr 2E:09:0A:06:D1:96
          inet addr:192.168.178.155  Bcast:192.168.178.255  Mask:255.255.255.0
          inet6 addr: fe80::2c09:aff:fe06:d196/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:11610 errors:0 dropped:6777 overruns:0 frame:0
          TX packets:120 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:1649274 (1.5 MiB)  TX bytes:9121 (8.9 KiB)
          Interrupt:113

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:81 errors:0 dropped:0 overruns:0 frame:0
          TX packets:81 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:6168 (6.0 KiB)  TX bytes:6168 (6.0 KiB)

vif3.0    Link encap:Ethernet  HWaddr FE:FF:FF:FF:FF:FF
          inet6 addr: fe80::fcff:ffff:feff:ffff/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:121 errors:0 dropped:0 overruns:0 frame:0
          TX packets:175 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:32
          RX bytes:12548 (12.2 KiB)  TX bytes:16347 (15.9 KiB)

xenbr0    Link encap:Ethernet  HWaddr EE:1C:67:5B:2F:63
          inet addr:192.168.0.1  Bcast:192.168.0.255  Mask:255.255.255.0
          inet6 addr: fe80::ec1c:67ff:fe5b:2f63/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:121 errors:0 dropped:0 overruns:0 frame:0
          TX packets:155 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:12548 (12.2 KiB)  TX bytes:14728 (14.3 KiB)

root@h3ulcb-domd:~#
```

Here **eth0** points to physical ethernet interface. **xenbr0** implements an XEN internal network bridge with connection to **ETH0** and implements a subnet **192.168.0/24** (with DHCP). 

### Look network configuration at DomU

Now go back to **Domain-0** with **CTRL 5** and change to **DomU** with **xl console DomU** described at [Attach console to DomU](Dom0-1stactivities.md#attach-console-to-domu). Then get the state of the nework with **ifconfig**.

Example for function:

```
root@h3ulcb:~# ifconfig
eth0      Link encap:Ethernet  HWaddr 08:00:27:FF:CB:CF
          inet addr:192.168.0.5  Bcast:192.168.0.255  Mask:255.255.255.0
          inet6 addr: fe80::a00:27ff:feff:cbcf/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:175 errors:0 dropped:0 overruns:0 frame:0
          TX packets:121 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:13897 (13.5 KiB)  TX bytes:14242 (13.9 KiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:80 errors:0 dropped:0 overruns:0 frame:0
          TX packets:80 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:6080 (5.9 KiB)  TX bytes:6080 (5.9 KiB)
```

At **DomU** the network interface **ETH0** is connected to subnet of **xenbr0** at **DomD**. So it's possible to get internet connection both for application at **DomD** and **DomU**.

### Get ssh access to DomD

For this get the IP address of **eth0** of **DomD** (have a look at [Look network configuration at DomD](#look-network-configuration-at-domd)).
Now connect from a PC connected to same subnet with **ssh root@<ip>**.

Example for function:

At **DomD**:

```
root@h3ulcb-domd:~# ifconfig eth0
eth0      Link encap:Ethernet  HWaddr 2E:09:0A:06:D1:96
          inet addr:192.168.178.155  Bcast:192.168.178.255  Mask:255.255.255.0
          inet6 addr: fe80::2c09:aff:fe06:d196/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:11610 errors:0 dropped:6777 overruns:0 frame:0
          TX packets:120 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:1649274 (1.5 MiB)  TX bytes:9121 (8.9 KiB)
          Interrupt:113

root@h3ulcb-domd:~#
```

At **PC** access to **DomD** with **ssh root@192.168.178.155**:

```
$ ssh root@192.168.178.155
root@h3ulcb-domd:~# 
```

### Get ssh access to DomU

For this get the IP address of **eth0** of **DomD** (have a look at [Look network configuration at DomD](#look-network-configuration-at-domd)).
Now connect from a PC connected to same subnet and different port **2025** with **ssh -p 2025 root@<ip>**.

ssh -p 2025 root@192.168.178.155

Example for function:


At **PC** access to **DomU** with **ssh root@192.168.178.155**:

```
$ ssh -p 2025 root@192.168.178.155
root@h3ulcb:~#
```

## Results

Some understanding of basic network.

## Additional hints

Please regard, at the moment the system with **DomD** and **DomU** only starts correctly with DHCP service at ethernet connection. So connection of Renesas target will not work.

[Look network configuration at DomD](#look-network-configuration-at-domd)
