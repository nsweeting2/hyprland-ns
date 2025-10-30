#!/bin/bash

# Get the directory of the current script
BASE_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")/../../")

# Source helper file
source $BASE_DIR/scripts/installer/helper.sh

log_message "Installation started for utilities section"
print_info "\nStarting utilities setup..."
echo "------------------------------------------------------------------------"

# Install Waybar - Status Bar and copy config
run_command "pacman -S --noconfirm waybar" "Install Waybar - Status Bar" "yes"
run_command "cp -r $BASE_DIR/configs/waybar /home/$SUDO_USER/.config/" "Copy Waybar config" "yes"

# Install Rofi - Application Launcher and copy config
run_command "yay -S --sudoloop --noconfirm tofi" "Install Tofi - Application Launcher" "yes" "no"
run_command "cp -r $BASE_DIR/configs/tofi /home/$SUDO_USER/.config/" "Copy Tofi config(s)" "yes"

# run_command "pacman -S --noconfirm cliphist" "Install Cliphist - Clipboard Manager" "yes"

# run_command "yay -S --sudoloop --noconfirm grimblast" "Install Grimblast - Screenshot tool" "yes" "no"

# Install Hyprpicker - Color Picker
run_command "yay -S --sudoloop --noconfirm hyprpicker" "Install Hyprpicker - Color Picker" "yes" "no"

# install Hyprpaper - Wallpaper Management
run_command "pacman -S --noconfirm hyprpaper" "Install Hyprpaper - Wallpaper Management" "yes"
run_command "mkdir -p /home/$SUDO_USER/.config/assets/backgrounds && cp -r $BASE_DIR/assets/backgrounds /home/$SUDO_USER/.config/assets/" "Copy default backgrounds to assets directory" "yes" "no"

# Install Hyprlock - Screen Locker
run_command "yay -S --sudoloop --noconfirm hyprlock" "Install Hyprlock - Screen Locker" "yes" "no"
run_command "cp -r $BASE_DIR/configs/hypr/hyprlock.conf /home/$SUDO_USER/.config/hypr/" "Copy Hyprlock config" "yes" 

# Install Wlogout - Session Manager
run_command "yay -S --sudoloop --noconfirm wlogout" "Install Wlogout - Session Manager" "yes" "no"
run_command "cp -r $BASE_DIR/configs/wlogout /home/$SUDO_USER/.config/ && cp -r $BASE_DIR/assets/wlogout /home/$SUDO_USER/.config/assets/" "Copy Wlogout config and assets" "yes" "no"

# Install Hypridle - Idle Management
run_command "yay -S --sudoloop --noconfirm hypridle" "Install Hypridle for idle management" "yes" "no"
run_command "cp -r $BASE_DIR/configs/hypr/hypridle.conf /home/$SUDO_USER/.config/hypr/" "Copy Hypridle config" "yes"

# Install PCManFM - File Manager
run_command "yay -S --sudoloop --noconfirm pcmanfm-gtk3" "Install PCManFM - File Manager" "yes" "no"

echo "------------------------------------------------------------------------"