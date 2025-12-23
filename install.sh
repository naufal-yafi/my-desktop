#!/usr/bin/env sh

set -e

# update system
echo "Updating system..."
sudo dnf update -y

# install development tools
echo "Installing development tools..."
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y openssl-devel pkg-config clang

# install gnome
echo "Installing GNOME and utilities..."
sudo dnf install -y \
    gnome-shell \
    gdm \
    gnome-control-center \
    gnome-session \
    gnome-settings-daemon \
    gnome-terminal \
    nautilus \
    xorg-x11-server-Xorg \
    xorg-x11-xauth \
    xorg-x11-drivers \
    mesa-dri-drivers \
    mesa-libEGL \
    mesa-libGL \
    dbus \
    polkit \
    NetworkManager \
    gsettings-desktop-schemas \
    bluez \
    kitty \
    neohtop \
    firefox \
    ffmpeg \
    nodejs

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# NVIDIA GeForce MX330
echo "Driver installation..."
sudo dnf install -y \
    https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda

sudo dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

# enable services
sudo systemctl enable gdm --force
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth
sudo systemctl set-default graphical.target

echo "Installation complete."

source ~/.cargo/env
sudo reboot