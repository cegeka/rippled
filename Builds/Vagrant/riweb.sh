#!/bin/bash
# riweb
apt-get install nodejs npm -y
rm -rf /usr/local/bin/node
ln -s /usr/bin/nodejs /usr/local/bin/node
cd /
git clone https://github.com/cegeka/riweb.git
cd riweb/
Install dependecies
npm install
install docker
wget -qO- https://get.docker.com/ | sh
ssl for docker
apt-get install apparmor
service docker restart

# mongoDB
chmod +x ./docker/start_mongo.sh
cd ./docker/ && ./start_mongo.sh && cd ..

# bower
npm install -g bower
bower install --allow-root --config.interactive=false

# start client
npm install -g grunt-cli
screen -dmS riweb bash -c 'grunt serve'
