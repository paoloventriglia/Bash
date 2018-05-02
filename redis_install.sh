#!/bin/bash

#__author__ = "Paolo Ventriglia"
#__credits__ = ["Paolo Ventriglia"]
#__license__ = "GPL"
#__version__ = ""
#__maintainer__ = "Paolo Ventriglia"
#__email__ = "paolo@corebox.co.uk"


# This script install redis on a pre-systemd linux server

# Install make and gcc
yum install -y make gcc

# Unpack source code files
tar xvzf redis-3.2.8.tar.gz

# Change directory to redis
cd redis-3.2.8

# Compile the src code file, this will require make and gcc (if you need to install them uncomment the second line)
make

# Make install will copy the executable to the relevant locations
make install

# Make redis folder for config file
mkdir /etc/redis

# Create working directory
mkdir /var/redis
mkdir /var/redis/redisd

# Copy redis config file /etc/redis
cp redis.conf /etc/redis/redis.conf


