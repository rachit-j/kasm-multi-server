#!/bin/bash

# Run the dependencies script
chmod +x kasm_dependencies.sh
./kasm_dependencies.sh

# Run the deployment script
chmod +x kasm_aws_instances.sh
./kasm_aws_instances.sh

sleep 20

# Run the command execution script
chmod +x kasm_servers_tools.sh
./kasm_servers_tools.sh

# Run the update inventory script
chmod +x kasm_servers_info.sh
./kasm_servers_info.sh

# Run the playbook script
chmod +x kasm_servers_playbook.sh
./kasm_servers_playbook.sh
