#!/bin/bash
cd
sudo find /usr/local/include -maxdepth 1 -type d -name "boost-*"\
 -exec rm -r {} \;
sudo test -d /usr/local/include/boost && sudo rm -r /usr/local/include/boost
sudo rm -f /usr/local/lib/libboost_*
sudo ldconfig
exit

