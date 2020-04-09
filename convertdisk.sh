#!/bin/bash
#'Arry woz here wait wot


# The programs escape from my code nightmare
choice_two()
{
   echo ""
   echo "Goodbye!"
   echo "Returning to shell."
   echo ""
   exit 0
}

# Converts a Hyper-V Disk using qemu-img (assuming its installed)
choice_one() 
{
echo ""
echo "Hyper-V to QCOW2 Conversion"
echo ""
echo "This process requires that you have 'qemu-img' installed on your system"
echo "if you do not have the required package, CTRL + C and Install it"
echo ""
echo -n "Enter the Path to the vhd/vhdx file: "
read -r orig_path
echo ""
echo -n "Please enter a new path + the name and extension: "
read -r new_path_file
echo ""
echo "Thanks! Conversion will start shortly."
echo ""
qemu-img convert -O qcow2 $orig_path $new_path_file
echo "Conversion Complete! Please check that your file is there :]"
echo "" 
printf 'Press [ENTER] to go back to main menu...'
read _
main_menu
}

main_menu() 
{
clear
echo ""
echo "Harri's Simplified Disk Converter"
echo "For QEMU Related tasks"
echo ""


echo ""
echo "What would you like to do?"
echo ""
echo "(1) Convert Hyper-V to QCOW2"
echo "(2) Quit"
echo ""


echo -n "Choice: "
read -r main_option
}

main_menu

if [ $main_option = '1' ];
then
   choice_one
else
   if [ $main_option = '2' ];
   then
      choice_two
   fi
fi

