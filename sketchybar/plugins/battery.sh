#!/bin/bash

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
sketchybar -m --set battery label="${PERCENTAGE}%" icon=""
