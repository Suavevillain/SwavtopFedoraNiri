#!/usr/bin/env bash

choice=$(printf "Logout\nReboot\nPower Off" | fuzzel --dmenu --prompt="Power")

case "$choice" in
  Logout)
    niri msg action quit
    ;;
  Reboot)
    systemctl reboot
    ;;
  "Power Off")
    systemctl poweroff
    ;;
esac
