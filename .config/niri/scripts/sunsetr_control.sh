#!/bin/bash

TOGGLE_FILE="$HOME/.config/niri/scripts/tempfiles/.sunsetr_status"
MODE="$1"

get_status() {
    if [ -f "$TOGGLE_FILE" ]; then
        echo '{"text": "󱁞 ", "tooltip": "Night light: ON", "class": "on"}'
    else
        echo '{"text": "󰖔 ", "tooltip": "Night light: OFF", "class": "off"}'
    fi
}

case "$MODE" in
    "toggle")
        if [ -f "$TOGGLE_FILE" ]; then
            rm "$TOGGLE_FILE"
            pkill -x sunsetr 2>/dev/null
        else
            touch "$TOGGLE_FILE"
            pkill -x sunsetr 2>/dev/null
            nohup /usr/bin/sunsetr >/dev/null 2>&1 &
        fi
        pkill -RTMIN+9 waybar
        ;;
    *)
        get_status
        ;;
esac
