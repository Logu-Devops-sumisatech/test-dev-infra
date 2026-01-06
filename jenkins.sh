#!/bin/bash
apt update -y
apt install -y openjdk-17-jdk wget gnupg

curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key \
 | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian binary/" \
 | tee /etc/apt/sources.list.d/jenkins.list

apt update -y
apt install -y jenkins
systemctl enable jenkins
systemctl start jenkins
