#!/usr/bin/env bash

# Check if verbosity parameter is passed
VERBOSITY_LEVEL=${1:-"-v"}  

# Exit immediately if a command exits with a non-zero status
set -e

# Load all variables from .env and export them all for Ansible to read
set -o allexport
source "$(dirname "$0")/.env"
set +o allexport

# Define the virtual environment directory
VENV_DIR="tutorial-env"

source "$VENV_DIR/bin/activate"

# Activate the virtual environment
echo "Activating virtual environment..."
source "$VENV_DIR/bin/activate"

# Run ansible playbook
ansible-playbook configure_azure.yml $VERBOSITY_LEVEL

# Deactivate the virtual environment
echo "Deactivating virtual environment..."
deactivate

echo "Execution completed."
