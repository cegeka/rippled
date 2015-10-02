#!/bin/bash

ACCOUNT1="rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh"
SECRET1="masterpassphrase"
ACCOUNT2="r4gzWvzzJS2xLuga9bBc3XmzRMPH3VvxXg"
SECRET2="shrixAzTwHCDGfYTMUFcqhwdWVzCp"
ADDRESS="localhost"
PORT="5005"

result1=`./perform_transaction.sh $ACCOUNT1 $SECRET1 $ACCOUNT2 $ADDRESS $PORT`
echo "$result1"
result2=`./perform_transaction.sh $ACCOUNT2 $SECRET2 $ACCOUNT1 $ADDRESS $PORT`
echo "$result2"




