#!/bin/bash

# Update package lists
sudo apt-get update

# Install required packages
sudo apt-get install -y ca-certificates curl gnupg

# Create directory for keyrings
sudo mkdir -p /etc/apt/keyrings

# Fetch Nodesource GPG key and save to keyring
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

# Set NODE_MAJOR variable
NODE_MAJOR=20

# Add Nodesource repository to sources list
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /e>

# Update package lists again
sudo apt-get update

# Install Node.js
sudo apt-get install nodejs -y

# Clone repository
git clone https://github.com/lokidv/ovpn.git

# Move ovpn directory to /home
mv ovpn/ /home

# Navigate to /home
cd /home

# Create directory 'bvpn'
mkdir bvpn

# Move contents of 'ovpn' to 'bvpn'
mv ovpn/* bvpn/

# Remove 'ovpn' directory
rm -r ovpn/

# Navigate to 'bvpn' directory
cd bvpn/

# Install npm dependencies
npm i

# Move openvpn-install.sh to /home/bvpn/
mv /root/openvpn-install.sh /home/bvpn/

# Create and edit bvpn.service file
echo "[Unit]
Description=Tunnel WireGuard with udp2raw
After=network.target

[Service]
Type=simple
User=root
ExecStart=sudo node /home/bvpn/main.js
Restart=no

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/bvpn.service

# Enable and start bvpn.service
sudo systemctl enable --now bvpn.service