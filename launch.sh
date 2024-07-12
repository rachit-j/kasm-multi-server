#!/bin/bash

# Run the dependencies script
chmod +x install_dependencies.sh
./install_dependencies.sh

# Run the deployment script
chmod +x deploy.sh
./deploy.sh

sleep 20

# Run the command execution script
chmod +x execute_commands.sh
./execute_commands.sh

# Run the update inventory script
chmod +x update_inventory.sh
./update_inventory.sh

# Run the playbook script
chmod +x run_playbook.sh
./run_playbook.sh

