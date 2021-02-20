HTML=$(wildcard **/*.html) $(wildcard *.html)
FORMS=$(wildcard agreement/*.md) $(wildcard worksheet/*.md)
FORMATS=odt docx rtf pdf
DOT_FLAGS=-Nfontname=Arial -Efontname=Arial -Gfontname=Arial
LOGOS=logo-500.png logo-1000.png social.png

figures=$(wildcard figures/*.dot)

.PHONY: all

all: $(foreach format,$(FORMATS),$(addsuffix .$(format),$(FORMS:.md=))) $(LOGOS) $(figures:.dot=.png) $(figures:.dot=.svg)
	for file in $(HTML); do tidy -config tidy.config $$file | sponge $$file ; done

%.odt: %.md
	pandoc -o $@ $<

%.docx: %.md
	pandoc -o $@ $<

%.rtf: %.md
	pandoc -o $@ --standalone $<

%.pdf: %.md
	pandoc --variable fontsize=11pt -o $@ $<

%.png: %.dot
	dot -Tpng $(DOT_FLAGS) < $< > $@

%.svg: %.dot
	dot -Tsvg $(DOT_FLAGS) < $< > $@

logo-%.png: logo.svg
	inkscape $< -w $* -e $@

social.png: logo-1000.png
	convert $< -transparent white -matte -bordercolor white -border 100 $@
