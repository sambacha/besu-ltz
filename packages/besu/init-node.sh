#!/bin/bash

rm -rf /opt/besu/database

echo "BESU_OPTS: $BESU_OPTS"

# Initialize command
cmd="/opt/besu/bin/besu"

# Set P2P flag
p2p_host=`awk 'END{print $1}' /etc/hosts`
cmd="${cmd} --p2p-host=${p2p_host}"

# Set Bootnode flag
if [[ ! -z "${BOOTNODE}" ]]; 
then
    echo "Starting as Bootnode"
    # Save bootnode PKEY in volume
    /opt/besu/bin/besu public-key export --to="/opt/besu/public-keys/bootnode.pub"
    cmd="${cmd} --bootnodes"
else
    # Wait for bootnode public key to be generated
    while [ ! -f "/opt/besu/public-keys/bootnode.pub" ]
    do
        sleep 1
    done

    # Extract bootnode PKEY from volume
    bootnode_pubkey=`sed 's/^0x//' /opt/besu/public-keys/bootnode.pub`
    boonode_ip=`getent hosts validator1-bootnode | awk '{ print $1 }'`
    bootnode_enode="enode://${bootnode_pubkey}@${boonode_ip}:30303"
    cmd="${cmd} --bootnodes=${bootnode_enode}" 
fi

# Set Orion privacy configuration
if [[ ! -z "${ORION_URL}" ]]; then 
    echo "Starting with Orion Privacy enabled"
    cmd="${cmd} \
--privacy-enabled=true \
--privacy-url=${ORION_URL} \
--privacy-public-key-file=/config/${ORION_NAME}/nodeKey.pub";
fi

# Set RPC HTTP options
if [[ ! -z "${RPC_HTTP_API}" ]]; then
    echo "JSON-RPC HTTP enabled"
    cmd="${cmd} \
--rpc-http-enabled \
--rpc-http-api=${RPC_HTTP_API} \
--rpc-http-host=0.0.0.0 \
--rpc-http-port=8545 \
--rpc-http-cors-origins=\"*\""
fi

# Set RPC WS options
if [[ ! -z "${RPC_WS_API}" ]]; then
    echo "JSON-RPC WS enabled"
    cmd="${cmd} \
--rpc-ws-enabled \
--rpc-ws-api=${RPC_WS_API} \
--rpc-ws-host=0.0.0.0 \
--rpc-ws-port=8546"
fi

# Set GraphQL options
if [[ ! -z "${GRAPHQL}" ]]; then
    echo "GraphQL enabled"
    cmd="${cmd} \
--graphql-http-enabled \
--graphql-http-host=0.0.0.0 \
--graphql-http-port=8547 \
--graphql-http-cors-origins=\"*\""
fi

# Set GraphQL options
if [[ ! -z "${METRICS}" ]]; then
    echo "Metrics enabled"
    cmd="${cmd} \
--metrics-enabled \
--metrics-host=0.0.0.0 \
--metrics-port=9545"
fi




cmd="${cmd} \
--genesis-file=/config/genesis.json \
--min-gas-price=0 \
--data-path=/opt/besu/data \
--node-private-key-file=/config/${NODE_NAME}/keys/key.priv \
--revert-reason-enabled"

echo ${cmd}
eval $cmd
Terms