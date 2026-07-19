#!/bin/sh

STATE=$(niri msg outputs | awk '/LVDS-1/{f=1} f && /Transform:/{print $2; exit}')

niri msg output LVDS-1 off

if [ "$STATE" = "normal" ]; then
    ln -sf ~/.config/waybar/style-side.css ~/.config/waybar/style.css
    pkill -SIGUSR2 waybar
    niri msg output LVDS-1 transform 270
else
    ln -sf ~/.config/waybar/style-normal.css ~/.config/waybar/style.css
    pkill -SIGUSR2 waybar
    niri msg output LVDS-1 transform normal
fi

niri msg output LVDS-1 on
