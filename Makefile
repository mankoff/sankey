.ONESHELL:

SHELL = bash
.DEFAULT_GOAL := help

CSVDIR=./dat/
PDFDIR=./fig/
TMPDIR=./tmp/
TEXDIR=./tex/

CSVS = $(shell find $(CSVDIR) -name "*.csv")
PDFS=$(CSVS:.csv=.pdf)
PDFS:=${subst $(CSVDIR),$(PDFDIR),$(PDFS)}
SRC_TEX=$(CSVS:.csv=.tex)
SRC_TEX:=${subst $(CSVDIR),$(TMPDIR),$(SRC_TEX)}

LATEXCMD=pdflatex
LATEXOPTS=-interaction nonstopmode -file-line-error --output-directory=$(PDFDIR)

.PHONY: help
.PRECIOUS: tmp/gl_%.tex tmp/aq_%.tex

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

all: $(PDFS) ## Build all Sankey graphics for each dat/*.csv
	@echo "all: $(PDFS)"

./fig/%.pdf: tmp/%.tex
	$(LATEXCMD) $(LATEXOPTS) ./tmp/$*.tex || true # continue on error

tmp/gl_%.tex: dat/gl_%.csv
	@sed '/INSERT_CSV_HERE/Q' tex/gl_sankey.tex > tmp/gl_$*.tex
	@cat dat/gl_$*.csv \
		| tail -n +2 \
		| cut -d, -f1-3 \
		| sed 's/^/{/' \
		| sed 's/,/\//g' \
		| sed "s/$$/},/g" \
		>> tmp/gl_$*.tex
	@sed -e '1,/INSERT_CSV_HERE/d' tex/gl_sankey.tex >> tmp/gl_$*.tex

tmp/aq_%.tex: dat/aq_%.csv
	@sed '/INSERT_CSV_HERE/Q' tex/aq_sankey.tex > tmp/aq_$*.tex
	@cat dat/aq_$*.csv \
		| tail -n +2 \
		| cut -d, -f1-3 \
		| sed 's/^/{/' \
		| sed 's/,/\//g' \
		| sed "s/$$/},/g" \
		>> tmp/aq_$*.tex
	@sed -e '1,/INSERT_CSV_HERE/d' tex/aq_sankey.tex >> tmp/aq_$*.tex

clean:
	rm -fR tmp/* fig/*
