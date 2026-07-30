#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/Dotfiles"

clear

echo "============================================================"
echo "  ⚠️  WARNING: NETWORK MANAGER / IWD CONFIGURATION NOTICE ⚠️"
echo "============================================================"
echo " This setup relies on iwd for wireless networking instead of"
echo " NetworkManager. "
echo ""
echo " Before running this, ensure NetworkManager is stopped/disabled"
echo " and iwd is enabled, or your Wi-Fi will disconnect:"
echo ""
echo "   sudo systemctl stop NetworkManager"
echo "   sudo systemctl disable NetworkManager"
echo "   sudo systemctl enable --now iwd.service"
echo "============================================================"
echo ""

read -p "Press [ENTER] to acknowledge and continue installation, or Ctrl+C to exit..."

echo ""
echo "🚀 Starting Arch setup..."

echo "📦 Installing core packages..."
sudo pacman -S --needed --noconfirm \
	hyprland \
	fish \
	kitty \
	neofetch \
	ranger \
	rofi \
	swaync \
	waybar \
	starship \
	iwd \
	impala \
	bluetui \
	awww

echo "📁 Setting up ~/.config directories..."
mkdir -p "$HOME/.config"

echo "🔗 Symlinking dotfiles..."

CONFIGS=("fish" "hypr" "kitty" "neofetch" "ranger" "rofi" "swaync" "waybar")

for cfg in "${CONFIGS[@]}"; do
    if [ -d "$DOTFILES_DIR/.config/$cfg" ]; then
        echo "   -> Linking $cfg"
        rm -rf "$HOME/.config/$cfg"
        ln -sf "$DOTFILES_DIR/.config/$cfg" "$HOME/.config/$cfg"
    fi
done

if [ -f "$DOTFILES_DIR/.config/starship.toml" ]; then
    echo "   -> Linking starship.toml"
    ln -sf "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"
fi

echo "🖼️ Setting wallpaper via awww..."
if [ -d "$DOTFILES_DIR/Wallpaper" ]; then
    WALLPAPER_FILE=$(find "$DOTFILES_DIR/Wallpaper" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) | head -n 1)

    if [ -n "$WALLPAPER_FILE" ]; then
        awww-daemon >/dev/null 2>&1 &
        sleep 1
        awww img "$WALLPAPER_FILE" --transition-type simple
        echo "   -> Applied wallpaper: $(basename "$WALLPAPER_FILE")"
    fi
fi

echo "🌐 Enabling Bluetooth service..."
sudo systemctl enable --now bluetooth.service || true

if [ "$SHELL" != "$(which fish)" ]; then
    echo "🐟 Changing default shell to Fish..."
    chsh -s "$(which fish)"
fi

echo ""
echo "✨ All done! System is fully configured and wallpaper applied."
