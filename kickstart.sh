#!/bin/sh -e
# [void-]kickstart.sh

# This is free and unencumbered software released into the public domain.
 
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.

# For more information, please refer to <https://unlicense.org>

CORE_PKGS="pipewire alsa-pipewire wireplumber dbus-elogind polkit git"
DEVEL_PKGS="clang clang-tools-extra meson ninja ccache curl autoconf automake make ncurses ncurses-devel pkg-config bc"
EXTRA_PKGS="xorg-minimal xorg-server xorg-fonts firefox neovim mpv xtools xclip"

# optional dependencies for my dwm config
DESKTOP_PKGS="ranger scrot tmux gimp zsh"

elevate () {
	if [ "$(whoami)" = 'root' ]; then
		"$*"
	else
		su -c "$*"
	fi
}

list_pkg_group () {
	printf 'pkg-group %s contains\n    %s\n\n' "$@"
}

install_pkg_group () {
	elevate xbps-install "$@"
}

# only used if my config is installed
# and zsh is set as the default shell
clean_home () {
	rm -rf .bash\*
}

main () {
	case "$1" in
		-h|--help)
			printf '%s\n%s\n' 'kickstart.sh [-ADcdel] [--core] [--devel] [--extra] [--desktop]' 'read kickstart.sh for more info'
		;;
		-l|--list)
			list_pkg_group 'CORE'    "$CORE_PKGS"
			list_pkg_group 'DEVEL'   "$DEVEL_PKGS"
			list_pkg_group 'EXTRA'   "$EXTRA_PKGS"
			list_pkg_group 'DESKTOP' "$DESKTOP_PKGS"
		;;
	esac
	#elevate xbps-install -Su
}

main "$@";

