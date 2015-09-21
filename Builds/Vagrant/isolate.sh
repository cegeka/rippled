#!/bin/bash

# Isolate, just in case
sed -i '/ripple.com/d' /etc/hosts
echo "127.0.0.1 local.ripple.com" | tee -a /etc/hosts
echo "127.0.0.1 www.local.ripple.com" | tee -a /etc/hosts
echo "127.0.0.1 ripple.local.ripple.com" | tee -a /etc/hosts
echo "127.0.0.1 history.ripple.com" | tee -a /etc/hosts
echo "127.0.0.1 api.ripplecharts.com" | tee -a /etc/hosts
echo "127.0.0.1 local.id.ripple.com" | tee -a /etc/hosts
echo "127.0.0.1 id.ripple.com" | tee -a /etc/hosts
echo "127.0.0.1 s-west.ripple.com" | tee -a /etc/hosts
echo "127.0.0.1 s-east.ripple.com" | tee -a /etc/hosts
echo "127.0.0.1 auth1.ripple.com" | tee -a /etc/hosts
