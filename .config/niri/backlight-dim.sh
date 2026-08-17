#!/bin/sh
# usage: backlight-dim.sh <target_percent|restore> <device>
device="$2"
STATE_FILE="$HOME/.config/niri/scripts/tempfiles/brightness-before-dim-${device//[:\/]/_}"
target="$1"

get()  { brightnessctl -d "$device" get; }
maxb() { brightnessctl -d "$device" max; }
set_pct() { brightnessctl -d "$device" set "$1%" -q; }

max=$(maxb)

if [ "$target" = "restore" ]; then
    if [ -f "$STATE_FILE" ]; then
        target_pct=$(cat "$STATE_FILE")
        rm -f "$STATE_FILE"
    else
        target_pct=100
    fi
else
    current_pct=$(( $(get) * 100 / max ))
    echo "$current_pct" > "$STATE_FILE"
    target_pct="$target"
fi

current_pct=$(( $(get) * 100 / max ))
steps=20
step_delta=$(( (target_pct - current_pct) / steps ))

for i in $(seq 1 $steps); do
    set_pct "$((current_pct + step_delta * i))"
    sleep 0.03
done
