#!/bin/bash
cd
su
find /usr/local/include -maxdepth 1 -type d -name "boost-*"\
 -exec rm -r {} \;
test -d /usr/local/include/boost && rm -r /usr/local/include/boost
rm -f /usr/local/lib/libboost_*
ldconfig
exit

