#!/bin/bash

# Ensure the inventory file and playbook exist
if [ ! -f inventory ]; then
  echo "Error: inventory file not found!"
  exit 1
fi

if [ ! -f install_kasm.yml ]; then
  echo "Error: Ansible playbook install_kasm.yml not found!"
  exit 1
fi

# Run the Ansible playbook
ansible-playbook -i inventory install_kasm.yml

# Check if the playbook ran successfully
if [ $? -eq 0 ]; then
  echo "Ansible playbook executed successfully."
else
  echo "Error: Ansible playbook execution failed."
  exit 1
fi
