#!/usr/bin/env bash
# https://github.com/ao554/ConvertQEMUDisk
# I hate dos files and needing to convert them

# Check if qemu-img is installed
if ! type qemu-img &>/dev/null; then echo "Error: qemu-img is not installed or not in PATH. Exiting."; exit 1; fi

# Converts a VMware VMDK (Probably for the ESXi Nerds)
converterVMWare() {
	unset orig_path_vmwow new_path_file_vmwow
	echo -e "\nVMware to QCOW2 Conversion\n"
	until [[ -e "$orig_path_vmwow" ]]; do
		echo -e "\n[NOTICE] Please ensure that if you are using a Split VMDK, All the files are in the folder you're sourcing from."
		read -rep "Enter the Path to the Main VMDK File: " orig_path_vmwow
		[[ "$orig_path_vmwow" == '~'* ]] && orig_path_vmwow="$HOME${orig_path_vmwow/\~/}"
		[[ ! -e "$orig_path_vmwow" ]] && echo "File does not exist."
	done
	read -rep "Please enter a new path that includes the filename and extension (.qcow2): " new_path_file_vmwow
	[[ "$new_path_file_vmwow" == '~'* ]] && new_path_file_vmwow="$HOME${new_path_file_vmwow/\~/}"
	echo -e "Thanks! Conversion will start shortly."
	echo -e "[Notice] If you think the script has frozen, it hasn't.\n"
	qemu-img convert -O qcow2 "$orig_path_vmwow" "$new_path_file_vmwow"
	echo "Conversion Complete! Please check that your file is there :]"
	echo 'Press any key to go back to the main menu...'
	read -rn1
}

# Converts a Hyper-V Disk using qemu-img (assuming its installed)
converterHyperV() {
	unset orig_path new_path_file
	echo -e "\nHyper-V to QCOW2 Conversion\n"
	until [[ -e "$orig_path" ]]; do
		read -rep "Enter the Path to the vhd/vhdx file: " orig_path
		[[ "$orig_path" == '~'* ]] && orig_path="$HOME${orig_path/\~/}"
		[[ ! -e "$orig_path" ]] && echo "File does not exist."
	done
	read -rep "Please enter a new path that includes the filename and extension (.qcow2): " new_path_file
	[[ "$new_path_file" == '~'* ]] && new_path_file="$HOME${new_path_file/\~/}"
	[[ ! -e "$(dirname $new_path_file)" ]] && mkdir -p "$(dirname $new_path_file)"
	echo -e "Thanks! Conversion will start shortly."
	echo -e "[Notice] If you think the script has frozen, it hasn't.\n"
	qemu-img convert -O qcow2 "$orig_path" "$new_path_file"
	echo "Conversion Complete! Please check that your file is there :]"
	echo 'Press any key to go back to main menu...'
	read -rn1
}

while true; do
	unset main_option
	clear
	echo -e "\nAO's QEMU Converter\nFor Migrating Virtual Disk tasks\n"
	echo -e "\n[What would you like to do?]\n"
	echo "(1) Convert Hyper-V to QCOW2"
	echo "(2) Convert VMware to QCOW2"
	echo -e "(3) Quit\n"

	until [[ "$main_option" = "1" ]] || [[ "$main_option" = "2" ]] || [[ "$main_option" = "3" ]]; do
		read -rep "Choice: " main_option
	done

	case "$main_option" in
		1) converterHyperV;;
		2) converterVMWare;;
		3) echo -e "\nGoodbye!\nReturning to shell.\n"; exit 0;;
	esac
done
