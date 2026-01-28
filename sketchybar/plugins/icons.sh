#!/bin/bash

# Map app names to nerd font icons (UTF-8 hex bytes)
app_name="$1"

case "$app_name" in
  "Google Chrome"|"Chrome")
    printf '\xef\x89\xa8'  # U+F268 Chrome
    ;;
  "Ghostty"|"Terminal"|"iTerm2")
    printf '\xef\x84\xa0'  # U+F120 Terminal
    ;;
  "WebStorm")
    printf '\xee\x9e\xb8'  # U+E7B8 WebStorm
    ;;
  "ChatGPT")
    printf '\xef\x95\x84'  # U+F544 Robot
    ;;
  "Finder")
    printf '\xef\x81\xbc'  # U+F07C Folder
    ;;
  "Safari")
    printf '\xef\x89\xa7'  # U+F267 Safari
    ;;
  "Code"|"Visual Studio Code")
    printf '\xee\x9c\x8c'  # U+E70C VS Code
    ;;
  "Messages")
    printf '\xef\x81\xb5'  # U+F075 Comment
    ;;
  "Mail")
    printf '\xef\x83\xa0'  # U+F0E0 Envelope
    ;;
  "Notes")
    printf '\xef\x89\x89'  # U+F249 Sticky note
    ;;
  "Preview")
    printf '\xef\x87\x85'  # U+F1C5 Image
    ;;
  "System Preferences"|"System Settings")
    printf '\xef\x80\x93'  # U+F013 Gear
    ;;
  "Slack")
    printf '\xef\x86\x98'  # U+F198 Slack
    ;;
  "Discord")
    printf '\xef\x8e\x92'  # U+F392 Discord
    ;;
  "Spotify")
    printf '\xef\x86\xbc'  # U+F1BC Spotify
    ;;
  *)
    printf '\xef\x83\x88'  # U+F0C8 Square
    ;;
esac
