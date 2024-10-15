#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define the virtual environment directory
VENV_DIR="tutorial-env"

# Check if the virtual environment already exists
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment in $VENV_DIR..."
    python3 -m venv "$VENV_DIR"
else
    echo "Virtual environment already exists in $VENV_DIR."
fi

# Activate the virtual environment
echo "Activating virtual environment..."
source "$VENV_DIR/bin/activate"

# Upgrade pip to the latest version
echo "Upgrading pip..."
python3 -m pip install --upgrade pip

# Install dependencies from requirements.txt, if the file exists
if [ -f "requirements.txt" ]; then
    echo "Installing dependencies from requirements.txt..."
    python3 -m pip install -r requirements.txt
else
    echo "No requirements.txt file found. Skipping dependency installation."
fi


# Install ansible collection for azure and dependencies
ansible-galaxy collection install azure.azcollection
ansible-galaxy collection install community.general

# install azure collection dependencies
COLLECTION_PATH="$VENV_DIR/lib/python3.12/site-packages/ansible_collections/azure/azcollection"
REQUIREMENTS_FILE="$COLLECTION_PATH/requirements.txt"

if [ -f "$REQUIREMENTS_FILE" ]; then
    echo "Installing dependencies from $REQUIREMENTS_FILE..."
    pip install -r "$REQUIREMENTS_FILE"
else
    echo "No requirements.txt found at $REQUIREMENTS_FILE."
fi

# Deactivate the virtual environment
echo "Deactivating virtual environment..."
deactivate

echo "Setup completed."
