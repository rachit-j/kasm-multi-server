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

# Function to install Ansible
install_ansible() {
  if command -v apt-get &>/dev/null; then
    sudo apt-get update -y
    sudo apt-get install -y ansible
  elif command -v yum &>/dev/null; then
    sudo yum install -y epel-release
    sudo yum install -y ansible
  elif command -v snap &>/dev/null; then
    sudo snap install ansible --classic
  elif command -v brew &>/dev/null; then
    brew install ansible
  else
    echo "Unsupported package manager. Please install Ansible manually."
    exit 1
  fi
}

# Function to install jq
install_jq() {
  if command -v apt-get &>/dev/null; then
    sudo apt-get update -y
    sudo apt-get install -y jq
  elif command -v yum &>/dev/null; then
    sudo yum install -y epel-release
    sudo yum install -y jq
  elif command -v snap &>/dev/null; then
    sudo snap install jq
  elif command -v brew &>/dev/null; then
    brew install jq
  else
    echo "Unsupported package manager. Please install jq manually."
    exit 1
  fi
}

# Function to install AWS CLI
install_awscli() {
  if command -v apt-get &>/dev/null; then
    sudo apt-get update -y
    sudo apt-get install -y awscli
  elif command -v yum &>/dev/null; then
    sudo yum install -y awscli
  elif command -v snap &>/dev/null; then
    sudo snap install aws-cli --classic
  elif command -v brew &>/dev/null; then
    brew install awscli
  else
    echo "Unsupported package manager. Please install AWS CLI manually."
    exit 1
  fi
}

sleep 0.2

# Install Ansible
if ! command -v ansible &>/dev/null; then
  echo "Ansible not found. Installing Ansible..."
  install_ansible
  if [ $? -ne 0 ]; then
    echo "Error: Ansible installation failed."
    exit 1
  fi
else
  echo "Ansible is already installed."
fi

# Install jq
if ! command -v jq &>/dev/null; then
  echo "jq not found. Installing jq..."
  install_jq
  if [ $? -ne 0 ]; then
    echo "Error: jq installation failed."
    exit 1
  fi
else
  echo "jq is already installed."
fi

sleep 0.2

# Install AWS CLI
if ! command -v aws &>/dev/null; then
  echo "AWS CLI not found. Installing AWS CLI..."
  install_awscli
  if [ $? -ne 0 ]; then
    echo "Error: AWS CLI installation failed."
    exit 1
  fi
else
  echo "AWS CLI is already installed."
fi

sleep 0.2

# Check for the Kasm release tar.gz file
if [ ! -f roles/install_common/files/*.tar.gz ]; then
  echo "Warning: No Kasm release .tar.gz file found in roles/install_common/files/."
else
  echo "Kasm release .tar.gz file found in roles/install_common/files/."
  echo "Please ensure this is the correct file for your installation."
fi

sleep 0.2

# Additional dependencies can be added here as needed

echo "All dependencies have been installed successfully."
