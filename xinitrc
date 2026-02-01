#!/bin/sh

prefix="/usr"
exec_prefix="${prefix}"
xrdb="xrdb"
xinitdir="/etc/X11/xinit"
xclock="xclock"
xterm="xterm"
twm="twm"
xmodmap="xmodmap"

userresources="$HOME/.Xresources"
usermodmap="$HOME/.Xmodmap"
sysresources="$xinitdir/.Xresources"
sysmodmap="$xinitdir/.Xmodmap"

# merge in defaults and keymaps

if [ -f "$sysresources" ]; then
    if [ -x /usr/bin/cpp ] ; then
        "$xrdb" -merge "$sysresources"
    else
        "$xrdb" -nocpp -merge "$sysresources"
    fi
fi

if [ -f "$sysmodmap" ]; then
    "$xmodmap" "$sysmodmap"
fi

if [ -f "$userresources" ]; then
    if [ -x /usr/bin/cpp ] ; then
        "$xrdb" -merge "$userresources"
    else
        "$xrdb" -nocpp -merge "$userresources"
    fi
fi

if [ -f "$usermodmap" ]; then
    "$xmodmap" "$usermodmap"
fi

# start some nice programs

if [ -d "$xinitdir"/xinitrc.d ] ; then
	for f in "$xinitdir/xinitrc.d"/?*.sh ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

# Dwm status bar
/home/byte/dwm/dwm-bar/dwm_bar.sh &

# Remove mouse acceleration
# Make sure to change 9 to device number
# Use xinput list
xinput set-prop "9" "libinput Accel Profile Enabled" 0 1 0

# Make mouse speed faster
# Make sure to change name to name
xinput --set-prop "Elan Touchpad" "libinput Accel Speed" 0.5
# "$twm" &
# "$xclock" -geometry 50x50-1+1 &
# "$xterm" -geometry 80x50+494+51 &
# "$xterm" -geometry 80x20+494-0 &
# exec "$xterm" -geometry 80x66+0+0 -name login
exec dwm
