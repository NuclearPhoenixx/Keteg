#!/bin/sh

# VERSION CODE
version=2.0.2
# headline color
COLOR_blue="\033[1;34m"
COLOR_reset="\033[0m"
COLOR_green="\033[0;32m"
COLOR_red="\033[1;31m"

# List all the available kernels
list_all_available_kernels() {
    pacman -Ss | grep core/ | grep -o "\w*linux\w*" | grep -vE "sys|arch|\blinux\b" | uniq | sort -rV
}
# List all installed kernels
list_all_installed_kernels() {
    ls /boot | grep -oh "\w*linux\w*" | sort -rV
}

# LIST INSTALLED
list_installed() {
    echo -e "\n${COLOR_blue} Listing Installed Kernels${COLOR_reset}"
    echo -e " -------------------------\n"
    pacman -Si $(ls /boot | grep -oh "\w*linux\w*" | sort -V | tail -1)>/dev/null
    if [ $? = 0 ]
    then
        echo -e "${COLOR_green}[OK] You are using a supported Kernel.${COLOR_reset}"
    else
        echo -e "${COLOR_red}[WARNING] You are using a no longer supported Kernel! Upgrading is highly recommended.${COLOR_reset}"
    fi
    echo
    list_all_installed_kernels
}

# LIST AVAILABLE
list_available() {
    echo -e "\n${COLOR_blue} Listing Available Kernels${COLOR_reset}"
    echo -e " -------------------------\n"
    list_all_available_kernels
}

# INSTALL
install_kernel() {
    echo -e "\n${COLOR_blue} Install Kernel${COLOR_reset}"
    echo -e " --------------\n"
    echo -e "Available Kernels:\n"
    list_all_available_kernels
    echo
    trap "return" SIGINT
    read -p "# Choose a kernel to install: " kernelinstall
    echo
    sudo pacman -Sy $kernelinstall
}

# REMOVE
remove_kernel() {
    echo -e "\n${COLOR_blue} Remove Kernel${COLOR_reset}"
    echo -e " -------------\n"
    list_all_installed_kernels
    echo
    trap "return" SIGINT
    read -p "# Choose a kernel to remove: " kernelremove
    echo
    sudo pacman -Rnc $kernelremove
}

# UPDATE
update_kernel() {
    echo -e "\n${COLOR_blue} Searching for kernel update...${COLOR_reset}\n"
    sudo pacman -Sy --needed $(list_all_installed_kernels)
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
    echo -e "\n\n${COLOR_blue}+---------------------+"
    echo "| Kernel Terminal GUI |"
    echo -e "+---------------------+${COLOR_reset}"
    echo -e "\nKeteg version $version"
    echo -e "by Phoenix1747, 2017.\n"
}

# UPDATE PACKAGE SOURCES
update_sources(){
    echo -e "\n${COLOR_blue} Updating Package Sources${COLOR_reset}"
    echo -e " ------------------------\n"
    sudo pacman -Syy
}

# MAIN MENU
menu() {
    clear
    echo -e "\n${COLOR_blue}Kernel Terminal GUI $version${COLOR_reset}"
    echo -e "\nChoose one of the following commands:\n"
    echo " [1] List installed Kernel(s)"
    echo " [2] List available Kernels"
    echo " [3] Install Kernel(s)"
    echo " [4] Remove Kernel(s)"
    echo " [5] Update Kernel(s)"
    echo " [6] Update Package Sources"
    echo " [7] Info"
    echo -e " [8] Quit\n"
    read -p "Command: " arg
    case $arg in
      1) #List installed kernels
        clear
        list_installed;;
      2) #List available kernels
        clear
        list_available;;
      3) #Install a new kernel
        clear
        install_kernel;;
      4) #Remove an installed kernel
        clear
        remove_kernel;;
      5) #Update an existing kernel
        clear
        update_kernel;;
      6) #Update the package sources
        clear
        update_sources;;
      7) #Go to about tab
        clear
        about;;
      8) #Exit
        clear
        exit;;
      *) #Else unknown
        echo -e "\n${COLOR_red}> Usage error: Argument not recognized. Please choose one of the available numbers.${COLOR_reset}"
    esac
    echo
    read -n1 -p "Press any key to continue..."
}

while true
do
  menu
done
