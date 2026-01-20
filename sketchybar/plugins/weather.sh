#!/bin/bash

# Show a placeholder first
sketchybar -m --set weather label="..." icon="⛅️"

# Get coordinates from IP geolocation
LOCATION=$(curl -s "http://ip-api.com/json/")
LAT=$(echo "$LOCATION" | grep -o '"lat":[0-9.]*' | cut -d':' -f2)
LON=$(echo "$LOCATION" | grep -o '"lon":-*[0-9.]*' | cut -d':' -f2)

# Fallback to LA coordinates
[ -z "$LAT" ] && LAT="34.05"
[ -z "$LON" ] && LON="-118.24"

# Fetch weather from Open-Meteo (free, no rate limits)
WEATHER=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=${LAT}&longitude=${LON}&current=temperature_2m,weather_code&temperature_unit=fahrenheit")

TEMP=$(echo "$WEATHER" | grep -o '"temperature_2m":[0-9.]*' | tail -1 | cut -d':' -f2 | cut -d'.' -f1)
CODE=$(echo "$WEATHER" | grep -o '"weather_code":[0-9]*' | tail -1 | cut -d':' -f2)

# Fallback
[ -z "$TEMP" ] && TEMP="--"

# Map WMO weather code to emoji
# 0=clear, 1-3=partly cloudy, 45-48=fog, 51-67=rain, 71-77=snow, 80-82=showers, 95-99=thunderstorm
case "$CODE" in
  0)                    ICON="☀️" ;;
  1|2|3)                ICON="⛅️" ;;
  45|48)                ICON="🌫️" ;;
  51|53|55|61|63|65|80|81|82) ICON="🌧️" ;;
  71|73|75|77)          ICON="❄️" ;;
  95|96|99)             ICON="⛈️" ;;
  *)                    ICON="🌤️" ;;
esac

# Update the bar
sketchybar -m --set weather label="${TEMP}°F" icon="$ICON"