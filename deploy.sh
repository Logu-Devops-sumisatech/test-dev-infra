#!/bin/bash
set -e

<<<<<<< HEAD
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
=======
echo "Initializing Terraform"
terraform init

echo "Formatting Terraform files"
terraform fmt

echo "Validating Terraform"
terraform validate

echo "Planning Terraform"
terraform plan -out=tfplan

echo "Applying Terraform"
terraform apply -auto-approve tfplan

echo "Terraform Outputs"
terraform output

echo "Terraform deployment completed successfully"

>>>>>>> 5b058f5 (new main.tf)
