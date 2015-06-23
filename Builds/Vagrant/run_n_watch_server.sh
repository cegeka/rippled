#/bin/bash
screen -dmS rippled bash -c "rippled --net"
watch -n 1 rippled server_info
