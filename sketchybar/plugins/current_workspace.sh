#!/bin/bash

# Get current focused workspace index from AeroSpace
CURRENT_WS=$(aerospace query-workspaces | jq '.[] | select(.focused==true).index')

# Display 1 and 2 with formatting
for i in 1 2; do
  if [ "$i" -eq "$CURRENT_WS" ]; then
    echo -n "[ $i ] "
  else
    echo -n "$i "
  fi
done

echo ""
