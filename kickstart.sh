#!/bin/sh -e
# [void-]kickstart.sh

# This is free and unencumbered software released into the public domain.
 
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.

# For more information, please refer to <https://unlicense.org>

PKGS="pipewire alsa-pipewire wireplumber dbus-elogind polkit git clang clang-tools-extra meson ninja ccache curl autoconf automake make ncurses ncurses-devel pkg-config bc xorg-minimal xorg-server xorg-fonts hsetroot firefox neovim mpv xtools xclip ranger scrot tmux gimp zsh"

elevate () {
	if [ "$(whoami)" = 'root' ]; then
		"$*"
	else
		sudo "$*"
	fi
}

clone_repos () {
	mkdir -p "$HOME/src"
	git clone 'https://github.com/cwillsey06/suckless-cw' "$HOME/src/suckless"
}

build_software () {
	cd "$HOME/src/suckless"
	git submodule update --remote
	find "$(pwd -P)" -maxdepth 1 -not -path '*/.git' -type d \
		-exec sh -c 'cd {} && make' ';'
}

configure_all () {
	mkdir -p "$HOME/src"
	# xinitrc
	cat <<EOF > "$HOME/.xinitrc"
#!/bin/sh
export "$(dbus-launch)"
hsetroot -solid '#282828' \
	-cover "$(find "$HOME/.local/share/backgrounds" -maxdepth 1 -type l -name '*active*')" \
	2> /dev/null
exec pipewire &
exec slstatus &
exec dwm
EOF
	cat <<EOF > "$HOME"

EOF
	chsh --shell /bin/zsh
	rm -f "$HOME/.bash*"
}

main () {
	elevate xbps-install -Su "$PKGS"
	clone_repos
	build_software
	configure_all
}

main "$@";

