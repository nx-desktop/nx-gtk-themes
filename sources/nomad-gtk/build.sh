#! /bin/sh

# This script listens for changes in the files contained 
# in the 'src' folder.
# Whenever a file is modified; the theme is rebuilt.

killall gtk3-widget-factory &> /dev/null

find "src/" | entr -r -c -d -p -s "${PWD}/func.sh"
