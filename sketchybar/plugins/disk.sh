#!/bin/bash

# Get APFS container usage percentage (matches System Preferences)
PERCENTAGE=$(diskutil apfs list | grep "Capacity In Use" | head -1 | grep -oE '[0-9]+\.[0-9]+%' | cut -d'.' -f1)

sketchybar -m --set disk label="${PERCENTAGE}%" icon="💾"
