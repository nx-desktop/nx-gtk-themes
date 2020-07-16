#! /bin/sh


apt-get --yes update
apt-get --yes install wget


#	add KDE Neon repository.

> /etc/apt/sources.list.d/neon-stable.list \
	echo 'deb http://archive.neon.kde.org/dev/stable/ bionic main'

wget -qO - 'http://archive.neon.kde.org/public.key' | apt-key add -


#	install dependencies.

apt-get --yes update
apt-get --yes dist-upgrade
apt-get --yes install devscripts lintian build-essential automake autotools-dev equivs inkscape sassc
mk-build-deps -i -t "apt-get --yes" -r


#	render images & compile themes.

(
	cd src
	for var in nomad*; do
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
