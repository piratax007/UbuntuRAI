#!/bin/bash

# This script provides common customization options for the ISO
# 
# Usage: Copy this file to config.sh and make changes there.  Keep this file (default_config.sh) as-is
#   so that subsequent changes can be easily merged from upstream.  Keep all customiations in config.sh

# The version of Ubuntu to generate.  Successfully tested LTS: bionic, focal, jammy, noble
# See https://wiki.ubuntu.com/DevelopmentCodeNames for details
export TARGET_UBUNTU_VERSION="jammy"

export TARGET_ROS_VERSION="humble"

# The Ubuntu Mirror URL. It's better to change for faster download.
# More mirrors see: https://launchpad.net/ubuntu/+archivemirrors
export TARGET_UBUNTU_MIRROR="http://us.archive.ubuntu.com/ubuntu/"

# The packaged version of the Linux kernel to install on target image.
# See https://wiki.ubuntu.com/Kernel/LTSEnablementStack for details
export TARGET_KERNEL_PACKAGE="linux-generic"

# The file (no extension) of the ISO containing the generated disk image,
# the volume id, and the hostname of the live environment are set from this name.
export TARGET_NAME="UbuntuRAI"

# The text label shown in GRUB for booting into the live environment
export GRUB_LIVEBOOT_LABEL="Try UbuntuRAI without installing"

# The text label shown in GRUB for starting installation
export GRUB_INSTALL_LABEL="Install UbuntuRAI"

# Packages to be removed from the target system after installation completes succesfully
export TARGET_PACKAGE_REMOVE="
    ubiquity \
    casper \
    discover \
    laptop-detect \
    os-prober \
"

# Package customisation function.  Update this function to customize packages
# present on the installed system.
function customize_image() {
    # install graphics and desktop
    apt-get install -y \
        plymouth-themes \
        ubuntu-gnome-desktop \
        ubuntu-gnome-wallpapers

    # useful tools
    apt-get install -y \
        clamav-daemon \
        terminator \
        tilix \
        emacs \
        apt-transport-https \
        curl \
        vim \
        git \
        nano \
        less

    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list
    rm microsoft.gpg
    apt-get update
    apt-get install -y code

    apt-get install software-properties-common
    add-apt-repository -y universe
    apt-get update
    export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}')
    curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo $UBUNTU_CODENAME)_all.deb"
    dpkg -i /tmp/ros2-apt-source.deb
    apt-get update
    apt-get upgrade -y
    apt-get install -y ros-${TARGET_ROS_VERSION}-desktop
    apt-get install -y ros-dev-tools
    apt-get install -y ros-${TARGET_ROS_VERSION}-crazyflie
    apt-get install -y ros-${TARGET_ROS_VERSION}-crazyflie-dbgsym
    apt-get install -y ros-${TARGET_ROS_VERSION}-crazyflie-examples
    apt-get install -y ros-${TARGET_ROS_VERSION}-interfaces
    apt-get install -y ros-${TARGET_ROS_VERSION}-crazyflie-interfaces-dbgsym
    apt-get install -y ros-${TARGET_ROS_VERSION}-crazyflie-py
    apt-get install -y ros-${TARGET_ROS_VERSION}-crazyflie-sim
    apt-get install -y ros-${TARGET_ROS_VERSION}-turtlebot3

    # purge
    apt-get purge -y \
        transmission-gtk \
        transmission-common \
        gnome-mahjongg \
        gnome-mines \
        gnome-sudoku \
        aisleriot \
        hitori

    apt-get autoremove -y
}

# Used to version the configuration.  If breaking changes occur, manual
# updates to this file from the default may be necessary.
export CONFIG_FILE_VERSION="0.4"
