#!/bin/bash

# Load environment variables
agent_server_ips=$(cat .envservers | grep agent_server_ips | cut -d '=' -f2-)
db_server_ip=$(cat .envservers | grep db_server_ip | cut -d '=' -f2-)
guac_server_ip=$(cat .envservers | grep guac_server_ip | cut -d '=' -f2-)
web_server_ip=$(cat .envservers | grep web_server_ip | cut -d '=' -f2-)
key_file=$(cat .envservers | grep key_file | cut -d '=' -f2-)

IFS=',' read -r -a agent_ips_array <<< "$agent_server_ips"

# Commands to run on each server
commands=$(cat <<'EOF'
#!/bin/bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo apt-get install -y docker-compose
EOF
)

# Function to SSH and run commands
run_commands() {
  local ip=$1
  ssh -i "$key_file" -o StrictHostKeyChecking=no ubuntu@"$ip" <<EOF
    sudo bash -c '$commands'
EOF
}

# Run commands on agent servers
for ip in "${agent_ips_array[@]}"; do
  run_commands "$ip"
done

# Run commands on DB server
run_commands "$db_server_ip"

# Run commands on Guac server
run_commands "$guac_server_ip"

# Run commands on Web server
run_commands "$web_server_ip"
