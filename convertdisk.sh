#!/usr/bin/env bash
# https://github.com/ao554/ConvertQEMUDisk
# I hate dos files and needing to convert them

ver="1.03"

# Check if qemu-img is installed
if ! type qemu-img &>/dev/null; then echo "Error: qemu-img is not installed or not in PATH. Exiting."; exit 1; fi

compressQCOW2() {
	# Compress qcow2 image

	unset orig_path_compress1 compress_final_path
	echo -e "\n==(Compress QCOW2 Image)==\n"

	# Original File Stuff
	until [[ -e "$orig_path_compress1" ]]; do
		echo -e "[NOTICE] This will attempt to compress your Virtual Disk."
		echo -e "[NOTICE] PLEASE MAKE SURE YOU HAVE A BACKUP.\n"
		read -rep "Enter the path to the original file: " orig_path_compress1
		[[ "$orig_path_compress1" == '~'* ]] && orig_path_compress1="$HOME${orig_path_compress/\~/}"
		[[ ! -e "$orig_path_compress1" ]] && echo -e "[ERROR] File does not exist. Please try again.\n"
	done

	# Final File Stuff
	read -rep "Please enter the path to the New QCOW2 Location (you need to include .qcow2): " compress_final_path
	[[ "$compress_final_path" == '~'* ]] && compress_final_path="$HOME${compress_final_path/\~/}"
	echo -e "[NOTICE] Your new file will be located at: $compress_final_path"
	echo -e "Attempting to compress...\n"
	qemu-img convert -p -c -O qcow2 "$orig_path_compress1" "$compress_final_path"
	echo -e "Compression complete.\n"
	echo 'Press any key to continue...'
	read -rn1

}

# Converts a VMware VMDK (Probably for the ESXi Nerds)
converterVMWare() {
	unset orig_path_vmwow new_path_file_vmwow
	echo -e "\n==(VMware to QCOW2 Conversion)==\n"
	# AAAAAAAAAA WHY THE FUCK IS NONE OF THIS COMMENTED WHAT THE FUCK IS GOING ON
	# THANK YOU GITHUB COPILOT FOR FINISHING THIS SHIT

	# Path finding bullshit
	until [[ -e "$orig_path_vmwow" ]]; do
		echo -e "[NOTICE] Please ensure that if you are using a Split VMDK, All the files are in the folder you're sourcing from."
		read -rep "Enter the Path to the Main VMDK File: " orig_path_vmwow
		[[ "$orig_path_vmwow" == '~'* ]] && orig_path_vmwow="$HOME${orig_path_vmwow/\~/}"
		[[ ! -e "$orig_path_vmwow" ]] && echo -e "[ERROR] File does not exist. Please try again.\n"
	done
	
	read -rep "Please enter a new path that includes the filename and extension (.qcow2): " new_path_file_vmwow
	[[ "$new_path_file_vmwow" == '~'* ]] && new_path_file_vmwow="$HOME${new_path_file_vmwow/\~/}"
	echo -e "Thanks! Conversion will start shortly."
	echo -e "[Notice] If you think the script has frozen, it hasn't.\n"
	qemu-img convert -p -O qcow2 "$orig_path_vmwow" "$new_path_file_vmwow"
	echo "Conversion Complete! Please check that your file is there :]"
	echo 'Press any key to go back to the main menu...'
	read -rn1
}

# Converts a Hyper-V Disk using qemu-img (assuming its installed)
converterHyperV() {
	unset orig_path new_path_file
	echo -e "\n==(Hyper-V to QCOW2 Conversion)==\n"

	until [[ -e "$orig_path" ]]; do
		read -rep "Enter the Path to the vhd/vhdx file: " orig_path
		[[ "$orig_path" == '~'* ]] && orig_path="$HOME${orig_path/\~/}"
		[[ ! -e "$orig_path" ]] && echo -e "[ERROR] File does not exist. Please try again.\n"
	done

	# The shit where I get people to put paths in and asuihausdhuiashd
	read -rep "Please enter a new path that includes the filename and extension (.qcow2): " new_path_file
	[[ "$new_path_file" == '~'* ]] && new_path_file="$HOME${new_path_file/\~/}"
	[[ ! -e "$(dirname $new_path_file)" ]] && mkdir -p "$(dirname $new_path_file)"

	echo -e "Thanks! Conversion will start shortly."
	echo -e "[Notice] If you think the script has frozen, it hasn't.\n"
	# The actual thing
	qemu-img convert -p -O qcow2 "$orig_path" "$new_path_file"
	echo -e "\nConversion Complete! Please check that your file is there :]"
	echo 'Press any key to go back to main menu...'
	read -rn1
}

while true; do
	unset main_option
	clear
	echo -e "\n ConvertQEMUDisk"
	echo -e " Version:" $ver
	echo -e "\n[What would you like to do?]\n"
	echo "[1] Convert Hyper-V to QCOW2"
	echo "[2] Convert VMware to QCOW2"
	echo "[3] Attempt to compress QCOW2"
	echo -e "[4] Quit\n"

	until [[ "$main_option" = "1" ]] || [[ "$main_option" = "2" ]] || [[ "$main_option" = "3" ]] || [[ "$main_option" = "4" ]]; do
		read -rep "Choice: " main_option
	done

	case "$main_option" in
		1) converterHyperV;;
		2) converterVMWare;;
		3) compressQCOW2;;
		4) echo -e "\nGoodbye!\nReturning to shell.\n"; exit 0;;
	esac
done
