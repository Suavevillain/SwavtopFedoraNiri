#!/usr/bin/env bash

choice=$(
printf "󰍃 Lock\n󰐥 Logout\n󰜉 Reboot\n󰐥 Shutdown\n󰌾 Suspend" |
fuzzel --dmenu -p "Power"
)

case "$choice" in
    "󰍃 Lock")
        hyprlock
        ;;
    "󰐥 Logout")
        niri msg action quit
        ;;
    "󰜉 Reboot")
        systemctl reboot
        ;;
    "󰐥 Shutdown")
        systemctl poweroff
        ;;
    "󰌾 Suspend")
        systemctl suspend
        ;;
esac
