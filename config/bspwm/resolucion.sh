#!/bin/bash

monitores=($(xrandr | grep -w "connected" | awk '{print $1}'))
for monitor in "${monitores[@]}"; do
  resolucion=$(xrandr | grep -A 1 "$monitor" | grep -oP '\d+x\d+')
  xrandr --output "$monitor" --mode "$resolucion"
done
