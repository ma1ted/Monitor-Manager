#!/bin/bash

SLEEPTIME=0.1

MOUSE_ID=17
TOP=9
BOTTOM=8

PRIMARY_MONITOR=eDP-1
SECONDARY_MONITOR=HDMI-1

PREVIOUS_CONNECTED=

while [ true ]
do
	sleep $SLEEPTIME
	CURRENT_CONNECTED=$(xrandr --query | grep -c " connected ")
	if [ "$CURRENT_CONNECTED" != "$PREVIOUS_CONNECTED" ]
	then
		echo "Monitor was connected/disconnected. Was $PREVIOUS_CONNECTED, now $CURRENT_CONNECTED"	
		xrandr --output $PRIMARY_MONITOR --auto --output $SECONDARY_MONITOR --auto --right-of $PRIMARY_MONITOR
	fi
	PREVIOUS_CONNECTED=$CURRENT_CONNECTED

	if [[ $(xrandr --query | grep $SECONDARY_MONITOR | cut -d ' ' -f 2) == "connected" ]]
	then
		if [[ $(xinput --query-state $MOUSE_ID | grep "button\[$TOP" | cut -d '=' -f 2) == "down" ]]
		then
			if [[ $(xrandr --query --verbose | grep $SECONDARY_MONITOR | cut -d ' ' -f 5) != "normal" ]]
			then
				xrandr --output $SECONDARY_MONITOR --rotate normal
			fi
		elif [[ $(xinput --query-state $MOUSE_ID | grep "button\[$BOTTOM" | cut -d '=' -f 2) == "down" ]]
		then
			if [[ $(xrandr --query --verbose | grep $SECONDARY_MONITOR | cut -d ' ' -f 5) != "left" ]]
			then
				xrandr --output $SECONDARY_MONITOR --rotate left
			fi
		fi
	fi
done
