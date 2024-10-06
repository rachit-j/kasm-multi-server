#!/bin/bash

# Prompt user for inputs
read -p "Enter AWS region: " region
read -p "Enter the number of agent servers (default 1): " agent_server_count
read -p "Enter the size of agent servers (default c5.xlarge): " agent_server_size
read -p "Enter the size of other servers (DB, Guac, Web) (default c5.xlarge): " other_server_size
read -p "Enter the disk size of agent servers in GB (default 50): " agent_server_disk_size
read -p "Enter the disk size of other servers (DB, Guac, Web) in GB (default 50): " other_server_disk_size
read -p "Enter custom AMI ID if region-specific AMI is not available (leave blank if not needed): " custom_ami

# Prompt user for passwords with default values
read -p "Enter user password [default: 123Qwerty!]: " user_password
user_password=${user_password:-123Qwerty!}

read -p "Enter admin password [default: 123Qwerty!]: " admin_password
admin_password=${admin_password:-123Qwerty!}

read -p "Enter database password [default: 123Qwerty!]: " database_password
database_password=${database_password:-123Qwerty!}

read -p "Enter redis password [default: 123Qwerty!]: " redis_password
redis_password=${redis_password:-123Qwerty!}

read -p "Enter manager token [default: 123Qwerty!]: " manager_token
manager_token=${manager_token:-123Qwerty!}

read -p "Enter registration token [default: 123Qwerty!]: " registration_token
registration_token=${registration_token:-123Qwerty!}

# Set default values if not provided
agent_server_count=${agent_server_count:-1}
agent_server_size=${agent_server_size:-"c5.xlarge"}
other_server_size=${other_server_size:-"c5.xlarge"}
agent_server_disk_size=${agent_server_disk_size:-50}
other_server_disk_size=${other_server_disk_size:-50}

# Save inputs to .envinputs
cat <<EOF > .envinputs
region=$region
agent_server_count=$agent_server_count
agent_server_size=$agent_server_size
other_server_size=$other_server_size
agent_server_disk_size=$agent_server_disk_size
other_server_disk_size=$other_server_disk_size
custom_ami=$custom_ami
user_password=$user_password
admin_password=$admin_password
database_password=$database_password
redis_password=$redis_password
manager_token=$manager_token
registration_token=$registration_token
EOF

# Initialize Terraform
terraform init

if [ -z "$custom_ami" ]; then
  terraform apply -var="region=$region" -var="agent_server_count=$agent_server_count" -var="agent_server_size=$agent_server_size" -var="other_server_size=$other_server_size" -var="agent_server_disk_size=$agent_server_disk_size" -var="other_server_disk_size=$other_server_disk_size" -auto-approve
else
  terraform apply -var="region=$region" -var="agent_server_count=$agent_server_count" -var="agent_server_size=$agent_server_size" -var="other_server_size=$other_server_size" -var="agent_server_disk_size=$agent_server_disk_size" -var="other_server_disk_size=$other_server_disk_size" -var="custom_ami=$custom_ami" -auto-approve
fi

# Capture IP addresses from Terraform output
agent_server_ips=$(terraform output -json agent_server_ips | jq -r '.[]' | tr '\n' ',')
agent_server_ips=${agent_server_ips%,} # Remove the trailing comma

db_server_ip=$(terraform output -json db_server_ip | jq -r '.')
guac_server_ip=$(terraform output -json guac_server_ip | jq -r '.')
web_server_ip=$(terraform output -json web_server_ip | jq -r '.')

# Store IP addresses in .envservers
cat <<EOF > .envservers
agent_server_ips=$agent_server_ips
db_server_ip=$db_server_ip
guac_server_ip=$guac_server_ip
web_server_ip=$web_server_ip
EOF

# Get the generated key file name
key_name=$(terraform output -raw key_name)
key_file="${key_name}.pem"
echo "key_file=$key_file" >> .envservers
