#!/bin/bash

set -x

apt -qq update
apt -qq -yy install equivs curl git wget gnupg2

### Install Dependencies

DEBIAN_FRONTEND=noninteractive apt -qq -yy install --no-install-recommends devscripts debhelper gettext lintian build-essential automake autotools-dev cmake extra-cmake-modules appstream

mk-build-deps -i -t "apt-get --yes" -r

### render images & compile themes.

(
	cd src
	for var in nitrux*; do
		mkdir -p "themes/$var/gtk-3.0/img"

		cat "$var/index" | while read id; do
			inkscape "$var/img.svg" -ji "$id" -e "themes/$var/gtk-3.0/img/$id.png"
			inkscape "$var/img.svg" -ji "$id" -d 192 -e "themes/$var/gtk-3.0/img/$id@2.png"
		done

		sassc -t compressed "$var/scss/gtk.scss" "themes/$var/gtk-3.0/gtk.css"
		cp -r "$var/gtk-2.0" "themes/$var"
	done

	mv themes ..
)

#	build deb.
mkdir source
mv ./* source/ # hack for debuild
cd source
debuild -b -uc -us
