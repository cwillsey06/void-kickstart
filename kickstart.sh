#!/bin/sh -e
# [void-]kickstart.sh

# This is free and unencumbered software released into the public domain.
 
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.

# For more information, please refer to <https://unlicense.org>

PKGS="pipewire alsa-pipewire wireplumber dbus-elogind polkit git clang clang-tools-extra meson ninja ccache curl autoconf automake make ncurses ncurses-devel pkg-config bc xorg-minimal xorg-server xorg-fonts firefox neovim mpv xtools xclip ranger scrot tmux gimp zsh"

elevate () {
	if [ "$(whoami)" = 'root' ]; then
		"$*"
	else
		su -c "$*"
	fi
}

install_pkgs () {
	elevate xbps-install "$PKGS"
}

main () {
	elevate xbps-install -Su
}

main "$@";

