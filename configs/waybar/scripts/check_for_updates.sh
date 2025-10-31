#!/bin/bash

# Function to check for pacman updates
check_pacman_updates() {
    pacman -Qu | wc -l
}

# Function to check for yay (AUR) updates
check_yay_updates() {
    yay -Qu | wc -l
}

# Function to check for flatpak updates
check_flatpak_updates() {
    flatpak update --show-details | grep -i "update" | wc -l
}

# Get the update counts
pacman_updates=$(check_pacman_updates)
yay_updates=$(check_yay_updates)
flatpak_updates=$(check_flatpak_updates)

# Combine the results and return the total
total_updates=$((pacman_updates + yay_updates + flatpak_updates))

# Determine the icon and tooltip based on the total updates
if [ $total_updates -gt 0 ]; then
    # If updates are available
    icon=""  # Refresh icon (from FontAwesome or Nerd Fonts)
    tooltip="$total_updates Updates available"
else
    # If no updates are available
    icon=""  # Checkmark icon (from FontAwesome or Nerd Fonts)
    tooltip="You're up to date"
fi

# Output in JSON format for Waybar
echo "{\"text\": \"$icon\", \"tooltip\": \"$tooltip\"}"
