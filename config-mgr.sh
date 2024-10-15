#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define the virtual environment directory
VENV_DIR="tutorial-env"

# Activate the virtual environment
echo "Activating virtual environment..."
source "$VENV_DIR/bin/activate"

# Run ansible playbook
ansible-playbook configure_azure.yml -vv

# Deactivate the virtual environment
echo "Deactivating virtual environment..."
deactivate

echo "Execution completed."
