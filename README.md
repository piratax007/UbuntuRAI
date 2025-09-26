# What is UbuntuRAI
It is a customized version of Ubuntu that enables, by default, the use of ROS2 and persistence storange on live USB sticks. This allows users to run tests and labs without modifying the host system or requiring virtualization or containers. Additionally, the ISO image can be installed directly on a computer, providing Ubuntu with ROS2 and all included applications preconfigured.

Currently, UbuntuRAI is build in two flavors: **Ubuntu 22.04 Jammy + ROS2 Humble**, and **Ubuntu 24.04 Noble + ROS2 Jazzy**.

[![build-jammy](https://github.com/piratax007/UbuntuRAI/actions/workflows/build-jammy.yml/badge.svg)](https://github.com/piratax007/UbuntuRAI/actions/workflows/build-jammy.yml)
[![build-noble](https://github.com/piratax007/UbuntuRAI/actions/workflows/build-noble.yml/badge.svg)](https://github.com/piratax007/UbuntuRAI/actions/workflows/build-noble.yml)

## Software available in the base image:
- **Terminal emulators** 
    - Terminator
    - tilix
- **Code editors**
    - Emacs
    - Vim
    - Nano
    - Gedit
    - VS Code

- **Tools** 
    - Git
    - Curl
    - Less
    - Python-venv
    - Wi-Fi drivers (linux-firmware)
    - Network Manager

- **Preinstalled ROS2 packages**
    - Crazyswarm2
    - Turtlebot3

> The ROS2 installation is sourced on any new terminal by default.

## How to use the base image
1. Download the preferred .iso image the GitHub Releases.
2. Insert the USB stick and its device name by running `lsblk` in a termial.
3. Burn the image to a USB stick (at least 16 GB)

```bash
sudo dd if=/path/to/the/downloaded.iso of=/dev/sdx bs=4M status=progress oflag=sync
```
> Replace `x` in `/dev/sdx` with the correct device letter.

4. Enable the persistent storage.
- Download the [enable_persistence.sh](https://github.com/piratax007/UbuntuRAI/blob/master/scripts/enable_persistence.sh).
- Grant execution persions `chmod +x enable_persisence.sh`.
- Unplug and reconnect the USB stick before running the script.
- Run the script, passing the USB Stick device as input argument:

```bash
sudo ./enable_persistence.sh /dev/sdx
```
> Replace `x` in `/dev/sdx` with the correct device letter.

> The entire avilable free space on your USB stick is allocated for persistent storage,

5. Boot your PC from the USB Stick and select the option `Try UbuntuRAI persistent` in the GRUB menu. _You can now add files, install new applications, etc. All changes will be save on the persistence storage and preserved after reboot.
> The images are prepared to be compatible with secure boot. However, if your Windows machine requires disabling Secure Boot in order to boot from the live USB stick, follow one of these options:
> 1. Before disabling Secure Boot, log into your Microsoft account at [https://account.microsoft.con/devices/recoverykey](https://account.microsoft.con/devices/recoverykey) and save your BitLocker recovery key.
> When Windows detects the change, you can simple enter the recovery key once, after which it should boot normally.
>
> 2. In Windows.
> - Open Control Panel -> search for BitLocker
> - Select **Suspend protection**. This keeps the disk encrypted but tells Windows not to enforce boot integrity checks until the next reboot.
> - Disable Secure Boot and boot UbuntuRAI.
>
> **Note:** Suspending BitLocker protection is temporary and requires administrator rights.

### Verifying the downloaded image
To ensuer the integrity of the downloaded `.iso` file, use the `md5sum.txt` file provided with the release:
1. Download the corresponding `md5sum.txt` file from the Releases page.
2. Run the following command in the directory containing both the `.iso` and `md5sum.txt` files:
```
md5sum -c md5sum.txt
```
If the output shows `OK` for the ISO image, the file is intact and has not been corrupted during download.

## How to modify UbuntuRAI prebuilt images.
To add new applications, files, or settings and build a new ISO image, follow these steps:
1. Clone this repository.
2. Use the `customize_image` function in the `config.sh` script to install new applications or make other modifications.
3. Commit your changes.
4. Push your changes `v*` tag. GitHub Actions workflows will build your new images, which you can then download from the Releases page of your repository.

# Summary
UbuntuRAI is a customized Ubuntu distribution designed to run as a live OS with persistend storage and ROS2 preinstalled. It can algo be installed directly on a computer, providing a ready-to-use Ubuntu system with ROS2 and all boundled applications. You can use the prebuild base image to add applications, files, and code using persistend storage, of build your own customized version with the `config.sh` script.

# Contributing
Please read [CONTRIBUTING.md](https://github.com/piratax007/UbuntuRAI/blob/master/CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

---
# References:
- [1] M. T. Vallim, mvallim/live-custom-ubuntu-from-scratch. (Sep. 23, 2025). [Online]. Available: https://github.com/mvallim/live-custom-ubuntu-from-scratch
