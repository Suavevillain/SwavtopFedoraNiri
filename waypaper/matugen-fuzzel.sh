#!/usr/bin/env bash
# ~/.config/waypaper/matugen-fuzzel.sh
# Called by Waypaper post_command

WALLPAPER="$1"
CONFIG="$HOME/.config/matugen/config.toml"
STATE_FILE="$HOME/.config/matugen/last_state"
LOG="$HOME/.config/matugen/matugen-post.log"

mkdir -p "$(dirname "$STATE_FILE")"
mkdir -p "$(dirname "$LOG")"

echo "---- Waypaper Post Command ----" >> "$LOG"
echo "Wallpaper: $WALLPAPER" >> "$LOG"

if [ -z "$WALLPAPER" ]; then
    echo "No wallpaper provided!" >> "$LOG"
    exit 1
fi

# --- Persist GTK theme so nwg-look settings survive ---
mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0
cat > ~/.config/gtk-3.0/settings.ini <<EOF
[Settings]
gtk-theme-name=Adwaita
gtk-icon-theme-name=Papirus
gtk-application-prefer-dark-theme=1
EOF
cp ~/.config/gtk-3.0/settings.ini ~/.config/gtk-4.0/settings.ini
echo "GTK settings persisted" >> "$LOG"

# --- Load saved Matugen scheme ---
if [ -f "$STATE_FILE" ]; then
    SAVED_WALLPAPER=$(cut -d '|' -f1 "$STATE_FILE")
    SAVED_SCHEME=$(cut -d '|' -f2 "$STATE_FILE")
else
    SAVED_WALLPAPER=""
    SAVED_SCHEME=""
fi

# --- Pick Matugen colorscheme if needed ---
if [ "$WALLPAPER" != "$SAVED_WALLPAPER" ] || [ -z "$SAVED_SCHEME" ]; then
    SCHEME=$(printf "scheme-content\nscheme-expressive\nscheme-fidelity\nscheme-fruit-salad\nscheme-monochrome\nscheme-neutral\nscheme-rainbow\nscheme-tonal-spot\nscheme-vibrant" \
              | fuzzel --dmenu --prompt "Pick Matugen colorscheme:")
    [ -z "$SCHEME" ] && exit 0
    echo "$WALLPAPER|$SCHEME" > "$STATE_FILE"
else
    SCHEME="$SAVED_SCHEME"
fi
echo "Selected scheme: $SCHEME" >> "$LOG"

# --- Pick source colors (optional) ---
if command -v convert >/dev/null 2>&1; then
    COLORS=$(convert "$WALLPAPER" -resize 50x50 -format %c -depth 8 histogram:info:- \
             | sort -nr | head -n5 | awk '{print $3}')
else
    COLORS="#c55e53\n#9e943c\n#6751a5\n#3b88ff\n#ffd700"
fi

# --- Run Matugen interactively in Kitty ---
# Export GTK settings so child terminal inherits them
export GTK_THEME=Adwaita
export XDG_CURRENT_DESKTOP=sway

kitty sh -c "matugen image '$WALLPAPER' -t '$SCHEME' -c '$CONFIG' -v"
if [ $? -eq 0 ]; then
    echo "Matugen ran successfully in Kitty" >> "$LOG"
else
    echo "Matugen FAILED" >> "$LOG"
fi

# --- Set wallpaper last ---
if command -v swww >/dev/null 2>&1; then
    sleep 0.2  # tiny delay to avoid race with GTK apps
    swww img "$WALLPAPER" >> "$LOG" 2>&1
    echo "Wallpaper set via swww" >> "$LOG"
fi

echo "---- Done ----" >> "$LOG"
