#!/bin/bash
set -e

echo "initializing terraform "
terraform init

echo "validating terraform "
terraform valiadte

echo "formatting terraform"
terraform fmt

echo "terraform planing"
terraform plan -out=tfplan

echo "applaying terraform"
terraform apply -auto-approve tfplan

echo "terrafrom output"
terraform output

echo "terraform deployed complete"
