#! /bin/bash

echo "Script started..."
echo "Downloading and installing Docker is started..."
curl -fsSL https://get.docker.com -o get-docker.sh && \
sh get-docker.sh && \
rm get-docker.sh
echo "Finished..."

echo "Starting Docker..."
usermod -aG docker $USER

systemctl enable docker
systemctl start docker

sysctl -w net.core.rmem_max=26214400
sysctl -w net.core.rmem_default=26214400
echo "Docker started..."

echo "Starting celestia light node..."
CID=$(docker run -d -e NODE_TYPE=light ghcr.io/celestiaorg/celestia-node:0.6.1 celestia light start --core.ip https://rpc-mocha.pops.one --gateway --gateway.addr 127.0.0.1 --gateway.port 26659 --p2p.network mocha)
echo "Node is running..."

sleep 10

echo "Getting address with phrases..."
docker logs $CID 2>&1 | grep "ADDRESS"
docker logs $CID 2>&1 | grep -A 1 "MNEMONIC"

echo "PLEASE: Save ADDRESS and MNEMONIC!"

echo "Script finished."
