#!/bin/bash
# Instala o omarchy-stickynote no usuário para desenvolvimento local.
# As edições do Hyprland (keybind, autostart, window rules) estão no README
# e devem ser adicionadas aos seus arquivos em ~/.config/hypr/.
set -euo pipefail

REPO="$(dirname "$(readlink -f "$0")")"
BIN_DIR="$HOME/.local/bin"
APP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
ICON_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/icons/hicolor/scalable/apps"
mkdir -p "$BIN_DIR"

for f in omarchy-stickynote omarchy-stickynote-toggle omarchy-stickynote-waybar; do
  chmod +x "$REPO/$f"
  ln -sf "$REPO/$f" "$BIN_DIR/$f"
  echo "linkado: $BIN_DIR/$f -> $REPO/$f"
done

mkdir -p "$APP_DIR" "$ICON_DIR"
ln -sf "$REPO/data/com.omarchy.stickynote.desktop" \
  "$APP_DIR/com.omarchy.stickynote.desktop"
ln -sf "$REPO/data/icons/hicolor/scalable/apps/com.omarchy.stickynote.svg" \
  "$ICON_DIR/com.omarchy.stickynote.svg"

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$APP_DIR"
fi

echo
echo "Pronto. O app já pode ser buscado como 'Sticky Notes' no launcher."
echo "Veja o README.md para os snippets opcionais do Hyprland e Waybar."
