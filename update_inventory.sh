#!/bin/bash

# Load IP addresses from files
agent_server_ips=$(cat agent_server_ips.txt)
db_server_ip=$(cat db_server_ip.txt)
guac_server_ip=$(cat guac_server_ip.txt)
web_server_ip=$(cat web_server_ip.txt)

# Load the SSH key file name
key_file=$(cat key_file.txt)

# Prompt user for passwords with default values
read -p "Enter user password [default: password]: " user_password
user_password=${user_password:-password}

read -p "Enter admin password [default: password]: " admin_password
admin_password=${admin_password:-password}

read -p "Enter database password [default: password]: " database_password
database_password=${database_password:-password}

read -p "Enter redis password [default: password]: " redis_password
redis_password=${redis_password:-password}

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
EOF

# Add agent server IPs
index=1
for ip in $agent_server_ips; do
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
    zones:
      - zone1
    proxy_port: 443
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
