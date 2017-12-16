#!/bin/bash

# VERSION CODE
version=1.2.1

list_available_kernels() {
    mhwd-kernel -l | grep "\s*linux\s*" | sort -rV
}

# LIST INSTALLED
list_installed() {
    clear
    echo -e "\n# Listing Installed Kernels #"
    echo -e " ---------------------------\n"
    pacman -Ss $(mhwd-kernel -li | grep -oh "\w*linux\w*" -m1)>/dev/null
    if [ $? = 0 ]
    then
        echo "[OK] You are using a supported Kernel."
    else
        echo "[WARNING] You are using a no longer supported Kernel! Upgrading is highly recommended."
    fi
    echo
    mhwd-kernel -li
    echo
    read -n1 -p "Press any key to continue..."
    menu
}

# LIST AVAILABLE
list_available() {
    clear
    echo -e "\n# Listing Available Kernels #"
    echo -e " ---------------------------\n"
    list_available_kernels
    echo
    read -n1 -p "Press any key to continue..."
    menu
}

# INSTALL
install_kernel() {
    clear
    echo -e "\n# Install Kernel #"
    echo -e " ----------------\n"
    echo "Available Kernels:"
    list_available_kernels
    echo
    read -p "# Choose a kernel to install: " kernelinstall
    echo
    read -p "# Remove current kernel after installing (y/n): " remcurrent
    if [ "$remcurrent" = "y" ]
    then
        echo
        sudo mhwd-kernel -i $kernelinstall rmc
    elif [ "$remcurrent" = "n" ]
    then
        echo
        sudo mhwd-kernel -i $kernelinstall
    else
        echo -e "\n> Usage error: You have to choose 'y' for yes and 'n' for no."
        read -n1 -p ""
        install_kernel
    fi
    echo
    read -n1 -p "Press any key to continue..."
    menu
}

# REMOVE
remove_kernel() {
    clear
    echo -e "\n# Remove Kernel #"
    echo -e " ---------------\n"
    mhwd-kernel -li
    echo
    read -p "# Choose a kernel to remove: " kernelremove
    echo
    sudo mhwd-kernel -r $kernelremove
    echo
    read -n1 -p "Press any key to continue..."
    menu
}

# UPDATE
update() {
    clear
    echo -e "\n# Searching for kernel update....\n"
    sudo pacman -Sy --needed $(mhwd-kernel -li | grep -oh "\w*linux\w*" | xargs)
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
    echo -e "\n\n----------------------------"
    echo "| MHWD-Kernel Terminal GUI |"
    echo "----------------------------"
    echo -e "\nKETEG version $version"
    echo -e "by Phoenix1747, 2017.\n\n"
    read -n1 -p "Press any key to continue..."
    menu
}

# MAIN MENU
menu() {
    clear
    echo -e "\n# MHWD-Kernel Terminal GUI v$version"
    echo -e "\nChoose one of the following commands:\n"
    echo "[1] List installed Kernel(s)"
    echo "[2] List available Kernels"
    echo "[3] Install Kernel(s)"
    echo "[4] Remove Kernel(s)"
    echo "[5] Update Kernel(s)"
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
            exit 0
        fi
    else
        echo -e "\n> Usage error: Argument not recognized. Please choose one of the available numbers.\n\n"
        read -n1 -p "Press any key to continue..."
        menu
    fi
}

menu
