using Blink

w = Window(;async=false)
load!(w, "/data/Documents/minesweeper/ui/index.html")
#loadhtml(w, "/ui/index.html")
title(w, "Minesweeper")
#loadfile(w, "/data/Documents/minesweeper/ui/index.html")
