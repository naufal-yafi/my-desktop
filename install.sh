#!/usr/bin/env sh

set -e

# update system
echo "Updating system..."
sudo dnf update -y

# install development tools
echo "Installing development tools..."
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y \
  openssl-devel \
  pkg-config \
  clang \
  kernel-devel \
  kernel-headers

# install gnome
echo "Installing GNOME and utilities..."
sudo dnf install -y \
    gnome-shell \
    gdm \
    gnome-control-center \
    gnome-session \
    gnome-settings-daemon \
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
    pipewire \
    pipewire-pulse \
    wireplumber \
    kitty \
    neohtop \
    firefox \

echo "Enabling RPM Fusion..."
sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

echo "Installing multimedia codecs..."
sudo dnf install -y ffmpeg
sudo dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

echo "Installing NVIDIA driver..."
sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda

echo "Installing Node.js LTS..."
curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
sudo dnf install -y nodejs

echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y 

# enable services
echo "Enabling services..."
sudo systemctl enable gdm --force
sudo systemctl enable --now NetworkManager bluetooth
sudo systemctl set-default graphical.target

echo "Installation complete. Rebooting..."
source "$HOME/.cargo/env"
sudo reboot