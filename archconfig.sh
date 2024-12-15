#!/bin/bash

# Vars
TEMP_DIR=$(mktemp -d) || { echo "Failed to create temp directory"; exit 1; }

# Install yay
if ! pacman -Q "yay"; then
    git clone https://aur.archlinux.org/yay-git.git "$TEMP_DIR/yay-git/" || { echo "Failed to clone repo"; exit 1; }
    cd "$TEMP_DIR/yay-git/" || { echo "Failed to enter directory"; exit 1; }
    makepkg -si || { echo "Build and install failed"; exit 1; }
else
    echo "yay is already installed"
fi

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

# Function to install pacman packages
install_yay_packages() {
    for package in "$@"; do
        if ! yay -Q "$package" &>/dev/null; then
            echo "Installing $package..."
            yay -S --noconfirm "$package"
        else
            echo "$package is already installed"
        fi
    done
}

# Install required packages
install_pacman_packages alsa-utils discord firefox git gtk3 kitty libnotify lxappearance neofetch neovim notification-daemon obsidian pipewire pipewire-alsa pipewire-pulse wireplumber pavucontrol
install_pacman_packages rofi scrot tree ttf-jetbrains-mono-nerd unzip xclip xorg-server-xephyr yazi udiskie ntfs-3g network-manager-applet

install_yay_packages spotify


# Set up dotfiles
git clone https://github.com/jrubcor/dotfiles "$TEMP_DIR/dotfiles"
rm -r "$HOME/.config/qtile/"
rm -r "$HOME/.config/rofi/"
rm -r "$HOME/.config/kitty/"

mkdir "$HOME/.config/qtile/"
mkdir "$HOME/.config/rofi/"
mkdir "$HOME/.config/kitty/"

cp -r "$TEMP_DIR/dotfiles/.config/qtile/"* "$HOME/.config/qtile/"
cp -r "$TEMP_DIR/dotfiles/.config/rofi/"* "$HOME/.config/rofi/"
cp -r "$TEMP_DIR/dotfiles/.local/share/rofi/themes/" "$HOME/.local/share/rofi/"
cp -r "$TEMP_DIR/dotfiles/.config/kitty/"* "$HOME/.config/kitty/"
cp -r "$TEMP_DIR/dotfiles/.config/gtk-3.0/"* "$HOME/.config/gtk-3.0/"
cp "$TEMP_DIR/dotfiles/.bashrc" "$HOME"

# Prompt the user
read -p "Do you want to download and install AstroNvim? (y/n): " user_choice

case "$user_choice" in
    y|Y|yes|YES)
        rm -r "$HOME/.config/nvim/"
        mkdir "$HOME/.config/nvim/"
        echo "Installing AstroNvim..."
        # Clone the AstroNvim template repository
        git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim || {
            echo "Failed to clone AstroNvim template repository.";
            exit 1;
        }

        # Remove the template's Git connection
        rm -rf ~/.config/nvim/.git || {
            echo "Failed to remove Git history from AstroNvim template.";
            exit 1;
        }

        # Copy user dotfiles into AstroNvim's configuration directory
        if [ -d "$TEMP_DIR/dotfiles/.config/nvim/" ]; then
            cp -r "$TEMP_DIR/dotfiles/.config/nvim/"* "$HOME/.config/nvim/" || {
                echo "Failed to copy dotfiles into AstroNvim configuration.";
                exit 1;
            }
        else
            echo "Dotfiles directory not found: $TEMP_DIR/dotfiles/.config/nvim/";
        fi
        echo "AstroNvim has been successfully installed and configured."
        ;;
    n|N|no|NO)
        echo "Okay bro..."
        ;;
    *)
        echo "Invalid input. Please enter 'y' or 'n'."
        ;;
esac

if [ ! -d /usr/share/themes/Catppuccin-Dark/ ]; then
    (cd "$TEMP_DIR/dotfiles/themes/" && unzip "$TEMP_DIR/dotfiles/themes/Catppuccin-Dark-BL-MB.zip")
    sudo cp -r "$TEMP_DIR/dotfiles/themes/Catppuccin-Dark" "/usr/share/themes/"
else
    echo "Catppuccin-Dark already exists"
fi
""""

# Clean up temporary directory
rm -rf "$TEMP_DIR"

# Git config
echo "Write your git user name: "
read -r name
echo "Write your git user email: "
read -r email

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
#
# Para cambiar lightdm basta con agregar el tema gtk /ush/share/themes y luego en /etc/lightdm/lightdm-gtk... buscar theme y poner el nombre del tema a poner, ojo tienes que descompentar también [greeter]
