#!/bin/bash -e

# Catch SIGINT to clean up everything properly
trap handler SIGINT

# SIGINT handler
handler() {
    # Kill the bot and TrafficToll (use SIGINT to allow for cleaning up)
    killall -INT /config/venv/bin/python3 || true
    exit 0
}

# Important directories
APP_DIR=${APP_DIR:-/app}
SCRIPT_DIR=${SCRIPT_DIR:-/scripts}

# Virtual environment python3 binary
PYTHON3=/config/venv/bin/python3

# Default network interface
IFACE="$(ip route | grep default | awk '{print $5}')"

# Create a config directory for TrafficToll
mkdir -p /config/traffic-toll

# Create a config file for TrafficToll
printf "
# TrafficToll configuration file
download: 500kbps
upload: 100kbps

# No process limits until tt is patched
# # Limit Chromium bandwidth
# processes:
#   Chromium:
#     # Limits for this process
#     download: 500kbps
#     upload: 100kbps

#     match:
#       - exe: /usr/lib/chromium/chromium
" >/config/traffic-toll/config.yml

# Create an ifb interface for TrafficToll if it doesn't exist
if [[ $(ip link show | grep -c ifb) -lt 1 ]]; then
    # Create an ifb interface
    ip link add ifb0 type ifb
    # Set the ifb interface up
    ip link set dev ifb0 up
fi

# Use TrafficToll to limit Chromium's bandwidth
$PYTHON3 -m traffictoll $IFACE /config/traffic-toll/config.yml &

# Run the bot!
$PYTHON3 $APP_DIR/main.py --nomenu --nowait --docker --profiles default &
