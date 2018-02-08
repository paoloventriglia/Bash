#!/bin/bash

# Author: Paolo ventriglia
# Filename: server_reconfig.sh
# Version: 0.1

# The script backup and reconfigure the following files base on the given arguments
# /etc/sysconfig/network-scripts/ifcfg-eth?
# /etc/sysconfig/network
# /etc/hosts

# The script runs the following commands based on the distro release

# CentOS/RedHat 5/6:
#
# Stop puppet agent service
#   service puppet stop
#
# Disable puppet agent from start at boot up
#   chkconfig puppet off
#
# Remove puppet SSL folder
#   rm /etc/puppetlabs/puppet/ssl -rf
#
# Change hostname
#   hostname $1
#
# Remove the 70-persistent-net.rules file
#   rm /etc/udev/rules.d/70-persistent-net.rules -rf
#
# Restart networking service
#   service network restart

# CentOS/RedHat 7:
#
# Stop puppet agent service
#   systemctl stop puppet
#
# Disable puppet agent from start at boot up
#   systemctl disable puppet
#
# Remove puppet SSL folder
#   rm /etc/puppetlabs/puppet/ssl -rf
#
# Change hostname
#   hostnamectl set-hostname $1
#
# Restart networking service
#   systemctl restart network

# The command's arguments have to be given in the right order, you can leave gateway out if the server is multihomed for example but you will have to configure a default gateway at some point.
# hostname = name of the device (without domain)
# interface = name of the network interface to be changed - eth0 or eth1 or eth2 etc
# ip address = ip address of the interface
# subnet = the subnet mask for that IP address
# gateway = the default gateway for the device (this is not mandatory, especially if the server has multiple NICs)
# Usage: server_reconfig.sh <hostname> <interface> <ipaddress> <subnet> <gateway>
# Example: server_reconfig.sh testname eth0 10.10.10.41 255.255.255.0 10.10.10.1

# If statement that accepts 4 or 5 given arguments 
if [ $# -eq 5 ] || [ $# -eq 4 ]
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
DOMAIN=domain.local
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
$3 $1.domain.local $1
EOF

# The following scriptblock will stop and disable the puppet agent service, remove puppet SSL config, change the hostname and restart network services
# The if statement reads the distro release and uses the correct commands accordingly

echo "Stopping puppet agent, remove puppet SSL config, changing hostname and restarting the Network Service, please re-connect using the new IP Address if you are using ssh ..."
echo ""

release=$(cat /etc/*release)
string=$release
if [[ $string = *"release 6"* ]] || [[ $string = *"release 5"* ]]
then
  service puppet stop
  chkconfig puppet off
  rm /etc/puppetlabs/puppet/ssl -rf
  hostname $1
  rm /etc/udev/rules.d/70-persistent-net.rules -rf
  service network restart
elif [[ $string = *"release 7"* ]]
then
  systemctl stop puppet
  systemctl disable puppet
  rm /etc/puppetlabs/puppet/ssl -rf
  hostnamectl set-hostname $1
  systemctl restart network
else
echo "This isn't CentOS/RedHat, or you need to upgrade"
echo ""
fi

else

echo "Use the argument in the right order as below"
echo "Usage: server_reconfig.sh <hostname> <interface> <ipaddress> <subnet> <gateway>"
echo "Example: server_reconfig.sh testname eth0 10.10.10.41 255.255.255.0 10.10.10.1"

fi