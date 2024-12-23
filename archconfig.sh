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
install_pacman_packages alsa-utils discord git gtk3 kitty libnotify lxappearance neofetch neovim notification-daemon obsidian pipewire pipewire-alsa pipewire-pulse wireplumber pavucontrol
install_pacman_packages python-psutil rofi scrot tree ttf-jetbrains-mono-nerd unzip xclip xorg-server-xephyr yazi udiskie ntfs-3g network-manager-applet

install_yay_packages spotify zen-browser-bin


# Set up dotfiles
git clone --depth 1 https://github.com/jrubcor/dotfiles "$TEMP_DIR/dotfiles"

# Prompt the user
read -p "Do you wwant to remove your old directories? (Better for a clean installation) (y/n)" user_choice
case "$user_choice" in
    y|Y|yes|YES)
        rm -r "$HOME/.config/qtile/"
        rm -r "$HOME/.config/rofi/"
        rm -r "$HOME/.config/kitty/"
        ;;
    n|N|no|NO)
        echo "Directories weren't removed"
        ;;
    *)
        echo "Invalid input. Please enter 'y' or 'n'."
        ;;
esac

if [ ! -d "$HOME/.config/qtile/" ]; then
    mkdir "$HOME/.config/qtile/"
else
    echo "~/.config/qtile directory already exists"
fi

if [ ! -d "$HOME/.config/kitty/" ]; then
    mkdir "$HOME/.config/kitty/"
else
    echo "~/.config/kitty's directory already exists"
fi

if [ ! -d "$HOME/.config/rofi/" ]; then
    mkdir "$HOME/.config/rofi/"
else
    echo "~/.config/rofi directory already exists"
fi

if [ ! -d "$HOME/.local/share/rofi/themes" ]; then
    mkdir "$HOME/.local/share/rofi/themes"
else
    echo "~/.local/share/rofi/themes's directory already exists"
fi
cp -r "$TEMP_DIR/dotfiles/.config/qtile/"* "$HOME/.config/qtile/"
cp -r "$TEMP_DIR/dotfiles/.config/rofi/"* "$HOME/.config/rofi/"
cp -r "$TEMP_DIR/dotfiles/.local/share/rofi/themes/"* "$HOME/.local/share/rofi/themes/"
cp -r "$TEMP_DIR/dotfiles/.config/kitty/"* "$HOME/.config/kitty/"
cp -r "$TEMP_DIR/dotfiles/.config/gtk-3.0/"* "$HOME/.config/gtk-3.0/"

read -p "Do you want to replace .bashrc and .xprofile with the new config? (y/n): " user_choice
case "$user_choice" in
    y|Y|yes|YES)
        cp "$TEMP_DIR/dotfiles/.bashrc" "$HOME"
        cp "$TEMP_DIR/dotfiles/.xprofile" "$HOME"
        ;;
    n|N|no|NO)
        echo "Not replacing..."
        ;;
esac 

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
        echo "Not installing/reinstalling Astronvim..."
        ;;
    *)
        echo "Invalid input. Please enter 'y' or 'n'."
        ;;
esac

if [ ! -d /usr/share/themes/Tokyonight-Dark/ ]; then
    (cd "$TEMP_DIR/dotfiles/usr/share/themes/" && unzip "$TEMP_DIR/dotfiles/usr/share/themes/Tokyonight-Dark-BL-MB.zip")
    sudo cp -r "$TEMP_DIR/dotfiles/usr/share/themes/Tokyonight-Dark" "/usr/share/themes/"
else
    echo "Tokyonight already exists"
fi

if [ ! -d /usr/share/themes/Tokyonight-Light/ ]; then
    (cd "$TEMP_DIR/dotfiles/usr/share/themes/" && unzip "$TEMP_DIR/dotfiles/usr/share/themes/Tokyonight-Light-BL-MB.zip")
    sudo cp -r "$TEMP_DIR/dotfiles/usr/share/themes/Tokyonight-Light" "/usr/share/themes/"
else
    echo "Tokyonight already exists"
fi

if [ ! -d /usr/share/icons/Reversal-blue-dark/ ]; then
    (cd "$TEMP_DIR/dotfiles/usr/share/icons/" && tar -xvf "$TEMP_DIR/dotfiles/usr/share/icons/Reversal-blue.tar.xz")
    sudo cp -r "$TEMP_DIR/dotfiles/usr/share/icons/Reversal-blue-dark" "/usr/share/icons/"
else
    echo "Reversal-blue-dark already exists"
fi

''''''''''''''''''''''''''''''''''''
sudo cp "$TEMP_DIR/dotfiles/usr/share/pixmaps/"* "/usr/share/pixmaps/"
sudo cp "$TEMP_DIR/dotfiles/etc/lightdm/lightdm.conf" "/etc/lightdm/"
sudo cp "$TEMP_DIR/dotfiles/etc/lightdm/lightdm-gtk-greeter.conf" "/etc/lightdm/"

# GRUB
(cd "$TEMP_DIR" && git clone https://github.com/catppuccin/grub.git)
(cd "$TEMP_DIR" && cd grub && sudo cp -r src/* /usr/share/grub/themes/)

THEME_PATH="/usr/share/grub/themes/catppuccin-mocha-grub-theme/theme.txt"
BACKGROUND_PATH="/usr/share/pixmaps/land.png"
GRUB_CONFIG="/etc/default/grub"

# Check if the theme file exists
if [ ! -f "$THEME_PATH" ]; then
    echo "Error: Theme file not found at $THEME_PATH"
    exit 1
fi

if [ ! -f "$BACKGROUND_PATH" ]; then
    echo "Error: Background file not found at $BACKGROUND_PATH"
    exit 1
fi

# Update or add the GRUB_THEME line in the GRUB config
if grep -q "^#\? *GRUB_THEME=" "$GRUB_CONFIG"; then
    sudo sed -i "s|^GRUB_THEME=.*|GRUB_THEME=\"$THEME_PATH\"|" "$GRUB_CONFIG"
else
    echo "GRUB_THEME=\"$THEME_PATH\"" | sudo tee -a "$GRUB_CONFIG"
fi

# Update or add the GRUB_BACKGROUND line in the GRUB config
if grep -q "^#\? *BACKGROUND=" "$GRUB_CONFIG"; then
    sudo sed -i "s|^#\? *GRUB_BACKGROUND=.*|GRUB_BACKGROUND=\"$BACKGROUND_PATH\"|" "$GRUB_CONFIG"
else
    echo "GRUB_BACKGROUND=\"$BACKGROUND_PATH\"" | sudo tee -a "$GRUB_CONFIG"
fi

# Update GRUB
echo "Updating GRUB configuration..."
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "GRUB theme set to Catppuccin ${FLAVOR}!"

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
