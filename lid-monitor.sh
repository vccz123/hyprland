#!/bin/bash

# Prüfe den Status des Laptop-Deckels
if grep -q open /proc/acpi/button/lid/LID0/state; then
    # Deckel ist offen - aktiviere beide Monitore
    hyprctl keyword monitor "eDP-1,1920x1080@60,0x0,1"
    hyprctl keyword monitor "HDMI-A-1,1920x1080@60,1920x0,1"
else
    # Deckel ist geschlossen - deaktiviere Laptop-Display, behalte externen Monitor
    hyprctl keyword monitor "eDP-1, disable"
    hyprctl keyword monitor "HDMI-A-1,1920x1080@60,0x0,1"
fi
