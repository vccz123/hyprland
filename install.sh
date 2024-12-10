#!/bin/bash

# Hyprland Laptop Installation Script
# This script installs and configures Hyprland with all necessary components for laptop usage,
# including SDDM display manager and wlogout for a modern logout experience

# Color definitions for better readability in terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions for consistent message formatting
print_message() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verify we're running on Arch Linux
if [ ! -f /etc/arch-release ]; then
    print_error "This script is intended for Arch Linux only!"
    exit 1
fi

# Install paru if not present
if ! command -v paru &> /dev/null; then
    print_message "Installing paru AUR helper..."
    sudo pacman -S --needed base-devel
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
    cd ..
    rm -rf paru
fi

# Define all required packages
print_message "Installing required packages..."

PACKAGES=(
    # Window Manager and Core Components
    "hyprland"
    "waybar-hyprland"
    "xdg-desktop-portal-hyprland"
    
    # Display Manager and Session Management
    "sddm"
    "sddm-theme-catppuccin-git"
    "wlogout"
    
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

# Create necessary configuration directories
print_message "Creating configuration directories..."
mkdir -p ~/.config/{hypr,waybar,dunst,wofi,kitty,wlogout}

# Configure SDDM
print_message "Configuring SDDM..."
sudo tee /etc/sddm.conf.d/custom.conf > /dev/null << 'EOL'
[Theme]
Current=catppuccin
CursorTheme=Bibata-Modern-Classic
Font=JetBrains Mono Nerd Font

[Autologin]
# Uncomment and modify these lines to enable autologin
#User=your_username
#Session=hyprland
EOL

# Configure wlogout
print_message "Configuring wlogout..."
tee ~/.config/wlogout/style.css > /dev/null << 'EOL'
window {
    background-color: rgba(0, 0, 0, 0.5);
    font-family: JetBrainsMono Nerd Font;
}

button {
    background-color: rgba(30, 30, 30, 0.9);
    border-radius: 10px;
    margin: 5px;
    padding: 10px;
}

button:hover {
    background-color: rgba(50, 50, 50, 0.9);
}

#lock {
    background-image: image(url("/usr/share/wlogout/icons/lock.png"));
}

#logout {
    background-image: image(url("/usr/share/wlogout/icons/logout.png"));
}

#suspend {
    background-image: image(url("/usr/share/wlogout/icons/suspend.png"));
}

#hibernate {
    background-image: image(url("/usr/share/wlogout/icons/hibernate.png"));
}

#shutdown {
    background-image: image(url("/usr/share/wlogout/icons/shutdown.png"));
}

#reboot {
    background-image: image(url("/usr/share/wlogout/icons/reboot.png"));
}
EOL

# Add wlogout configuration to Hyprland config
print_message "Adding wlogout keybinding to Hyprland..."
tee -a ~/.config/hypr/hyprland.conf > /dev/null << 'EOL'
# wlogout keybinding
bind = $mainMod SHIFT, E, exec, wlogout -p layer-shell
EOL

# Enable necessary services
print_message "Enabling services..."
systemctl --user enable pipewire.service
systemctl --user enable wireplumber.service
sudo systemctl enable NetworkManager.service
sudo systemctl enable bluetooth.service
sudo systemctl enable sddm.service
