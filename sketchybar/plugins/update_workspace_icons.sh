#!/bin/bash

CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"

update_workspace_appearance() {
  local sid=$1
  local is_focused=$2

  if [ "$is_focused" = "true" ]; then
    sketchybar --set space.$sid background.drawing=on \
      background.color=$ACCENT_COLOR \
      label.color=$ITEM_COLOR \
      icon.color=$ITEM_COLOR
  else
    sketchybar --set space.$sid background.drawing=off \
      label.color=$ACCENT_COLOR \
      icon.color=$ACCENT_COLOR
  fi
}

update_icons() {
  local sid=$1

  apps=$(aerospace list-windows --workspace "$sid" 2>/dev/null \
    | awk -F '|' '{gsub(/^ *| *$/, "", $2); if (!seen[$2]++) print $2}' \
    | sort)

  icon_strip=""
  if [ -n "$apps" ]; then
    while read -r app; do
      [ -n "$app" ] && icon_strip+=" $($CONFIG_DIR/plugins/icons.sh "$app")"
    done <<< "$apps"
  else
    icon_strip=" —"
  fi

  sketchybar --animate sin 10 --set space.$sid label="$icon_strip"
}

# Update appearance for previous and focused workspaces
if [ -n "$PREV_WORKSPACE" ]; then
  update_workspace_appearance "$PREV_WORKSPACE" "false"
  update_icons "$PREV_WORKSPACE"
fi

if [ -n "$FOCUSED_WORKSPACE" ]; then
  update_workspace_appearance "$FOCUSED_WORKSPACE" "true"
  update_icons "$FOCUSED_WORKSPACE"
fi
