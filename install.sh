#!/bin/bash

# Hyprland Laptop Installation Script
# This script installs and configures Hyprland with all necessary components for laptop usage

# Color definitions for output messages
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_message() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Arch Linux
if [ ! -f /etc/arch-release ]; then
    print_error "This script is intended for Arch Linux only!"
    exit 1
fi

# Check if paru is installed, if not install it
if ! command -v paru &> /dev/null; then
    print_message "Installing paru AUR helper..."
    sudo pacman -S --needed base-devel
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
    cd ..
    rm -rf paru
fi

# Install necessary packages
print_message "Installing required packages..."

PACKAGES=(
    # Window Manager and Core Components
    "hyprland"
    "waybar-hyprland"
    "xdg-desktop-portal-hyprland"
    
    # Terminal and Shell
    "kitty"
    "zsh"
    "oh-my-zsh-git"
    
    # Application Launcher and Utilities
    "wofi"
    "wl-clipboard"
    "cliphist"
    
    # Authentication and Settings
    "polkit-kde-agent"
    "nwg-look-bin"
    
    # Notifications
    "dunst"
    "libnotify"
    
    # Audio
    "pipewire"
    "pipewire-alsa"
    "pipewire-pulse"
    "wireplumber"
    "pavucontrol"
    "pamixer"
    
    # Network
    "networkmanager"
    "network-manager-applet"
    
    # Bluetooth
    "bluez"
    "bluez-utils"
    "blueman"
    
    # Display and Graphics
    "brightnessctl"
    "grim"
    "slurp"
    "swaylock-effects"
    "hyprpaper"
    
    # File Manager
    "thunar"
    "thunar-archive-plugin"
    "file-roller"
    
    # System Monitoring
    "btop"
    "sensors"
    
    # Fonts
    "ttf-jetbrains-mono-nerd"
    "ttf-font-awesome"
    
    # Qt and GTK Support
    "qt5-wayland"
    "qt6-wayland"
    "gtk3"
    
    # Additional Tools
    "jq"
    "imagemagick"
    "xdg-utils"
)

# Install all packages
paru -S --needed ${PACKAGES[@]}

# Create necessary directories
print_message "Creating configuration directories..."
mkdir -p ~/.config/{hypr,waybar,dunst,wofi,kitty}

# Enable necessary services
print_message "Enabling services..."
systemctl --user enable pipewire.service
systemctl --user enable wireplumber.service
sudo systemctl enable NetworkManager.service
sudo systemctl enable bluetooth.service
