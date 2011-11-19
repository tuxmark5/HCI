#!/bin/bash

mkdir -p "${HOME}/Computer-Human-Iteraction"
ffmpeg -f x11grab -s wxga -r 25 -i :0.0 -sameq \
  "${HOME}/Computer-Human-Iteraction/$(date --rfc-3339=seconds).mpg"
 
