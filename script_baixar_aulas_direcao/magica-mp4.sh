#!/bin/bash
y=1; for i in `cut -f 2 lista.txt | cut -d = --fields=2-`; do `wget $i -O "Parte $y.mp4"`; y=$((y+1)); done;