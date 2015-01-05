#!/bin/bash

deb http://qgis.org/debian precise main
deb-src http://qgis.org/debian precise main

gpg --keyserver keyserver.ubuntu.com --recv DD45F6C3
gpg --export --armor DD45F6C3 | sudo apt-key add -

sudo apt-get update
sudo apt-get install qgis python-qgis

sudo apt-get install qgis-plugin-grass
