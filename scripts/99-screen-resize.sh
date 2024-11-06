#!/bin/bash

while true; do
	# Wait for any randr event
	xev -root -event randr | while read line; do killall -q xev; done
	# Resize the screen
	xrandr --output None-0 --off
	xrandr --auto
	if [ -f ~/.fehbg ]; then
		~/.fehbg &
	fi
done &
