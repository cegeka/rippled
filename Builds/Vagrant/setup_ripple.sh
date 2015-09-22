#!/bin/bash

# configs
mkdir -p /etc/ripple/
mkdir -p /root/.config/ripple/
mkdir -p /home/vagrant/.config/ripple/
cp /src/Builds/Vagrant/validators.txt /etc/ripple/validators.txt

# service
cp /src/Builds/Vagrant/init.d_rippled /etc/init.d/rippled
chmod +x /etc/init.d/rippled
cp /src/Builds/Vagrant/init.d_rippled2 /etc/init.d/rippled2
chmod +x /etc/init.d/rippled2
flip -u /etc/init.d/rippled
flip -u /etc/init.d/rippled2
flip -u /etc/ripple/validators.txt

# start service
cp /src/Builds/Vagrant/rippled_one.cfg /etc/ripple/rippled.cfg
cp /src/Builds/Vagrant/rippled_one.cfg /root/.config/ripple/rippled.cfg
cp /src/Builds/Vagrant/rippled_one.cfg /home/vagrant/.config/ripple/rippled.cfg
flip -u /etc/ripple/rippled.cfg
service rippled start
