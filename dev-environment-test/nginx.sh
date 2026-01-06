#!/bin/bash
set -e

# Update
apt update -y

# Install Nginx
apt install -y nginx

# Enable & start Nginx
systemctl enable nginx
systemctl start nginx
