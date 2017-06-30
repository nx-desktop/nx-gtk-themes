#! /bin/sh

# This script listens for changes in the files contained 
# in the 'src' folder.
# Whenever a file is modified; the theme is rebuilt.

find nomad* | entr -r -c -d -p -s "${PWD}/func.sh"
