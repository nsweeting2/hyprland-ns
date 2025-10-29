#!/bin/bash

# Get the directory of the current script
BASE_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")/../../")

# Source helper file
source $BASE_DIR/scripts/installer/helper.sh

log_message "Installation started for prerequisites section"
print_info "\nStarting prerequisites setup..."
echo "------------------------------------------------------------------------"

run_command "pacman -Syyu --noconfirm" "Update package database and upgrade packages" "yes" # no

if command -v yay > /dev/null; then
    print_info "Skipping yay installation (already installed)."
elif run_command "pacman -S --noconfirm --needed git base-devel" "Install YAY (Must)/Breaks the script" "yes"; then # 
    run_command "git clone https://aur.archlinux.org/yay.git && cd yay" "Clone YAY (Must)/Breaks the script" "no" "no" 
    run_command "makepkg --noconfirm -si && cd .. # builds with makepkg" "Build YAY (Must)/Breaks the script" "no" "no" 
fi

run_command "pacman -S --noconfirm iwd" "Install and IWD with Impala for Wi-Fi networking" "yes"

run_command "pacman -S --noconfirm bluez bluez-utils" "Install BlueZ with BlueTUI for Bluetooth support" "yes"

run_command "pacman -S --noconfirm pipewire wireplumber" "Install Pipewire, Wireplumber, and PulseAudio for audio functionality" "yes"

run_command "yay -S --sudoloop --noconfirm jvol-git" "Install Jvol for audio controls" "yes" "no"

#I want a TUI or sorts for brightness control....
run_command "pacman -S --noconfirm brightnessctl" "Install brightnessctl for backlight control" "yes"

run_command "pacman -S --noconfirm ttf-cascadia-code-nerd ttf-cascadia-mono-nerd ttf-fira-code ttf-fira-mono ttf-fira-sans ttf-firacode-nerd ttf-iosevka-nerd ttf-iosevkaterm-nerd ttf-jetbrains-mono-nerd ttf-jetbrains-mono ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono" "Installing Nerd Fonts and Symbols (Recommended)" "yes" 

#run_command "pacman -S --noconfirm sddm && systemctl enable sddm.service" "Install and enable SDDM" "yes"

run_command "yay -S --sudoloop --noconfirm brave-bin" "Install Brave Browser" "yes" "no"

run_command "pacman -S --noconfirm kitty ghostty" "Install Kitty & Ghostty - Terminal Emulators" "yes"

run_command "pacman -S --noconfirm nano" "Install Nano and Neovim - Text Editors" "yes"

run_command "pacman -S --noconfirm tar 7zip" "Install tar and 7zip for extracting files" "yes"

echo "------------------------------------------------------------------------"