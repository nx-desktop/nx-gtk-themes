#! /bin/sh


#	install dependencies.

apt -yy -qq update
apt -yy -qq dist-upgrade

apt -yy -qq install devscripts lintian build-essential automake autotools-dev equivs inkscape sassc \
	 --no-install-recommends

mk-build-deps -i -t "apt-get --yes" -r


#	render images & compile themes.

(
	cd src
	for var in nitrux*; do
		mkdir -p "themes/$var/gtk-3.0/img"

		cat "$src/index" | while read id; do
			inkscape "$var/img.svg" -ji "$id" -o "themes/$var/gtk-3.0/img/$id.png"
			inkscape "$var/img.svg" -ji "$id" -d 192 -o "themes/$var/gtk-3.0/img/$id@2.png"
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
