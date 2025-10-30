#!/bin/bash

# Original author: gaurav23b
# Modified By: nsweeting2 for nsweeting2
# Modified to run non interactivly after and archinstall. 

# Get the directory of the current script
BASE_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")/../../")

# Parse arguments: installer runs non-interactively by default (AUTO_MODE=yes).
# Pass --manual to enable interactive/manual prompts. Keep --auto for
# backward-compatibility to explicitly request non-interactive mode.
AUTO_MODE="yes"
while [[ $# -gt 0 ]]; do
	case "$1" in
		--manual)
			AUTO_MODE="no"
			shift
			;;
		--auto)
			AUTO_MODE="yes"
			shift
			;;
		*)
			# Unknown option - pass through or ignore
			shift
			;;
	esac
done

# Export AUTO_MODE so sourced helper functions can read it
export AUTO_MODE

# Source helper file
source $BASE_DIR/scripts/installer/helper.sh

# Trap for unexpected exits
trap 'trap_message' INT TERM

# Script start
log_message "Installation started"
print_bold_blue "\nSimple Hyprland - nsweeting2 Edition Installer\n"
echo "------------------------------------------------------------------------"

# Check if running as root
check_root

# Check if OS is Arch Linux
check_os

# Check if we are configured as we expect from archinstall.
check_archinstall

# Run child scripts
run_script "prerequisites.sh" "Prerequisites Setup"
run_script "hypr.sh" "Hyprland & Critical Softwares Setup"
run_script "utilities.sh" "Basic Utilities & Configs Setup"
run_script "theming.sh" "Themes and Tools Setup"
run_script "final.sh" "Final Setup"

log_message "Installation completed successfully"
print_bold_blue "\n🌟 Setup Complete\n"
echo "------------------------------------------------------------------------"
