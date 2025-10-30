#!/bin/bash

# Original author: gaurav23b
# Modified By: nsweeting2 for nsweeting2
# Modified to run non interactivly after and archinstall
# Refactored to make it setup a system as I see fit

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
source $BASE_DIR/scripts/helper.sh

# Trap for unexpected exits
trap 'trap_message' INT TERM

# Script start
log_message "Installation started"
print_bold_blue "\nSimple Hyprland - nsweeting2 Edition Installer\n"
echo "------------------------------------------------------------------------"

# Run child scripts
run_script "pre.sh" "Pre Setup"
run_script "setup.sh" "Hyprland & Critical Softwares Setup"
run_script "configure.sh" "Basic Utilities & Configs Setup"
run_script "theme.sh" "Themes and Tools Setup"
run_script "final.sh" "Final Setup"

log_message "Installation completed successfully"
print_bold_blue "\n🌟 Setup Complete\n"
echo "------------------------------------------------------------------------"
