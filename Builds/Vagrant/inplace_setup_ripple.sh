#!/bin/bash

# rippled
cp ../../build/gcc.release/rippled /usr/local/sbin/rippled

# configs
sudo mkdir -p /etc/ripple/
sudo chown -R $USER /etc/ripple
mkdir -p $HOME/.config/ripple/

cp validators.txt /etc/ripple/validators.txt

# service
if [ "$1" -eq "four" ]; then
	cp init.d_rippled_four /etc/init.d/rippled
else
	cp init.d_rippled /etc/init.d/rippled
fi

chmod +x /etc/init.d/rippled
cp init.d_rippled2 /etc/init.d/rippled2

chmod +x /etc/init.d/rippled2
flip -u /etc/init.d/rippled
flip -u /etc/init.d/rippled2
flip -u /etc/ripple/validators.txt

# start service
cp rippled_$1.cfg /etc/ripple/rippled.cfg
cp rippled_$1.cfg $HOME/.config/ripple/rippled.cfg
flip -u /etc/ripple/rippled.cfg
sudo service rippled start
