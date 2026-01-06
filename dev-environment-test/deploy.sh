#!/bin/bash
set -e

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

