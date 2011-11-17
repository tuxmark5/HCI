TARGET    := 4
TEXINPUTS := .:./common:./${TARGET}:
export TEXINPUTS

all: common/main.pdf

%.pdf: %.tex
	xelatex -shell-escape -output-directory dist "\def\TARGET{${TARGET}}\input{$*.tex}" -no-pdf
	xelatex -shell-escape -output-directory dist "\def\TARGET{${TARGET}}\input{$*.tex}"

pull:
	git stash
	git pull
	git stash pop

show:
	xdg-open dist/main.pdf

check:
	-grep -nri --color=always FIXME ${TARGET}/* common/*
	-grep -nri --color=always TODO ${TARGET}/* common/*
