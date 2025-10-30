#!/bin/bash

# Get the directory of the current script
BASE_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")/../../")

# Source helper file
source $BASE_DIR/scripts/installer/helper.sh

log_message "Installation started for prerequisites section"
print_info "\nStarting prerequisites setup..."
echo "------------------------------------------------------------------------"

# Confirm system is up to date before proceeding.
run_command "pacman -Syyu --noconfirm" "Update package database and upgrade packages" "yes" # no

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

# My Chosen Wifi Control TUI
run_command "pacman -S --noconfirm impala" "Install Impala for Wi-Fi networking" "yes"

# My Chosen Bluetooth Control TUI
run_command "pacman -S --noconfirm bluetui" "Install BlueTUI for Bluetooth controls" "yes"

# My Chosen Audio Control TUI
run_command "yay -S --sudoloop --noconfirm jvol-git" "Install Jvol for audio controls" "yes" "no"

#I want a TUI or sorts for brightness control....
run_command "pacman -S --noconfirm brightnessctl" "Install brightnessctl for backlight control" "yes"

#I want a TUI or sorts for system font control...

# Install All the Nerd Fonts and Symbols I like.
run_command "pacman -S --noconfirm ttf-cascadia-code-nerd ttf-cascadia-mono-nerd ttf-fira-code ttf-fira-mono ttf-fira-sans ttf-firacode-nerd ttf-iosevka-nerd ttf-iosevkaterm-nerd ttf-jetbrains-mono-nerd ttf-jetbrains-mono ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono" "Installing Nerd Fonts and Symbols (Recommended)" "yes" 

# My Chosen Web Browser
run_command "yay -S --sudoloop --noconfirm brave-bin" "Install Brave Browser" "yes" "no"

# My Chosen Backup Browser
run_command "pacman -S --noconfirm firefox" "Install Firefox Browser" "yes"

# My Chosen Terminal Emulators
run_command "pacman -S --noconfirm kitty ghostty" "Install Kitty & Ghostty - Terminal Emulators" "yes"

# Need to be able to extract tar files.
run_command "pacman -S --noconfirm tar" "Install tar for extracting files" "yes"

echo "------------------------------------------------------------------------"