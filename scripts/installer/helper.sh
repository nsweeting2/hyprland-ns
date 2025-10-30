#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Get the directory of the current script
BASE_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")/../../")

# Log file
LOG_FILE="$BASE_DIR/scripts/installer/simple_hyprland_install.log"

# AUTO_MODE can be set by the top-level installer (install.sh) using --auto.
# Default to "no" when not set.
AUTO_MODE="${AUTO_MODE:-no}"

function trap_message {
    print_error "\n\nScript interrupted. Exiting.....\n"
    # Add any cleanup code here
    log_message "Script interrupted and exited"
    exit 1
}

# Function to log messages
function log_message {
    echo "$(date): $1" >> "$LOG_FILE"
}

# Functions for colored/bold output
function print_error {
    echo -e "${RED}$1${NC}"
}

function print_success {
    echo -e "${GREEN}$1${NC}"
}

function print_warning {
    echo -e "${YELLOW}$1${NC}"
}

function print_info {
    echo -e "${BLUE}$1${NC}"
}

function print_bold_blue {
    echo -e "${NC}${BOLD}$1${NC}"
}

# Function to ask for confirmation
function ask_confirmation {
    # If AUTO_MODE is enabled, automatically accept prompts.
    if [[ "${AUTO_MODE,,}" == "yes" ]]; then
        log_message "Auto mode: automatically accepting prompt: $1"
        return 0
    fi

    while true; do
        read -p "$(print_warning "$1 (y/n): ")" -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log_message "Operation accepted by user."
            return 0  # User confirmed
            elif [[ $REPLY =~ ^[Nn]$ ]]; then
            log_message "Operation cancelled by user."
            print_error "Operation cancelled."
            return 1  # User cancelled
        else
            print_error "Invalid input. Please answer y or n."
        fi
    done
}

# Function to run a command with optional confirmation and retry
function run_command {
    local cmd="$1"
    local description="$2"
    local ask_confirm="${3:-yes}"  # Default to asking for confirmation
    local use_sudo="${4:-yes}"     # Default to using sudo

    # If AUTO_MODE is enabled, do not prompt for confirmation and do not enter
    # interactive retry loops that expect user input. Force non-interactive
    # behavior by treating ask_confirm as "no".
    if [[ "${AUTO_MODE,,}" == "yes" ]]; then
        ask_confirm="no"
    fi

    # If this looks like an AUR helper invocation (yay, paru, etc.) and we're
    # in AUTO_MODE, run it as the original user with a temporary sudoers
    # entry that allows pacman/makepkg (and yay) without a password. This
    # avoids interactive sudo password prompts from AUR helpers.
    if [[ "${AUTO_MODE,,}" == "yes" ]] && ([[ "$cmd" == *"yay"* || "$cmd" == *"paru"* ]]); then
        # Use the helper to run the command as the user with temporary NOPASSWD
        log_message "Auto mode: running AUR helper command via temporary NOPASSWD sudoers: $cmd"
        run_with_temp_nopass_as_user "$cmd"
        return $?
    fi

    local full_cmd=""
    if [[ "$use_sudo" == "no" ]]; then
        full_cmd="sudo -u $SUDO_USER $cmd"
    else
        full_cmd="$cmd"
    fi
    
    log_message "Attempting to run: $description"
    print_info "\nCommand: $full_cmd"
    if [[ "$ask_confirm" == "yes" ]]; then
        if ! ask_confirmation "$description"; then
            # print_info "$description was skipped."
            log_message "$description was skipped by user choice."
            return 1
        fi
    else
        print_info "\n$description"  # Echo what it's doing without confirmation
    fi
    
    while ! eval "$full_cmd"; do
        print_error "Command failed."
        log_message "Command failed: $cmd"
        if [[ "$ask_confirm" == "yes" ]]; then
            if ! ask_confirmation "Retry $description?"; then
                print_warning "$description was not completed."
                log_message "$description was not completed due to failure and user chose not to retry."
                return 1
            fi
        else
            print_warning "$description failed and will not be retried."
            log_message "$description failed and was not retried (auto mode)."
            return 1
        fi
    done
    
    print_success "$description completed successfully."
    log_message "$description completed successfully."
    return 0
}


# Create a temporary sudoers file allowing the installer user to run the
# minimal commands needed for AUR builds without being prompted for a
# password. The file is validated with visudo before being left in place.
function enable_nopass_sudo_for_installer {
    local u="${SUDO_USER:-$(logname)}"
    local f="/etc/sudoers.d/simple-hyprland"
    if [[ -z "$u" ]]; then
        log_message "enable_nopass_sudo_for_installer: SUDO_USER not set"
        return 1
    fi

    # Limit commands to known package tools
    printf "%s ALL=(ALL) NOPASSWD: /usr/bin/pacman, /usr/bin/makepkg, /usr/bin/yay\n" "$u" > "$f"
    chmod 440 "$f"
    if ! visudo -cf "$f" >/dev/null 2>&1; then
        print_error "Failed to validate temporary sudoers file. Aborting."
        rm -f "$f"
        log_message "Failed to create sudoers file $f"
        return 1
    fi
    log_message "Temporary sudoers file created at $f for user $u"
    return 0
}

function disable_nopass_sudo_for_installer {
    local f="/etc/sudoers.d/simple-hyprland"
    if [[ -f "$f" ]]; then
        rm -f "$f"
        log_message "Temporary sudoers file $f removed"
    fi
    return 0
}

# Run a command as the original (non-root) user while temporarily enabling
# NOPASSWD sudo for pacman/makepkg/yay. This is intended for non-interactive
# installer AUR steps.
function run_with_temp_nopass_as_user {
    local cmd="$*"
    if ! enable_nopass_sudo_for_installer; then
        print_error "Could not enable temporary sudoers; aborting AUR command."
        return 1
    fi

    # Run the command as the original user
    sudo -u "${SUDO_USER:-$(logname)}" bash -c "$cmd"
    local rc=$?

    # Remove sudoers entry immediately
    disable_nopass_sudo_for_installer
    return $rc
}

# Function to run a script with retry and confirmation
function run_script {
    local script="$BASE_DIR/scripts/installer/$1"
    local description="$2"
    # In AUTO_MODE, run once without prompting and do not retry interactively.
    if [[ "${AUTO_MODE,,}" == "yes" ]]; then
        log_message "Auto mode: executing script $script without prompts"
        if bash "$script"; then
            print_success "\n$description completed successfully."
            return 0
        else
            print_error "$description script failed (auto mode)."
            log_message "$description failed in auto mode"
            return 1
        fi
    fi

    if ask_confirmation "\nExecute '$description' script"; then
        while ! bash "$script"; do
            print_error "$description script failed."
            if ! ask_confirmation "Retry $description"; then
                return 1  # User chose not to retry
            fi
        done
        print_success "\n$description completed successfully."
    else
        return 1  # User chose not to run the script
    fi
}

function check_root {
    if [ "$EUID" -ne 0 ]; then
        print_error "Please run as root"
        log_message "Script not run as root. Exiting."
        exit 1
    fi
    
    # Store the original user for later use
    SUDO_USER=$(logname)
    log_message "Original user is $SUDO_USER"
}

function check_os {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ "$ID" != "arch" ]]; then
            print_warning "This script is designed for Arch Linux. Your system: $PRETTY_NAME"
            if ! ask_confirmation "Continue anyway?"; then
                log_message "Installation cancelled due to unsupported OS"
                exit 1
            fi
        else
            print_success "Arch Linux detected. Proceeding with installation."
            log_message "Arch Linux detected. Installation proceeding."
        fi
    else
        print_error "Unable to determine OS. /etc/os-release not found."
        if ! ask_confirmation "Continue anyway?"; then
            log_message "Installation cancelled due to unknown OS"
            exit 1
        fi
    fi
}