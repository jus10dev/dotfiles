#!/bin/bash

INTERFACE="en0"
IP=$(ipconfig getifaddr "$INTERFACE")

if [[ -z "$IP" ]]; then
  LABEL="Not Connected"
  ICON="󰤭"  # Disconnected Wi-Fi icon
else
  LABEL="Connected"
  ICON="󰤨"  # Full signal icon (we can't read RSSI on your system)
fi

sketchybar -m --set wifi label="$LABEL" icon="$ICON"