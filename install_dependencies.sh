#!/bin/bash

# Check for and install Homebrew (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
  if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [ $? -ne 0 ]; then
      echo "Error: Homebrew installation failed."
      exit 1
    fi
  else
    echo "Homebrew is already installed."
  fi
else
  echo "Skipping Homebrew installation (not macOS)."
fi

# Check for and install Ansible
if ! command -v ansible &>/dev/null; then
  echo "Ansible not found. Installing Ansible..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install ansible
  else
    sudo apt-get update -y
    sudo apt-get install -y ansible
  fi
  if [ $? -ne 0 ]; then
    echo "Error: Ansible installation failed."
    exit 1
  fi
else
  echo "Ansible is already installed."
fi

# Check for and install jq
if ! command -v jq &>/dev/null; then
  echo "jq not found. Installing jq..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install jq
  else
    sudo apt-get update -y
    sudo apt-get install -y jq
  fi
  if [ $? -ne 0 ]; then
    echo "Error: jq installation failed."
    exit 1
  fi
else
  echo "jq is already installed."
fi

# Additional dependencies can be added here as needed

echo "All dependencies have been installed successfully."
