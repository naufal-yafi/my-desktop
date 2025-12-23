#!/usr/bin/env sh

set -e

# update system
echo "Updating system..."
sudo dnf update -y

# install development tools
echo "Installing development tools..."
sudo dnf group install -y development-tools
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
    gnome-system-monitor \
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
    firefox

echo "Enabling RPM Fusion..."
sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

echo "Installing multimedia codecs..."
sudo dnf group install -y multimedia \
  --setopt=install_weak_deps=False \
  --exclude=PackageKit-gstreamer-plugin

echo "Installing NVIDIA driver..."
sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda
sudo akmods --force
sudo dracut --force

echo "Installing Node.js LTS..."
curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
sudo dnf install -y nodejs

echo "Install MS Edge..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo tee /etc/yum.repos.d/microsoft-edge.repo << 'EOF'
[microsoft-edge]
name=Microsoft Edge
baseurl=https://packages.microsoft.com/yumrepos/edge
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
sudo dnf install microsoft-edge-stable

# enable services
echo "Enabling services..."
sudo systemctl enable gdm --force
sudo systemctl enable --now NetworkManager bluetooth
sudo systemctl set-default graphical.target

echo "Installation complete. Rebooting..."
source "$HOME/.cargo/env"
sudo reboot