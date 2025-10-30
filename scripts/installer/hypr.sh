#!/bin/bash

# Get the directory of the current script
BASE_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")/../../")

# Source helper file
source $BASE_DIR/scripts/installer/helper.sh

log_message "Installation started for hypr section"
print_info "\nStarting hypr setup..."
print_info "\nEverything is recommended to INSTALL"
echo "------------------------------------------------------------------------"

# Copy in my Hyprland config file.
run_command "mkdir -p /home/$SUDO_USER/.config/hypr/ && cp -r $BASE_DIR/configs/hypr/hyprland.conf /home/$SUDO_USER/.config/hypr/" "Copy hyprland config" "yes" "no" 

# Switching from default polkit, polkit-kde-agent, and polkit-qt6-agent to hyprpolkitagent for wayland compatibility.
run_command "pacman -S --noconfirm hyprpolkitagent" "Install Hypr Polkit Agent for authentication dialogs" "yes"

# Switching from default notification dunst daemon to Mako for wayland compatibility.
run_command "pacman -S --noconfirm mako" "Install Mako notification daemon" "yes"
run_command "cp -r $BASE_DIR/configs/mako /home/$SUDO_USER/.config/" "Copy mako config" "yes" "no"

run_command "pacman -S --noconfirm qt5-wayland qt6-wayland" "Install QT support on wayland" "yes"

echo "------------------------------------------------------------------------"