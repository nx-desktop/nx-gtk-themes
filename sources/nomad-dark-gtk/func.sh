#! /bin/sh

_fail() { printf "\033[38;5;1m${@}\033[38;0;1m\n"; }
_echo() { printf "\033[38;5;5m${@}\033[38;0;1m\n"; }

_render() {
	index=(nomad-{dark,light})

	for i in "${index[@]}"; do
		for img in $(cat "$i/src/index"); do
			if [ ! -f "$i/gtk-3.0/img/$img.png" ]; then
				out="$i/gtk-3.0/img/$img.png"
				out2="$i/gtk-3.0/img/$img@2.png"

				inkscape -ji "$img" -e "$out" "$i/src/img.svg" > /dev/null
				inkscape -ji "$img" -d 192 -e "$out2" "$i/src/img.svg" > /dev/null
			fi
		done
	done
}

_compile() {
	scss=(nomad-{dark,light}/src/scss/gtk.scss)
	gcss=(nomad-{dark,light}/gtk-3.0/gtk.css)

	for i in 0 1; do
		sassc --style compact "${scss[$i]}" "${gcss[$i]}"
	done
}

if _render; then
	_echo ' - DONE RENDERING IMAGES.'
else
	_fail ' - FAILED RENDERING IMAGES.'
	exit 1
fi
	
if _compile; then
	_echo ' - DONE COMPILING SCSS.'
#	gtk3-widget-factory
else
	_fail ' - FAILED COMPILING SCSS.'
	exit 1
fi
