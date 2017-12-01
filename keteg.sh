#!/bin/bash

# VERSION CODE
version=1.0

# LIST INSTALLED
li() {
    clear
    echo -e "\n# Listing Installed Kernels #"
    echo -e " ---------------------------\n"
    installed_kernel=$(mhwd-kernel -li | grep -oh "\w*linux\w*" -m1 2>&1)
    pacman -Ss $installed_kernel > /dev/null 2>&1
    if [ $? = 0 ]
    then
        echo "[OK] You are using a supported Kernel."
    else
        echo "[WARNING] You are using an unsupported Kernel! Upgrading is highly recommended."
    fi
    echo
    mhwd-kernel -li
    echo
    read -n1 -p "Press any key to continue..."
    menu
}

# LIST AVAILABLE
la() {
    clear
    echo -e "\n# Listing Available Kernels #"
    echo -e " ---------------------------\n"
    mhwd-kernel -l | grep "\s*linux\s*" 2>&1
    echo
    read -n1 -p "Press any key to continue..."
    menu
}

# INSTALL
ins() {
    clear
    echo -e "\n# Install Kernel #"
    echo -e " ----------------\n"
    echo "Available Kernels:"
    mhwd-kernel -l | grep "\s*linux\s*" 2>&1
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
        ins
    fi
    echo
    read -n1 -p "Press any key to continue..."
    menu
}

# REMOVE
rem() {
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
upd() {
    clear
    echo -e "\n# Searching for updates....\n"
    sudo pacman -Syyu
    echo
    read -n1 -p "Press any key to continue..."
    menu
}

# INFORMATION
inf() {
    clear
    echo -e "\n# Information #"
    echo -e " -------------\n"
    uname -a
    echo -e "\n\n----------------------------"
    echo "| MHWD Kernel Terminal GUI |"
    echo "----------------------------"
    echo -e "\nKETEG version $version"
    echo -e "by Phoenix1747, 2017.\n\n"
    read -n1 -p "Press any key to continue..."
    menu
}

# CHECK FUNCTION
check() {
    if [[ $cmd  =~ ^[1-7]+$ ]]
    then
        if [ $cmd = 1 ]
        then
            li
        elif [ $cmd = 2 ]
        then
            la
        elif [ $cmd = 3 ]
        then
            ins
        elif [ $cmd = 4 ]
        then
            rem
        elif [ $cmd = 5 ]
        then
            upd
        elif [ $cmd = 6 ]
        then
            inf
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

# MENUls
menu() {
    clear
    echo -e "\n# MHWD Kernel Terminal GUI v$version"
    echo -e "\nChoose one of the following commands:\n"
    echo "[1] List installed Kernel(s)"
    echo "[2] List available Kernels"
    echo "[3] Install Kernel"
    echo "[4] Remove Kernel"
    echo "[5] Update System"
    echo "[6] Info"
    echo -e "[7] Quit\n"
    read -p "Command: " cmd
    check
}

menu
