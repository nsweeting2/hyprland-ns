#!/bin/bash

# Get the directory of the current script
BASE_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")/../")

# Source helper file
source $BASE_DIR/scripts/helper.sh

log_message "Installation started for prerequisites section"
print_info "\Working on prerequisites..."
echo "------------------------------------------------------------------------"

# Check if running as root
check_root # in helper.sh

# Check if OS is Arch Linux
check_os # in helper.sh

# Confirm system is up to date before proceeding.
run_command "pacman -Syyu --noconfirm" "Update package database and upgrade packages" "yes" # no

# Confirm we have the system configured as we expect from archinstall.
check_archinstall # in helper.sh

# Remove the extra archinstall packages I don't want.
run_command "pacman -Rs --noconfirm polkit" "Remove polkit, we will use hyprpolkit" "yes"
run_command "pacman -Rs --noconfirm dunst" "Remove dunst, we will use mako" "yes"
run_command "pacman -Rs --noconfirm dolphin" "Remove dolphin, we will use pcmanfm-gtk3" "yes"

# Install Yay if it is not already installed.
if command -v yay > /dev/null; then
    print_info "Skipping yay installation (already installed)."
elif run_command "pacman -S --noconfirm --needed git base-devel" "Install YAY (Must)/Breaks the script" "yes"; then # 
    run_command "git clone https://aur.archlinux.org/yay.git && cd yay" "Clone YAY (Must)/Breaks the script" "no" "no" 
    run_command "makepkg --noconfirm -si && cd .. # builds with makepkg" "Build YAY (Must)/Breaks the script" "no" "no" 
fi

# Install Flatpak and configure Flathub repo.
run_command "pacman -S --noconfirm flatpak" "Install Flatpak runtime" "yes"
run_command "flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo" "Add Flathub remote repository" "yes" "no"

# Need to be able to extract tar files.
run_command "pacman -S --noconfirm tar" "Install tar for extracting files" "yes"

echo "------------------------------------------------------------------------"