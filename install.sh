#!/bin/bash
# Install omarchy-stickynote for the current user during local development.
# Optional Hyprland keybind, autostart and window rules are documented in README.md.
set -euo pipefail

REPO="$(dirname "$(readlink -f "$0")")"
BIN_DIR="$HOME/.local/bin"
APP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
ICON_ROOT="${XDG_DATA_HOME:-$HOME/.local/share}/icons/hicolor"
mkdir -p "$BIN_DIR"

for f in omarchy-stickynote omarchy-stickynote-toggle omarchy-stickynote-waybar; do
  chmod +x "$REPO/$f"
  ln -sf "$REPO/$f" "$BIN_DIR/$f"
  echo "linked: $BIN_DIR/$f -> $REPO/$f"
done

mkdir -p "$APP_DIR"
ln -sf "$REPO/data/com.omarchy.stickynote.desktop" \
  "$APP_DIR/com.omarchy.stickynote.desktop"

rm -f "$ICON_ROOT/scalable/apps/com.omarchy.stickynote.svg"
for size in 32x32 48x48 64x64 128x128 256x256 512x512; do
  icon_dir="$ICON_ROOT/$size/apps"
  mkdir -p "$icon_dir"
  ln -sf "$REPO/data/icons/hicolor/$size/apps/com.omarchy.stickynote.png" \
    "$icon_dir/com.omarchy.stickynote.png"
done

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$APP_DIR"
fi
echo
echo "Done. The app is now searchable as 'Sticky Notes' in the launcher."
echo "See README.md for the optional Hyprland and Waybar snippets."
