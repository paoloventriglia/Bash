#!/bin/bash
# Author: Paolo Ventriglia
# Version: 0.1
# This script has not been designed to do error checking or write to log, that may come later....
# I am working on modifying /etc/hosts, do it manually for now
#
# Gather networking information, require user input to insert networking information
#
eth0path=/etc/sysconfig/network-scripts/ifcfg-eth0
networkpath=/etc/sysconfig/network
#
#
echo -----------------------------------------------------------
echo ---------------GATHERING NETWORK INFORMATION---------------
echo -----------------------------------------------------------
echo ------Please input the IP address of the this server-------
echo -----------------------------------------------------------
read -p 'IP Address: ' ip
echo -----------------------------------------------------------
echo ---------------Please input the Subnet Mask----------------
echo -----------------------------------------------------------
read -p 'Netmask: ' netmask
echo -----------------------------------------------------------
echo ----------Please input the address of the gateway----------
echo -----------------------------------------------------------
read -p 'Gateway: ' gw
echo -----------------------------------------------------------
echo --------------Please input the new hostname----------------
echo -----------------------------------------------------------
read -p 'Hostname: ' hostname
echo -----------------------------------------------------------

# The script will now use sed to find and replace the configuration parameters
# Main
sed -i -e "s/IPADDR=*.*.*.*/IPADDR=$ip/g" "$eth0path"
sed -i -e "s/NETMASK=*.*.*.*/NETMASK=$netmask/g" "$eth0path"
sed -i -e "s/GATEWAY=*.*.*.*/GATEWAY=$gw/g" "$networkpath"
sed -i -e "s/HOSTNAME=.*/HOSTNAME=$hostname/g" "$networkpath"

# Set new hostname

hostname $hostname

# Stop puppet agent service

echo -----------------------------------------------------------
echo --------------Stopping puppet agent service----------------
echo -----------------------------------------------------------

service puppet start
service puppet stop

# Clear old SSL puppet data

rm -fr /etc/puppetlabs/puppet/ssl/*

echo -----------------------------------------------------------
echo ----------------Done! Check it worked----------------------
echo -----------------------------------------------------------
