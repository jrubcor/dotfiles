#!/bin/bash

# Vars
TEMP_DIR=$(mktemp -d)

# Function to install pacman packages
install_pacman_packages() {
    for package in "$@"; do
        if ! pacman -Q "$package" &>/dev/null; then
            echo "Installing $package..."
            sudo pacman -S --noconfirm "$package"
        else
            echo "$package is already installed"
        fi
    done
}

# Install required packages
install_pacman_packages alsa-utils discord firefox git gtk3 kitty libnotify lxappearance neofetch neovim notification-daemon obsidian pipewire pipewire-alsa pipewire-pulse wireplumber pavucontrol
install_pacman_packages rofi scrot tree ttf-jetbrains-mono-nerd unzip xclip xorg-server-xephyr yazi udiskie ntfs-3g network-manager-applet
sudo pacman -S pulseaudio pavucontrol

# Set up dotfiles
git clone https://github.com/jrubcor/dotfiles "$TEMP_DIR/dotfiles"
cp -r "$TEMP_DIR/dotfiles/qtile/"* "$HOME/.config/qtile/"
cp -r  "$TEMP_DIR/dotfiles/rofi/"* "$HOME/.config/rofi/"
cp -r  "$TEMP_DIR/dotfiles/kitty/"* "$HOME/.config/kitty/"
cp -r  "$TEMP_DIR/dotfiles/nvim/"* "$HOME/.config/nvim/"

# Clean up temporary directory
rm -rf "$TEMP_DIR"

# Configure git
git config --global user.name "$name"
git config --global user.email "$email"

# Confirmation message
echo "Git configuration updated successfully!"
echo "User Name: $(git config --global user.name)"
echo "User Email: $(git config --global user.email)"

# grub, lightdm, gtk, dotfiles bashrc, 
    # Create this file with nano or vim
    # sudo nano /usr/share/dbus-1/services/org.freedesktop.Notifications.service
    # Paste these lines
# [D-BUS Service]
# Name=org.freedesktop.Notifications
# Exec=/usr/lib/notification-daemon-1.0/notification-daemon
