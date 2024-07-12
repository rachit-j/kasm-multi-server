#!/bin/bash

read -p "Enter AWS region: " region
read -p "Enter the number of agent servers (default 1): " agent_server_count
read -p "Enter the size of agent servers (default t3.medium): " agent_server_size
read -p "Enter the size of other servers (DB, Guac, Web) (default t3.medium): " other_server_size
read -p "Enter the disk size of agent servers in GB (default 50): " agent_server_disk_size
read -p "Enter the disk size of other servers (DB, Guac, Web) in GB (default 50): " other_server_disk_size
read -p "Enter custom AMI ID if region-specific AMI is not available (leave blank if not needed): " custom_ami

# Set default values if not provided
agent_server_count=${agent_server_count:-1}
agent_server_size=${agent_server_size:-"t3.medium"}
other_server_size=${other_server_size:-"t3.medium"}
agent_server_disk_size=${agent_server_disk_size:-50}
other_server_disk_size=${other_server_disk_size:-50}

# Initialize Terraform
terraform init

if [ -z "$custom_ami" ]; then
  terraform apply -var="region=$region" -var="agent_server_count=$agent_server_count" -var="agent_server_size=$agent_server_size" -var="other_server_size=$other_server_size" -var="agent_server_disk_size=$agent_server_disk_size" -var="other_server_disk_size=$other_server_disk_size" -auto-approve
else
  terraform apply -var="region=$region" -var="agent_server_count=$agent_server_count" -var="agent_server_size=$agent_server_size" -var="other_server_size=$other_server_size" -var="agent_server_disk_size=$agent_server_disk_size" -var="other_server_disk_size=$other_server_disk_size" -var="custom_ami=$custom_ami" -auto-approve
fi

# Capture IP addresses from Terraform output
agent_server_ips=$(terraform output -json agent_server_ips | jq -r '.[]')
db_server_ip=$(terraform output -json db_server_ip | jq -r '.')
guac_server_ip=$(terraform output -json guac_server_ip | jq -r '.')
web_server_ip=$(terraform output -json web_server_ip | jq -r '.')

# Store IP addresses in files
echo "$agent_server_ips" > agent_server_ips.txt
echo "$db_server_ip" > db_server_ip.txt
echo "$guac_server_ip" > guac_server_ip.txt
echo "$web_server_ip" > web_server_ip.txt

# Get the generated key file name
key_name=$(terraform output -raw key_name)
key_file="${key_name}.pem"
echo "$key_file" > key_file.txt
