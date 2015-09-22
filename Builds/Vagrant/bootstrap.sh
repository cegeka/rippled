#!/bin/bash
# deps
apt-get update -y
apt-get upgrade -y
apt-get install -y git scons pkg-config protobuf-compiler libprotobuf-dev libssl-dev tmux flip python-dev cmake
apt-get install -y python-software-properties
apt-get install -y build-essential g++ python-dev autotools-dev libicu-dev build-essential libbz2-dev

# install boost
pushd /src/
if [ ! -d "boost_1_58_0" ]; then
  if [ ! -f "boost_1_58_0.tar.gz" ]; then
    wget http://downloads.sourceforge.net/project/boost/boost/1.58.0/boost_1_58_0.tar.gz
  fi
  tar -vxf boost_1_58_0.tar.gz
fi

pushd boost_1_58_0
. ./bootstrap.sh
./b2 install
ldconfig
popd

popd
