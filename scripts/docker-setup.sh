#!/bin/bash -e

APP_DIR=${APP_DIR:-/app}
SCRIPT_DIR=${SCRIPT_DIR:-/scripts}

# Required packages and modules
declare -a PACKAGES=(
    gcc
    libc-dev
    linux-headers
    python3
    python3-dev
    py3-pip
    chromium-chromedriver
    iproute2
    htop
    speedtest-cli
)

# Prompt
echo "Installing required packages..."

# Install required packages
apk update && apk add ${PACKAGES[@]}

# Prompt
echo "Creating a new python3 virtual environment..."

# Create virtual environment
python3 -m venv /config/venv
# Start virtual environment
source /config/venv/bin/activate
# Update /config
mkdir -p /config/.cache/pip && chmod -R 777 /config

# Prompt
echo "Installing required modules..."

# Install required modules
pip3 install -r $SCRIPT_DIR/requirements.txt

# Exit virtual environment
deactivate

# Prompt
echo "Done!"
