#!/bin/bash -ex

# Full path to TrafficControl
TC=$(which tc)

# Default network interface
IFACE="$(ip route | grep default | awk '{print $5}')"

# Target speeds
SPEED_IFACE=1mbps
SPEED_DOWN=500kbps
SPEED_UP=100kbps

# Check if a fifo queue exists and prompt to remove it
CHK=$($TC qdisc show dev $IFACE | grep -q "qdisc pfifo_fast 0" && echo 1 || echo 0)
if [[ $CHK -gt 0 ]]; then
    echo "Existing rules found. Remove them? [y/N]"
    read -r -n 1 -s
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        $TC qdisc del dev $IFACE root
    else
        echo "Aborting..."
        exit 1
    fi
fi

# Print speeds before if in debug mode
if [[ $# -ge 1 ]]; then
    echo "Speeds before:"
    speedtest-cli --simple
fi

# Prompt
echo "Setting up network bandwidth limits..."
echo "Interface: $IFACE"
echo "Down: $SPEED_DOWN"
echo "Up: $SPEED_UP"

# Filter options for limiting the intended interface.
FILTER="$TC filter add dev $IFACE protocol ip parent 1: prio 1 u32"

# Create a new root qdisc
$TC qdisc add dev $IFACE root handle 1: htb default 30
$TC class add dev $IFACE parent 1: classid 1:1 htb rate $SPEED_IFACE burst 15k

# Set upload and download speeds
$TC class add dev $IFACE parent 1:1 classid 1:10 htb rate $SPEED_DOWN burst 15k
$TC class add dev $IFACE parent 1:1 classid 1:20 htb rate $SPEED_UP burst 15k

# Create a filter for the upload and download speeds
$TC qdisc add dev $IFACE parent 1:10 handle 10: sfq perturb 10
$TC qdisc add dev $IFACE parent 1:20 handle 20: sfq perturb 10

# Apply the filter rules globally
$FILTER match ip dst 0.0.0.0/0 flowid 1:10
$FILTER match ip src 0.0.0.0/0 flowid 1:20

# Print the new rules
$TC qdisc show dev $IFACE
echo "-----"
$TC -s qdisc ls dev $IFACE

# Print speeds after if in debug mode
if [[ $# -ge 1 ]]; then
    echo "Speeds after:"
    speedtest-cli --simple
fi
