#!/bin/bash -e

APP_DIR=${APP_DIR:-/app}
SCRIPT_DIR=${SCRIPT_DIR:-/scripts}

# Start virtual environment
source $APP_DIR/venv/bin/activate

# Apply network bandwidth limits
$SCRIPT_DIR/network-setup.sh

# Run the bot!
python3 $APP_DIR/main.py --nomenu --nowait --docker --profiles default
