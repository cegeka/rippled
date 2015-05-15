#/bin/bash
screen -dmS rippled "rippled --net"
watch -n 1 rippled server_info
