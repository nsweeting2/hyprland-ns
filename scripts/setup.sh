#!/bin/bash

# Get the directory of the current script
BASE_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")/../")

# Source helper file
source $BASE_DIR/scripts/helper.sh

log_message "Installation started for hypr section"
print_info "\nStarting hypr setup..."
print_info "\nEverything is recommended to INSTALL"
echo "------------------------------------------------------------------------"

# Use Pacman and Yay to install software.

# Ghostty and Kitty Terminal Emulators (Ghostty is my default in hyprland.conf)
run_command "pacman -S --noconfirm kitty ghostty" "Install Kitty & Ghostty - Terminal Emulators" "yes"

# Yazi - File Manager (Yazi is my default in hyprland.conf)
run_command "pacman -S --noconfirm yazi-bin" "Install Yazi - Terminal File Manager" "yes"

# Brave Browser (Brace is my default in hyprland.conf)
run_command "yay -S --sudoloop --noconfirm brave-bin" "Install Brave Browser" "yes" "no"

# Firefox Browser
run_command "pacman -S --noconfirm firefox" "Install Firefox Browser" "yes"

# Obsidian Notes
run_command "pacman -S --noconfirm obsidian" "Install Obsidian Notes" "yes"

# Hyprpicker - Color Picker
run_command "yay -S --sudoloop --noconfirm hyprpicker" "Install Hyprpicker - Color Picker" "yes" "no"

# All the Nerd Fonts and Symbols.
run_command "pacman -S --noconfirm ttf-cascadia-code-nerd ttf-cascadia-mono-nerd ttf-fira-code ttf-fira-mono ttf-fira-sans ttf-firacode-nerd ttf-iosevka-nerd ttf-iosevkaterm-nerd ttf-jetbrains-mono-nerd ttf-jetbrains-mono ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono" "Installing Nerd Fonts and Symbols (Recommended)" "yes" 

# Impala - Wifi TUI
run_command "pacman -S --noconfirm impala" "Install Impala for Wi-Fi networking" "yes"

# I may write a Ethernet Control TUI...
#run_command "pacman -S --noconfirm impala" "Install Impala for Wi-Fi networking" "yes"

# Bluetui - Bluetooth TUI
run_command "pacman -S --noconfirm bluetui" "Install BlueTUI for Bluetooth controls" "yes"

# Jvol - Audio TUI
run_command "yay -S --sudoloop --noconfirm jvol-git" "Install Jvol for audio controls" "yes" "no"

#I want a TUI or sorts for brightness control....
run_command "pacman -S --noconfirm brightnessctl" "Install brightnessctl for backlight control" "yes"

#I want a TUI or sorts for system font control...

# Hyprpolkit Agent
run_command "pacman -S --noconfirm hyprpolkitagent" "Install Hypr Polkit Agent for authentication dialogs" "yes"

# Mako Notification Daemon
run_command "pacman -S --noconfirm mako" "Install Mako notification daemon" "yes"

# QT support on Wayland
run_command "pacman -S --noconfirm qt5-wayland qt6-wayland" "Install QT support on wayland" "yes"

# Waybar - Status Bar
run_command "pacman -S --noconfirm waybar" "Install Waybar - Status Bar" "yes"

# Hyprpaper - Wallpaper Management
run_command "pacman -S --noconfirm hyprpaper" "Install Hyprpaper - Wallpaper Management" "yes"

# Hyprlock - Screen Locker
run_command "yay -S --sudoloop --noconfirm hyprlock" "Install Hyprlock - Screen Locker" "yes" "no"

# Wlogout - Session Manager
run_command "yay -S --sudoloop --noconfirm wlogout" "Install Wlogout - Session Manager" "yes" "no"

# Hypridle - Idle Management
run_command "yay -S --sudoloop --noconfirm hypridle" "Install Hypridle for idle management" "yes" "no"

echo "------------------------------------------------------------------------"