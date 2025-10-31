#!/bin/bash

# Check if Waybar is running
if pgrep -x "waybar" > /dev/null; then
    # If running, kill both Waybars
    killall waybar
else
    # If not running, start both Waybars
    waybar -c ~/.config/waybar/config_dual_1.jsonc &
    waybar -c ~/.config/waybar/config_dual_2.jsonc &
fi
