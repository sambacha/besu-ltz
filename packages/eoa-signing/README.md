# Besu Utilities

### Run it:

```
npm install
node test.js --url=<url of the target node> --verbose --deploy
```

The above command deploys a simple smart contract `simplestorage.sol` to the target node and sets the initial value to `10`.

You should see output similar to the following:

```
1. Connecting to target node: https://<username>:<appcreds>@-$freightlayer.io
  Found account in the target node: 0xFf8c6060d3D4930E81a4c923b96B05FC039901F4
2. Deploying smart contract
  Smart contract deployed, ready to take calls at "0xb53C9f258FdD76B78D154CcEd33EFe09f9Bd9B69"
```

### Query the current value

Feel frees to switch to a different node in the same consortia for any of the following commands as they are supposed to work the same on any of the consortia nodes.

```
node test.js --url=<url of the target node> --contract=<contract address from the output above> --query
```

### Set a new value

```
node test.js --url=<url of the target node> --contract=<contract address from the output above> --set=<new value>
```

### Print out the DataStored event

```
node test.js --url=<url of the target node> --ws=<ws:// URL for the websocket connection> --contract=<contract address from the output above> --set=<new value>
```

### Deploy a private smart contract

```
node test.js --url=<url of the target node> --deploy --privateFor='["<private transaction addresses>"]'
```

**Note:** the privateFor argument value must be delimited with single quotes, and use double quotes for each of the target private addresses, in order for the script to successfully parse

### Deploy a private smart contract to a Besu node

```
node test.js --url=<url of the target node> --deploy --besu_private --privateFor=<private transaction addresses of receiver(s)> --privateFrom=<private transaction address of sender>
```

**NOTE:** List receiver addresses seperated by comma(,)

### Send a private transaction

```
node test.js --url=<url of the target node> --contract=<contract address from the output above> --set=<new value> --privateFor='["<private transaction addresses>"]'
```

### Send a private transaction to a Besu node

```
node test.js --url=<url of the target node> --contract=<contract address from the output above> --set=<new value> --besu_private --privateFor=<private transaction addresses of receiver(s)> --privateFrom=<private transaction address of sender>
```

### Query a private transaction from a Besu node

```
node test.js --url=<url of the target node> --contract=<contract address from the output above> --query --besu_private --privateFor=<private transaction addresses of receiver(s)> --privateFrom=<private transaction address of sender>
```

### Use an external account to deploy contract and sign a transaction

```
node test.js --sign --url=<url of the target node> --deploy
node test.js --sign --url=<url of the target node> --contract=<contract address from the output above> --set=<new value>
```

### Use hdwallet account to deploy contract and sign a transaction

**Note:** EthSigner's hdwallet service must be provisioned and a wallet created to use this option

```
node test.js --sign --hdwalletUrl=<url of the hdwallet service> --hdwalletId=<hdwallet ID> --hdwalletAccountIndex=<account index to anonymize identity> --url=<url of the target node> --deploy
node test.js --sign --hdwalletUrl=<url of the hdwallet service> --hdwalletId=<hdwallet ID> --hdwalletAccountIndex=<account index to anonymize identity> --url=<url of the target node> --contract=<contract address from the output above> --set=<new value>
```
