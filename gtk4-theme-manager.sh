#!/bin/bash

# Define paths
THEME_DIR="$HOME/.themes"
CONFIG_DIR="$HOME/.config/gtk-4.0"

  cat <<"EOF"
   ____ _____ _  __  _  _   
  / ___|_   _| |/ / | || |  
 | |  _  | | | ' /  | || |_ 
 | |_| | | | | . \  |__   _|
  \____| |_| |_|\_\    |_|  
           
EOF

echo -e "\n\e[2mThemes Manager | ▲ Up  ▼ Down  ↵ Enter: Submit ESC: Exit\e[0m"

# Your specific list of themes
THEMES=("WhiteSur-Dark" "WhiteSur-Light" "Catppuccin-Light" "Rosepine-Dark" "Rosepine-Light" "Tokyonight-Dark" "Tokyonight-Light" "Tokyonight-MacOS-Dark")

# Use printf to pass the array to fzf
CHOICE=$(printf "%s\n" "${THEMES[@]}" | fzf --prompt="Select GTK4 Theme: " --height=40% --reverse)

# Exit if no selection was made (e.g., user pressed ESC)
if [ -z "$CHOICE" ]; then
    echo "No theme selected. Exiting."
    exit 0
fi

SOURCE_PATH="$THEME_DIR/$CHOICE/gtk-4.0"

# Check if the source folder actually exists
if [ -d "$SOURCE_PATH" ]; then
    echo "Applying $CHOICE..."

    # Create config dir if it doesn't exist
    mkdir -p "$CONFIG_DIR"

    # Copy the specific files/folders required for GTK4
    # We use -r for the assets folder and -f to overwrite
    cp -rf "$SOURCE_PATH/assets" "$CONFIG_DIR/"
    cp -f "$SOURCE_PATH/gtk.css" "$CONFIG_DIR/"
    cp -f "$SOURCE_PATH/gtk-dark.css" "$CONFIG_DIR/"

    # Get the current color scheme preference
    CURRENT_SCHEME=$(gsettings get org.gnome.desktop.interface color-scheme)

    # Toggle it to force a reload
    gsettings set org.gnome.desktop.interface color-scheme 'default'
    sleep 0.1
    gsettings set org.gnome.desktop.interface color-scheme "$CURRENT_SCHEME"

    # Also update the legacy GTK3 theme name to match (optional but recommended)
    gsettings set org.gnome.desktop.interface gtk-theme "$CHOICE"

    echo "Theme applied successfully!"
else
    echo "Error: Could not find gtk-4.0 folder in $SOURCE_PATH"
    exit 1
fi