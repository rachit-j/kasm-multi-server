#!/bin/bash

# Load environment variables from .envinputs and .envservers
user_password=$(cat .envinputs | grep user_password | cut -d '=' -f2)
admin_password=$(cat .envinputs | grep admin_password | cut -d '=' -f2)
database_password=$(cat .envinputs | grep database_password | cut -d '=' -f2)
redis_password=$(cat .envinputs | grep redis_password | cut -d '=' -f2)
manager_token=$(cat .envinputs | grep manager_token | cut -d '=' -f2)
registration_token=$(cat .envinputs | grep registration_token | cut -d '=' -f2)

agent_server_ips=$(cat .envservers | grep agent_server_ips | cut -d '=' -f2)
db_server_ip=$(cat .envservers | grep db_server_ip | cut -d '=' -f2)
guac_server_ip=$(cat .envservers | grep guac_server_ip | cut -d '=' -f2)
web_server_ip=$(cat .envservers | grep web_server_ip | cut -d '=' -f2)
key_file=$(cat .envservers | grep key_file | cut -d '=' -f2)

# Split the agent_server_ips into an array
IFS=',' read -r -a agent_ips_array <<< "$agent_server_ips"

# Create a new inventory file
cat <<EOF > inventory
##################
# Host inventory #
##################
all:
  children:
    zone1:
      children:
        zone1_db:
          hosts:
            zone1_db_1:
              ansible_host: $db_server_ip  # Updated IP for KasmDBServer
              ansible_port: 22
              ansible_ssh_user: ubuntu
              ansible_ssh_private_key_file: $key_file
        zone1_web:
          hosts:
            zone1_web_1:
              ansible_host: $web_server_ip  # Updated IP for KasmWebServer
              ansible_port: 22
              ansible_ssh_user: ubuntu
              ansible_ssh_private_key_file: $key_file
        zone1_agent:
          hosts:
EOF

# Add agent server IPs
index=1
for ip in "${agent_ips_array[@]}"; do
  cat <<EOF >> inventory
            zone1_agent_$index:
              ansible_host: $ip  # Updated IP for KasmAgentServer
              ansible_port: 22
              ansible_ssh_user: ubuntu
              ansible_ssh_private_key_file: $key_file
EOF
  index=$((index + 1))
done

# Add the remaining sections
cat <<EOF >> inventory
        zone1_guac:
          hosts:
            zone1_guac_1:
              ansible_host: $guac_server_ip  # Updated IP for KasmGuacServer
              ansible_port: 22
              ansible_ssh_user: ubuntu
              ansible_ssh_private_key_file: $key_file
  vars:
    default_web: 1
    user_password: $user_password
    admin_password: $admin_password
    database_password: $database_password
    redis_password: $redis_password
    manager_token: $manager_token
    registration_token: $registration_token
    zones:
      - zone1
    proxy_port: 8443
    start_docker_on_boot: true
    desired_swap_size: 3g
    init_remote_db: false
    database_hostname: false
    database_user: kasmapp
    database_name: kasm
    database_port: 5432
    database_ssl: true
    redis_hostname: false
    remote_backup_dir: /srv/backup/kasm/
    retention_days: 10
    reboot_timeout_seconds: 600
EOF

echo "Inventory file 'inventory' has been updated."
