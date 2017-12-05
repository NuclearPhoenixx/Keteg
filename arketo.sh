#!/bin/bash

# VERSION CODE
version=1.0

# LIST INSTALLED
list_installed() {
    clear
    echo -e "\n# Listing Installed Kernels #"
    echo -e " ---------------------------\n"
    pacman -Ss $(ls /boot | grep -oh "\w*linux\w*" | sort -V | tail -1) > /dev/null
    if [ $? = 0 ]
    then
        echo "[OK] You are using a supported Kernel."
    else
        echo "[WARNING] You are using a no longer supported Kernel! Upgrading is highly recommended."
    fi
    echo
    ls /boot | grep -oh "\w*linux\w*" | sort -r -V
    echo
    read -n1 -p "Press any key to continue..."
    menu
}

# LIST AVAILABLE
list_available() {
    clear
    echo -e "\n# Listing Available Kernels #"
    echo -e " ---------------------------\n"
    pacman -Ss | grep core/ | grep -o "\w*linux\w*" | uniq | grep -v sys | grep -v arch | grep -v '\blinux\b' | sort -g
    echo
    read -n1 -p "Press any key to continue..."
    menu
}

# INSTALL
install_kernel() {
    clear
    echo -e "\n# Install Kernel #"
    echo -e " ----------------\n"
    echo -e "Available Kernels:\n"
    pacman -Ss | grep core/ | grep -o "\w*linux\w*" | uniq | grep -v sys | grep -v arch | grep -v '\blinux\b' | sort -g
    echo
    read -p "# Choose a kernel to install: " kernelinstall
    echo
    sudo pacman -Sy $kernelinstall
    echo
    read -n1 -p "Press any key to continue..."
    menu
}

# REMOVE
remove_kernel() {
    clear
    echo -e "\n# Remove Kernel #"
    echo -e " ---------------\n"
    ls /boot | grep -oh "\w*linux\w*"| sort -r -V
    echo
    read -p "# Choose a kernel to remove: " kernelremove
    echo
    sudo pacman -Rnc $kernelremove
    echo
    read -n1 -p "Press any key to continue..."
    menu
}

# UPDATE
update() {
    clear
    echo -e "\n# Searching for kernel update....\n"
    sudo pacman -Sy --needed $(ls /boot | grep -oh "\w*linux\w*" | xargs)
    echo
    read -n1 -p "Press any key to continue..."
    menu
}

# INFORMATION
about() {
    clear
    echo -e "\n# Information #"
    echo -e " -------------\n"
    echo "Kernel name: $(uname -s)"
    echo "Host name: $(uname -n)"
    echo "Kernel release: $(uname -r)"
    echo "Kernel version: $(uname -v)"
    echo "Machine: $(uname -m)"
    echo "Processor: $(uname -p)"
    echo "Hardware platform: $(uname -i)"
    echo "Operating system: $(uname -o)"
    echo -e "\n\n--------------------"
    echo "| Arch Kernel Tool |"
    echo "--------------------"
    echo -e "\nArketo version $version"
    echo -e "by Phoenix1747, 2017.\n\n"
    read -n1 -p "Press any key to continue..."
    menu
}

# MAIN MENU
menu() {
    clear
    echo -e "\n# Arch Kernel Tool v$version"
    echo -e "\nChoose one of the following commands:\n"
    echo "[1] List installed Kernel(s)"
    echo "[2] List available Kernels"
    echo "[3] Install Kernel"
    echo "[4] Remove Kernel"
    echo "[5] Update Kernel"
    echo "[6] Info"
    echo -e "[7] Quit\n"
    read -p "Command: " cmd
    if [[ $cmd  =~ ^[1-7]+$ ]]
    then
        if [ $cmd = 1 ]
        then
            list_installed
        elif [ $cmd = 2 ]
        then
            list_available
        elif [ $cmd = 3 ]
        then
            install_kernel
        elif [ $cmd = 4 ]
        then
            remove_kernel
        elif [ $cmd = 5 ]
        then
            update
        elif [ $cmd = 6 ]
        then
            about
        else
            clear
            echo
            exit 0
        fi
    else
        echo -e "\n> Usage error: Argument not recognized. Please choose one of the available numbers.\n\n"
        read -n1 -p "Press any key to continue..."
        menu
    fi
}

menu
