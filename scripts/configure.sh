#!/bin/bash

# Get the directory of the current script
BASE_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")/../../")

# Source helper file
source $BASE_DIR/scripts/helper.sh

log_message "Installation started for utilities section"
print_info "\nStarting utilities setup..."
echo "------------------------------------------------------------------------"

# Copy in config files

# Kitty

# Ghostty

# Hyprland
run_command "mkdir -p /home/$SUDO_USER/.config/hypr/ && cp -r $BASE_DIR/configs/hypr/hyprland.conf /home/$SUDO_USER/.config/hypr/" "Copy hyprland config" "yes" "no" 

# Mako
run_command "cp -r $BASE_DIR/configs/mako /home/$SUDO_USER/.config/" "Copy mako config" "yes" "no"

# Waybar
run_command "cp -r $BASE_DIR/configs/waybar /home/$SUDO_USER/.config/" "Copy Waybar config" "yes"

# Tofi
run_command "cp -r $BASE_DIR/configs/tofi /home/$SUDO_USER/.config/" "Copy Tofi config(s)" "yes"

# wLogout
run_command "cp -r $BASE_DIR/configs/hypr/hyprlock.conf /home/$SUDO_USER/.config/hypr/" "Copy Hyprlock config" "yes" 

# Hyprlock
run_command "cp -r $BASE_DIR/configs/wlogout /home/$SUDO_USER/.config/ && cp -r $BASE_DIR/assets/wlogout /home/$SUDO_USER/.config/assets/" "Copy Wlogout config and assets" "yes" "no"

# Hypridle
run_command "cp -r $BASE_DIR/configs/hypr/hypridle.conf /home/$SUDO_USER/.config/hypr/" "Copy Hypridle config" "yes"

#Copy over files and assets

# Wallpaper Images
run_command "mkdir -p /home/$SUDO_USER/.config/assets/backgrounds && cp -r $BASE_DIR/assets/backgrounds /home/$SUDO_USER/.config/assets/" "Copy default backgrounds to assets directory" "yes" "no"

echo "------------------------------------------------------------------------"