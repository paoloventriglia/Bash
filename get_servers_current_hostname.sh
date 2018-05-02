#!/bin/bash
#__author__ = "Paolo Ventriglia"
#__credits__ = ["Paolo Ventriglia"]
#__license__ = "GPL"
#__version__ = ""
#__maintainer__ = "Paolo Ventriglia"
#__email__ = "paolo@corebox.co.uk"

# Run this script if you want to retrieve the hostname of multiple servers
# ./get_servers_hostname.sh > hostnames.txt

ssh -t "servername or IP address" 'hostname'
ssh -t "servername or IP address" 'hostname'
ssh -t "servername or IP address" 'hostname'