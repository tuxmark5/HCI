TARGET    := 2
TEXINPUTS := .:./common:./${TARGET}:
export TEXINPUTS

all: common/main.pdf

%.pdf: %.tex
	xelatex -shell-escape -output-directory dist "\def\TARGET{${TARGET}}\input{$*.tex}" -no-pdf
	xelatex -shell-escape -output-directory dist "\def\TARGET{${TARGET}}\input{$*.tex}"

pull:
	git checkout -- dist/main.pdf
	git pull

show:
	xdg-open dist/main.pdf

check:
	grep -nri --color=always FIXME ${TARGET}/* common/*
	grep -nri --color=always TODO ${TARGET}/* common/*
