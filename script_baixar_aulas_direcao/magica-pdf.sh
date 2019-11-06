#!/bin/bash
y=1; for i in `cut -f 2 lista.txt`; do `wget $i -O "Parte $y.pdf"`; y=$((y+1)); done;