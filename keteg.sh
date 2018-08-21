#!/bin/sh

# VERSION CODE
version=2.0.4
# headline color
COLOR_blue="\033[1;34m"
COLOR_reset="\033[0m"
COLOR_green="\033[0;32m"
COLOR_red="\033[1;31m"

list_available_kernels() {
    mhwd-kernel -l
}

# LIST INSTALLED
list_installed() {
    echo -e "\n${COLOR_blue} Listing Installed Kernels${COLOR_reset}"
    echo -e " -------------------------\n"
    pacman -Ss $(mhwd-kernel -li | grep -oh "\w*linux\w*" -m1)>/dev/null
    if [ $? = 0 ]
    then
        echo -e "${COLOR_green}[OK] You are using a supported Kernel.${COLOR_reset}"
    else
        echo -e "${COLOR_red}[WARNING] You are using a no longer supported Kernel! Upgrading is highly recommended.${COLOR_reset}"
    fi
    echo
    mhwd-kernel -li
}

# LIST AVAILABLE
list_available() {
    echo -e "\n${COLOR_blue} Listing Available Kernels${COLOR_reset}"
    echo -e " -------------------------\n"
    list_available_kernels
}

# INSTALL
install_kernel() {
    echo -e "\n${COLOR_blue} Install Kernel${COLOR_reset}"
    echo -e " --------------\n"
    list_available_kernels
    echo
    trap "return" SIGINT
    read -p "# Choose a kernel to install: " kernelinstall
    echo
    trap "return" SIGINT
    read -p "# Remove current kernel after installing (y/n): " remcurrent
    echo
    if [ "$remcurrent" = "y" ]
    then
        sudo mhwd-kernel -i $kernelinstall rmc
    elif [ "$remcurrent" = "n" ]
    then
        sudo mhwd-kernel -i $kernelinstall
    else
        usage_error
        read -n1 -p ""
        install_kernel
    fi
}

# REMOVE
remove_kernel() {
    echo -e "\n${COLOR_blue} Remove Kernel${COLOR_reset}"
    echo -e " -------------\n"
    mhwd-kernel -li
    echo
    trap "return" SIGINT
    read -p "# Choose a kernel to remove: " kernelremove
    echo
    sudo mhwd-kernel -r $kernelremove
}

# UPDATE
update_kernel() {
    echo -e "\n${COLOR_blue} Searching for kernel update...${COLOR_reset}\n"
    sudo pacman -Sy --needed $(mhwd-kernel -li | grep -oh "\w*linux\w*" | xargs)
}

# INFORMATION
about() {
    echo -e "\n${COLOR_blue} Information${COLOR_reset}"
    echo -e " -----------\n"
    echo "Kernel name: $(uname -s)"
    echo "Host name: $(uname -n)"
    echo "Kernel release: $(uname -r)"
    echo "Kernel version: $(uname -v)"
    echo "Machine: $(uname -m)"
    echo "Processor: $(uname -p)"
    echo "Hardware platform: $(uname -i)"
    echo "Operating system: $(uname -o)"
    echo -e "\n\n${COLOR_blue}+--------------------------+"
    echo "| MHWD-Kernel Terminal GUI |"
    echo -e "+--------------------------+${COLOR_reset}"
    echo -e "\nKeteg version $version"
    echo -e "by Phoenix1747, 2018.\n"
}

usage_error() {
  echo -e "\n${COLOR_red}> Usage error: Argument not recognized. Please choose one of the available numbers.${COLOR_reset}"
}

# MAIN MENU
menu() {
    clear
    echo -e "\n${COLOR_blue}KETEG $version${COLOR_reset}"
    echo -e "\nChoose from the following commands:\n"
    echo " [1] List installed Kernel(s)"
    echo " [2] List available Kernels"
    echo " [3] Install Kernel(s)"
    echo " [4] Remove Kernel(s)"
    echo " [5] Update Kernel(s)"
    echo " [6] Info"
    echo -e " [7] Quit\n"
    read -p ":: " arg
    case $arg in
      1)  # List installed kernels
        clear
        list_installed;;
      2)  # List available kernels
        clear
        list_available;;
      3)  # Install a new kernel
        clear
        install_kernel;;
      4)  # Remove existing kernel
        clear
        remove_kernel;;
      5)  # Update installed kernels
        clear
        update_kernel;;
      6)  # Open the about tab
        clear
        about;;
      7) # Exit
        clear
        exit;;
      *)  # Else usage error
        usage_error
    esac
    echo
    read -n1 -p "Press any key to continue..."
}

while true
do
  menu
done
