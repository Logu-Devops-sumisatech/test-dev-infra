#!/bin/bash
set -e

# Update
apt update -y
apt install -y openjdk-17-jdk wget gnupg

# Add Jenkins repo
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/" | tee /etc/apt/sources.list.d/jenkins.list

# Install Jenkins
apt update -y
apt install -y jenkins

# Enable & start Jenkins
systemctl enable jenkins
systemctl start jenkins
