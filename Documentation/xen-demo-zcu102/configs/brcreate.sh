#/bin/sh

IF=$1

IPADDR=$(ip addr show dev ${IF} | perl -ne 'print "$1\n" if /inet\s+([^\s]+)/')

ip addr del ${IPADDR} dev ${IF}

brctl addbr xenbr0
brctl addif xenbr0 ${IF}
/sbin/udhcpc -i xenbr0 -b
