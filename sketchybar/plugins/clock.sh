#!/bin/bash

DATE=$(date "+%a %d %b")
TIME=$(date "+%H:%M")
sketchybar -m --set clock label="$DATE $TIME" icon=""
