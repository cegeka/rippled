#!/bin/bash
# params : account_src secret account_dst [address] [port]

ADDRESS="localhost"
PORT="5105"

if ! [ -z $4 ]
	then
		ADDRESS="$4"
fi

if ! [ -z $5 ]
	then
		PORT="$5"
fi

if [ "$#" -lt 3 ]
	then
		echo "Invalid params, need 3 params: account_src secret account_dst";
		exit 1;
fi

echo "ADDRESS: $ADDRESS:$PORT";

ACCOUNT_SRC="$1"
SECRET="$2"
ACCOUNT_DST="$3"

command -v js24 > /dev/null || sudo apt-get install -y libmozjs-24-bin  
result=`curl -X POST -d '{ "method": "sign", "params": [ { "offline": false, "secret": "'"$SECRET"'", "tx_json": { "Account": "'"$ACCOUNT_SRC"'" , "Amount": "20000000", "Destination": "'"$ACCOUNT_DST"'", "DestinationTag": "1", "TransactionType": "Payment" } } ] }' http://$ADDRESS:$PORT/`
tx_blob=`echo $result | ./jsawk -j js24 'return this.result.tx_blob'`

echo
echo  "tx_blob is: $tx_blob\n"
echo

curl -X POST -d '{ "method": "submit", "params": [ { "tx_blob": "'"$tx_blob"'" } ] }' http://$ADDRESS:$PORT/


