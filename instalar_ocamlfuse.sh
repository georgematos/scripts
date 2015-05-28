#!/bin/bash

sudo add-apt-repository ppa:alessandro-strada/ppa
sudo apt-get update
sudo apt-get install google-drive-ocamlfuse

google-drive-ocamlfuse

mkdir ~/gdrive

google-drive-ocamlfuse ~/gdrive
