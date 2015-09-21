#!/bin/bash
# deps
apt-get update -y
apt-get upgrade -y
apt-get install -y git scons pkg-config protobuf-compiler libprotobuf-dev libssl-dev tmux flip python-dev cmake
apt-get install -y python-software-properties
apt-get install -y build-essential g++ python-dev autotools-dev libicu-dev build-essential libbz2-dev

pushd /src/
if [ ! -d "boost_1_57_0" ]; then
  if [ ! -f "boost_1_57_0.tar.gz" ]; then
    wget http://downloads.sourceforge.net/project/boost/boost/1.57.0/boost_1_57_0.tar.gz
  fi
  tar -vxf boost_1_57_0.tar.gz
fi
pushd boost_1_57_0
. ./bootstrap.sh
./b2 install
ldconfig
popd

scons release
(service rippled stop &) || true
cp /src/build/gcc.release/rippled /usr/local/sbin/rippled && strip /usr/local/sbin/rippled
popd

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
