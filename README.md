# omarchy-stickynote

A native floating checklist for Omarchy and Hyprland. It looks and behaves like
a small yellow sticky note: type at the top, press **Enter**, and the text becomes
a checkbox item. Complete an item and it disappears. Changes are saved locally
as soon as they happen.

- **Native:** GTK4 with Python and PyGObject—no Electron, with instant startup.
- **Regular floating window:** opens on the current workspace without dimming the
  screen, stealing focus from other tiles, or changing your `SUPER+G` behavior.
- **Show/hide toggle:** `SUPER + CTRL + S`, or click the Waybar icon.
- **Waybar tray icon:** stays collapsed with icons such as Slack, shows the number
  of pending notes, toggles the app on click, and refreshes through `SIGRTMIN+11`.
- **Local persistence:** `~/.local/share/omarchy-stickynote/notes.json`, written
  atomically.
- **Escape:** hides the note.
- **Multiline notes:** `Shift+Enter` inserts a line break; `Enter` creates the note.
- **Visual feedback:** smooth entry and a quick sparkle burst from the checkbox
  when completing a task.

## Installation

### Arch Linux / Omarchy package

```bash
curl -LO https://github.com/Christopher-Moreira/omarchy-stickynote/releases/download/v1.0.5/omarchy-stickynote-1.0.5-1-any.pkg.tar.zst
sudo pacman -U omarchy-stickynote-1.0.5-1-any.pkg.tar.zst
```

After installation, press `SUPER + SPACE` and search for **Sticky Notes**. The
package installs an XDG desktop entry in `/usr/share/applications`, so it also
works with other compatible application launchers.

The AUR recipe is ready under `packaging/aur`. Publishing is pending because
new AUR account registration is temporarily closed; the package will move to
the regular `yay -S omarchy-stickynote` flow when registrations reopen.

### Manual release

Download `omarchy-stickynote-1.0.5.tar.gz` from the releases page, extract it,
and run:

```bash
./install.sh
```

### Local development

```bash
git clone https://github.com/Christopher-Moreira/omarchy-stickynote.git
cd omarchy-stickynote
./install.sh
```

The installer links the three executables into `~/.local/bin` and installs the
desktop entry and icon under `~/.local/share`, making the app searchable right
away.

## Hyprland setup

Add the following personal window rules to the end of
`~/.config/hypr/hyprland.conf`:

```conf
windowrule = float on,                        match:class ^com\.omarchy\.stickynote$
windowrule = size 360 440,                    match:class ^com\.omarchy\.stickynote$
windowrule = move (monitor_w-window_w-24) 24, match:class ^com\.omarchy\.stickynote$
windowrule = rounding 16,                     match:class ^com\.omarchy\.stickynote$
windowrule = opacity 1 1,                     match:class ^com\.omarchy\.stickynote$
```

In `~/.config/hypr/bindings.conf`, replace Omarchy's default
`SUPER + CTRL + S` Share binding:

```conf
unbind = SUPER CTRL, S
bindd = SUPER CTRL, S, Sticky note, exec, omarchy-stickynote-toggle
```

Start a hidden resident instance at login from
`~/.config/hypr/autostart.conf`:

```conf
exec-once = uwsm-app -- ~/.local/bin/omarchy-stickynote --hidden
```

Apply the changes with `hyprctl reload`.

## Waybar setup

Add the module below to `~/.config/waybar/config.jsonc`, then place it inside
`group/tray-expander` next to the tray:

```jsonc
"custom/stickynote": {
  "exec": "~/.local/bin/omarchy-stickynote-waybar",
  "return-type": "json",
  "interval": 3600,
  "signal": 11,
  "on-click": "~/.local/bin/omarchy-stickynote-toggle",
  "tooltip": true
}
```

```jsonc
"group/tray-expander": {
  "modules": ["custom/expand-icon", "custom/stickynote", "tray"]
}
```

Optional CSS for `~/.config/waybar/style.css`:

```css
#custom-stickynote { min-width: 12px; margin: 0 7.5px; }
#custom-stickynote.empty { opacity: 0.55; }
```

Restart Waybar with `omarchy restart waybar`.

## Usage

- `SUPER + SPACE`, then search for **Sticky Notes**—open from the launcher.
- `SUPER + CTRL + S`, or click the Waybar icon—show or hide the note.
- Type and press `Enter`—add an item.
- Press `Shift + Enter`—insert a line break without creating another item.
- Click a checkbox—complete and remove the item.
- Click the pencil icon—edit an item; click the confirmation icon or press
  `Ctrl + Enter` to save, or press `Escape` to cancel.
- Drag an item from its three-bar handle—reorder the checklist and save the new
  order immediately.
- Press `Escape`—hide the note.

## Command line

```text
omarchy-stickynote            open and show the note
omarchy-stickynote --hidden   start resident and hidden for autostart
omarchy-stickynote --toggle   show or hide the running instance
omarchy-stickynote --show
omarchy-stickynote --hide
```

## Development and releases

```bash
make test
make dist VERSION=1.0.5
```

`packaging/aur/PKGBUILD` contains the Arch/AUR package recipe. Releases use
`vX.Y.Z` tags and the deterministic tarball produced by `make dist`.

## License

[MIT](LICENSE) © 2026 Christopher Moreira.
