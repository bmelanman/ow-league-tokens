#!/bin/bash -e

# Important directories
APP_DIR=/app
SCRIPT_DIR=/scripts
VENV_DIR=/config/venv

# Virtual env python3 binary
VENV_PYTHON3=$VENV_DIR/bin/python3
# Virtual env pip3 binary
VENV_PIP3=$VENV_DIR/bin/pip3

# Default network interface
export IFACE="$(ip route | grep default | awk '{print $5}')"

# Check if the startup script is running for the first time
if [[ ! -f /config/.config/traffictoll-config.yaml ]]; then

    echo "First time setup!"
    echo "Installing required packages..."

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

    # Install required packages
    apk update && apk add ${PACKAGES[@]}

    echo "Creating a python3 virtual environment..."
    python3 -m venv $VENV_DIR

    echo "Installing required modules..."
    mkdir -p /config/.cache/pip
    $VENV_PIP3 install -r $SCRIPT_DIR/requirements.txt

    # Create a config file for TrafficToll
    cp $SCRIPT_DIR/traffictoll-config.yaml /config/.config/traffictoll-config.yaml

    echo "First time setup complete!"

fi

# Create an ifb interface for TrafficToll if it doesn't exist
echo "Checking for ifb interface..."
if [[ $(ip link show | grep -c ifb) -lt 1 ]]; then
    echo "Creating ifb interface..."
    ip link add ifb0 type ifb
    ip link set dev ifb0 up
else
    # Prompt
    echo "ifb interface already exists!"
fi

echo "Closing all open chromium instances..."
while pkill -o chromium; do
    sleep 1
done

echo "Adding venv TrafficToll to PATH..."
mkdir -p /config/bin && ln -sf $VENV_DIR/bin/tt /config/bin/tt
# Update PATH
export PATH=$PATH:/config/bin

echo "Starting the bot..."
$VENV_PYTHON3 $APP_DIR/main.py --nomenu --nowait --docker --profiles default
