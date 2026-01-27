#!/bin/bash

# Show a placeholder first
sketchybar -m --set weather label="..." icon="⛅️"

# Clear location cache on wake to get fresh city
if [[ "$SENDER" == "system_woke" ]]; then
  rm -f "$HOME/.cache/sketchybar/location"
fi

# Location cache (refreshes every 30 minutes)
CACHE_DIR="$HOME/.cache/sketchybar"
CACHE_FILE="$CACHE_DIR/location"
CACHE_MAX_AGE=1800  # 30 minutes in seconds

mkdir -p "$CACHE_DIR"

# Check if cache exists and is fresh
if [[ -f "$CACHE_FILE" ]]; then
  CACHE_AGE=$(($(date +%s) - $(stat -f %m "$CACHE_FILE")))
  if [[ $CACHE_AGE -lt $CACHE_MAX_AGE ]]; then
    source "$CACHE_FILE"
  fi
fi

# Fetch new location if not cached
if [[ -z "$LAT" || -z "$LON" ]]; then
  LOCATION=$(curl -s "http://ip-api.com/json/")
  LAT=$(echo "$LOCATION" | grep -o '"lat":[0-9.]*' | cut -d':' -f2)
  LON=$(echo "$LOCATION" | grep -o '"lon":-*[0-9.]*' | cut -d':' -f2)
  CITY=$(echo "$LOCATION" | grep -o '"city":"[^"]*"' | cut -d'"' -f4)

  # Save to cache if we got valid coordinates
  if [[ -n "$LAT" && -n "$LON" ]]; then
    echo "LAT=$LAT" > "$CACHE_FILE"
    echo "LON=$LON" >> "$CACHE_FILE"
    echo "CITY=\"$CITY\"" >> "$CACHE_FILE"
  fi
fi

# Fallback to LA
[ -z "$LAT" ] && LAT="34.05"
[ -z "$LON" ] && LON="-118.24"
[ -z "$CITY" ] && CITY="Los Angeles"

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
sketchybar -m --set weather label="${CITY} ${TEMP}°F" icon="$ICON"