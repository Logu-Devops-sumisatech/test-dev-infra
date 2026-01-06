#!/bin/bash
<<<<<<< HEAD
apt update -y
apt install -y nginx
=======
set -e

# Update
apt update -y

# Install Nginx
apt install -y nginx

# Enable & start Nginx
>>>>>>> 5b058f5 (new main.tf)
systemctl enable nginx
systemctl start nginx
