#!/bin/bash

# $HOME/.config
cp -r ~/.config/kitty ~/Repositories/dotfiles/.config/
cp -r ~/.config/nvim ~/Repositories/dotfiles/.config/
cp -r ~/.config/qtile ~/Repositories/dotfiles/.config/
cp -r ~/.config/rofi ~/Repositories/dotfiles/.config/
cp -r ~/.config/gtk-3.0/ ~/Repositories/dotfiles/.config/

# $HOME/.local
cp -r ~/.local/share/rofi/themes/ ~/Repositories/dotfiles/.local/share/rofi/

# /etc
cp -r /etc/lightdm/lightdm.conf ~/Repositories/dotfiles/etc/lightdm/
cp -r /etc/lightdm/lightdm-gtk-greeter.conf ~/Repositories/dotfiles/etc/lightdm/

# $HOME
cp ~/.bashrc ~/Repositories/dotfiles/
