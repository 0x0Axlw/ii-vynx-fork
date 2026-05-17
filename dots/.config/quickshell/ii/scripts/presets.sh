#!/usr/bin/env bash

PRESETS_DIR="$HOME/.config/illogical-impulse/presets"
CONFIG_FILE="$HOME/.config/illogical-impulse/config.json"
mkdir -p "$PRESETS_DIR"

action=$1
name=$2

case $action in
    save)
        if [[ -z "$name" ]]; then exit 1; fi
        cp "$CONFIG_FILE" "$PRESETS_DIR/$name.json"
        ;;
    load)
        if [[ -z "$name" ]]; then exit 1; fi
        if [[ -f "$PRESETS_DIR/$name.json" ]]; then
            cp "$PRESETS_DIR/$name.json" "$CONFIG_FILE"
            
            # Apply wallpaper and colors from the newly loaded config
            env -u LD_LIBRARY_PATH -u PYTHONHOME -u PYTHONPATH PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH" "$HOME/.config/quickshell/ii/scripts/colors/switchwall.sh" --noswitch > /tmp/presets_switchwall.log 2>&1 &
        fi
        ;;
    delete)
        if [[ -z "$name" ]]; then exit 1; fi
        rm -f "$PRESETS_DIR/$name.json"
        ;;
    list)
        for file in "$PRESETS_DIR"/*.json; do
            if [[ ! -f "$file" ]]; then continue; fi
            filename=$(basename "$file" .json)
            # get wallpaper path from json
            wall=$(jq -r '.background.wallpaperPath // ""' "$file" 2>/dev/null)
            echo "{\"name\": \"$filename\", \"wallpaper\": \"$wall\"}"
        done
        ;;
esac
