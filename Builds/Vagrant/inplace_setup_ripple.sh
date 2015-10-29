#!/bin/bash

# rippled
sudo cp ../../build/gcc.release/rippled /usr/local/bin/rippled
sudo chown $USER /usr/local/bin/rippled

# configs
sudo mkdir -p /etc/ripple/
sudo chown -R $USER /etc/ripple
mkdir -p $HOME/.config/ripple/

cp validators.txt /etc/ripple/validators.txt

# service
if [ "$1" -eq "four" ]; then
	sudo cp init.d_rippled_four /etc/init.d/rippled
else
	sudo cp init.d_rippled /etc/init.d/rippled
fi

sudo chmod +x /etc/init.d/rippled
sudo cp init.d_rippled2 /etc/init.d/rippled2

sudo chmod +x /etc/init.d/rippled2
sudo flip -u /etc/init.d/rippled
sudo flip -u /etc/init.d/rippled2
sudo flip -u /etc/ripple/validators.txt

# start service
sudo cp rippled_$1.cfg /etc/ripple/rippled.cfg
sudo cp rippled_$1.cfg $HOME/.config/ripple/rippled.cfg
sudo flip -u /etc/ripple/rippled.cfg
sudo service rippled start
