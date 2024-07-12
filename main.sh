#!/bin/bash

# Run the install_dependencies.sh script
if [ -f ./install_dependencies.sh ]; then
  ./install_dependencies.sh
else
  echo "install_dependencies.sh script not found!"
  exit 1
fi

# Function to display file contents slowly
slow_cat() {
  local filename="$1"
  local delay="$2"

  # Check if the file exists
  if [ ! -f "$filename" ]; then
    echo "File not found!"
    return 1
  fi

  # Display the file contents line by line with a delay
  while IFS= read -r line || [[ -n "$line" ]]; do
    echo "$line"
    sleep "$delay" # Adjust the delay (in seconds) as needed
  done < "$filename"
}

# Function to display the menu
show_menu() {
  echo "Menu Options"
  echo "1. Install Kasm (run launch.sh)"
  echo "2. Install Kasm Images on Prewritten Inventory"
  echo "3. Start Kasm"
  echo "4. Stop Kasm"
  echo "5. Restart Kasm"
  echo "6. Update Kasm"
  echo "7. Uninstall Kasm"
  echo "8. Uninstall Kasm and Delete the Instances"
  echo "9. Exit"
  echo ""
  echo -n "Enter your choice: "
}

# Main script execution

# Print each line of the ASCII art slowly
ascii_art_file="ascii_launch"  # Store your ASCII art in this file
delay="0.5"  # Adjust the delay (in seconds) as needed

slow_cat "$ascii_art_file" "$delay"

echo "Written by nighthawkcodingsociety"
echo "https://github.com/nighthawkcoders"
echo ""

# Display the menu and handle user input
while true; do
  show_menu
  read choice
  case $choice in
    1)
      ./launch.sh
      ;;
    2)
      echo "Install Kasm Images on Prewritten Inventory"
      echo "Make sure that docker is installed on all images, otherwise ctrl-c to escape"
      sleep 10
      ansible-playbook -i inventory install_kasm.yml
      ;;
    3)
      echo "Start Kasm command will be here"
      ansible-playbook -i inventory start_kasm.yml
      ;;
    4)
      echo "Stop Kasm command will be here"
      ansible-playbook -i inventory stop_kasm.yml
      ;;
    5)
      echo "Restart Kasm command will be here"
      ansible-playbook -i inventory restart_kasm.yml
      ;;
    6)
      echo "Update Kasm command will be here"
      echo "Please update the inventory file as needed and press Enter to continue..."
      read -r
      ansible-playbook -i inventory install_kasm.yml
      ;;
    7)
      echo "Uninstall Kasm command will be here"
      ansible-playbook -i inventory uninstall_kasm.yml
      ;;
    8)
      echo "Uninstall Kasm and delete instances command will be here"
      ansible-playbook -i inventory uninstall_kasm.yml
      terraform destroy -auto-approve
      ;;
    9)
      echo "Exiting..."
      break
      ;;
    *)
      echo "Invalid choice, please try again."
      ;;
  esac
done
