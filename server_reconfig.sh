#!/bin/bash

#__author__ = "Paolo Ventriglia"
#__credits__ = ["Paolo Ventriglia"]
#__license__ = "GPL"
#__version__ = ""
#__maintainer__ = "Paolo Ventriglia"
#__email__ = "paolo@corebox.co.uk"

# The script backup and reconfigure the following files base on the given arguments
# /etc/sysconfig/network-scripts/ifcfg-eth?
# /etc/sysconfig/network
# /etc/hosts
# /etc/network/interfaces
# /etc/hostname

# Supports CentOS/Redhat 5/6/7 and Ubuntu 14

# The command's arguments have to be given in the right order, you can leave gateway out if the server is multihomed for example but you will have to configure a default gateway at some point.
# hostname = name of the device (without domain)
# interface = name of the network interface to be changed - eth0 or eth1 or eth2 etc
# ip address = ip address of the interface
# subnet = the subnet mask for that IP address
# gateway = the default gateway for the device (this is not mandatory, especially if the server has multiple NICs)
# Usage: server_reconfig.sh <hostname> <interface> <ipaddress> <subnet> <gateway>
# Example: server_reconfig.sh testname eth0 10.10.10.41 255.255.255.0 10.10.10.1

release=$(cat /etc/*release)
string=$release

# If statement that accepts 4 or 5 given arguments

if [ $# -eq 5 ] || [ $# -eq 4 ]
then

if [[ $string = *"release 6"* ]] || [[ $string = *"release 5"* ]]
then
# Backup of network files
echo ""
echo "Taking a backup of all the files we are changing..."

cp /etc/sysconfig/network /etc/sysconfig/network-old.bk
cp /etc/sysconfig/network-scripts/ifcfg-$2 /etc/sysconfig/network-scripts/$2-old.bk
cp /etc/hosts /etc/hosts-old.bk

# Assign static IP to the given interface

echo ""
echo "Assigning the static IP ..."
echo ""

cat <<EOF > /etc/sysconfig/network-scripts/ifcfg-$2

DEVICE="$2"
BOOTPROTO="static"
IPADDR="$3"
NETMASK="$4"
ONBOOT="yes"
NM_CONTROLLED="no"
EOF

# If statement to deal with the absence of the gateway argument.
if [ $# -eq 5 ]
then

# Assign default gateway

echo "Changing the default gateway ..."
echo ""

cat <<EOF > /etc/sysconfig/network

HOSTNAME=$1
DOMAIN=domain.com
NOZEROCONF=yes
NETWORKING=yes
IPV6INIT=no
GATEWAY="$5"
EOF
else
echo "Default gateway not provided. Remember to add it at some point or the server won't route anywhere!"
echo ""
fi

# Modify hosts file with new given hostname

echo "Adding $1 as hostname to the /etc/hosts file .."
echo ""

cat <<EOF > /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
$3          $1.domain.com $1
EOF
  service puppet stop
  chkconfig puppet off
  rm /etc/puppetlabs/puppet/ssl -rf
  hostname $1
  rm /etc/udev/rules.d/70-persistent-net.rules -rf
  service network restart
elif [[ $string = *"release 7"* ]]
then
# Backup of network files
echo ""
echo "Taking a backup of all the files we are changing..."

cp /etc/sysconfig/network /etc/sysconfig/network-old.bk
cp /etc/sysconfig/network-scripts/ifcfg-$2 /etc/sysconfig/network-scripts/$2-old.bk
cp /etc/hosts /etc/hosts-old.bk

# Assign static IP to the given interface

echo ""
echo "Assigning the static IP ..."
echo ""

cat <<EOF > /etc/sysconfig/network-scripts/ifcfg-$2

DEVICE="$2"
BOOTPROTO="static"
IPADDR="$3"
NETMASK="$4"
ONBOOT="yes"
NM_CONTROLLED="no"
EOF

# If statement to deal with the absence of the gateway argument.
if [ $# -eq 5 ]
then

# Assign default gateway

echo "Changing the default gateway ..."
echo ""

cat <<EOF > /etc/sysconfig/network

HOSTNAME=$1
DOMAIN=domain.com
NOZEROCONF=yes
NETWORKING=yes
IPV6INIT=no
GATEWAY="$5"
EOF
else
echo "Default gateway not provided. Remember to add it at some point or the server won't route anywhere!"
echo ""
fi

# Modify hosts file with new given hostname

echo "Adding $1 as hostname to the /etc/hosts file .."
echo ""

cat <<EOF > /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
$3          $1.domain.com $1
EOF

  systemctl stop puppet
  systemctl disable puppet
  rm /etc/puppetlabs/puppet/ssl -rf
  hostnamectl set-hostname $1
  systemctl restart network

elif [[ $string = *"Ubuntu 14"* ]]
then
# Backup of network files
echo ""
echo "Taking a backup of all the files we are changing..."

cp /etc/network/interfaces /etc/network/interfaces-old.bk
cp /etc/hostname /etc/hostname-old.bk
cp /etc/hosts /etc/hosts-old.bk

# Assign static IP to the given interface

echo ""
echo "Assigning the static IP ..."
echo ""

cat <<EOF > /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet static
        address $3
        netmask $4
        gateway $5
EOF

# Modify hosts file with new given hostname

echo "Adding $1 as hostname to the /etc/hosts file .."
echo ""

cat <<EOF > /etc/hostnamea
$1.domain.com
EOF

cat <<EOF > /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
$3          $1.domain.com $1
EOF
  service puppet stop
  rm /etc/puppetlabs/puppet/ssl -rf
  service networking restart
else
echo "This isn't CentOS/RedHat 5/6/7 or Ubuntu 14"
echo ""
fi

else

echo "Use the argument in the right order as below"
echo "Usage: server_reconfig.sh <hostname> <interface> <ipaddress> <subnet> <gateway>"
echo "Example: server_reconfig.sh testname eth0 10.10.10.41 255.255.255.0 10.10.10.1"

fi
