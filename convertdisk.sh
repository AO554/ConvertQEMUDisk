#!/usr/bin/env bash

# Check if qemu-img is installed
if ! type qemu-img &>/dev/null; then echo "Error: qemu-img is not installed or not in PATH. Exiting."; exit 1; fi

# Converts a Hyper-V Disk using qemu-img (assuming its installed)
converter() {
	unset orig_path new_path_file
	echo -e "\nHyper-V to QCOW2 Conversion\n"
	until [[ -e "$orig_path" ]]; do
		read -rep "Enter the Path to the vhd/vhdx file: " orig_path
		[[ "$orig_path" == '~'* ]] && orig_path="$HOME${orig_path/\~/}"
		[[ ! -e "$orig_path" ]] && echo "File does not exist."
	done
	read -rep "Please enter a new path + the name and extension: " new_path_file
	[[ "$new_path_file" == '~'* ]] && new_path_file="$HOME${new_path_file/\~/}"
	[[ ! -e "$(dirname $new_path_file)" ]] && mkdir -p "$(dirname $new_path_file)"
	echo -e "Thanks! Conversion will start shortly.\n"
	qemu-img convert -O qcow2 "$orig_path" "$new_path_file"
	echo "Conversion Complete! Please check that your file is there :]"
	echo 'Press any key to go back to main menu...'
	read -rn1
}

while true; do
	unset main_option
	clear
	echo -e "\nHarri's Simplified Disk Converter\nFor QEMU Related tasks\n"
	echo -e "\nWhat would you like to do?\n"
	echo "(1) Convert Hyper-V to QCOW2"
	echo -e "(2) Quit\n"

	until [[ "$main_option" = "1" ]] || [[ "$main_option" = "2" ]]; do
		read -rep "Choice: " main_option
	done

	case "$main_option" in
		1) converter;;
		2) echo -e "\nGoodbye!\nReturning to shell.\n"; exit 0;;
	esac
done
