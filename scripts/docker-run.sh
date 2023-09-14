#!/bin/bash -e

# Catch SIGINT to clean up everything properly
trap handler SIGINT

# Virtual environment python3 binary
VENV_PYTHON3=/config/venv/bin/python3

# SIGINT handler
handler() {
    # Kill the bot and TrafficToll (use SIGINT to allow for cleaning up)
    pkill -INT --full $VENV_PYTHON3
    exit 0
}

# Important directories
APP_DIR=${APP_DIR:-/app}
SCRIPT_DIR=${SCRIPT_DIR:-/scripts}

# Default network interface
IFACE="$(ip route | grep default | awk '{print $5}')"

# Create a config directory for TrafficToll
mkdir -p /config/traffic-toll

# Create a config file for TrafficToll
printf "
# TrafficToll configuration file
# Global bandwidth limit
download: 500kbps
upload: 100kbps
" >/config/traffic-toll/config.yml

# Create an ifb interface for TrafficToll if it doesn't exist
if [[ $(ip link show | grep -c ifb) -lt 1 ]]; then
    # Create an ifb interface
    ip link add ifb0 type ifb
    # Set the ifb interface up
    ip link set dev ifb0 up
fi

# Use TrafficToll to limit Chromium's bandwidth
$VENV_PYTHON3 -m traffictoll $IFACE /config/traffic-toll/config.yml &

# Run the bot!
$VENV_PYTHON3 $APP_DIR/main.py --nomenu --nowait --docker --profiles default &
