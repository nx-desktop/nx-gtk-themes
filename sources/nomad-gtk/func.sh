#! /bin/sh

_render() {
	for i in `cat "src/index"`; do

		img="gtk-3.0/img/$i"
		src="src/img.svg"

		if [ ! -f "$img.png" ]; then
			inkscape -ji $i -e "$img.png" "$src" > /dev/null
			inkscape -ji $i -d 192 -e "$img@2.png" "$src" > /dev/null
		fi
	done
}

_compile() {
	cd "src/scss/"
	for style in "gtk*.scss"; do
		sassc --style compact "$style" "../../gtk-3.0/$style"
	done
	cd -
}

_error() {
	echo -e "\033[38;5;1m $@ \n"
}

_success() {
	echo -e "\033[38;5;5m $@ \n"
}

_main() {
	_render  ||
	(_error ' - FAILED RENDERING IMAGES.'; exit) &&
	_success ' - DONE RENDERING IMAGES.'

	_compile ||
	(_error ' - FAILED COMPILING SCSS.'; exit) &&
	(_success ' - DONE COMPILING SCSS.'; gtk3-widget-factory)
}

_main
