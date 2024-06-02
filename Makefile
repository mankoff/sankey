.ONESHELL:

SHELL = bash
.DEFAULT_GOAL := help

CSVDIR=./dat/
TMPDIR=./tmp/
TEXDIR=./tex/

CSVS = $(shell find $(CSVDIR) -name "*.csv")
PDFS=$(CSVS:.csv=.pdf)
PDFS:=${subst $(CSVDIR),,$(PDFS)}
SRC_TEX=$(CSVS:.csv=.tex)
SRC_TEX:=${subst $(CSVDIR),$(TMPDIR),$(SRC_TEX)}

LATEXCMD=pdflatex
LATEXOPTS=-interaction nonstopmode -file-line-error --output-directory=$(TMPDIR)

.PHONY: help
.PRECIOUS: tmp/%.tex

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo 'Found CSV files:', $(CSVS)
	@echo 'Possible pdf files', $(PDFS)
	@echo 'TEX: ', $(SRC_TEX)

all: $(PDFS) ## Build all Sankey graphics for each dat/*.csv
	@echo "all: $(PDFS)"

%.pdf: $(CSVDIR)/%.csv %.tex sankey.tex Makefile
	$(LATEXCMD) $(LATEXOPTS) ./tmp/$*.tex
	mv ./tmp/$*.pdf $*.pdf

%.tex: ${CSVDIR}/%.csv
	@sed  '/INSERT_CSV_HERE/q' sankey.tex > tmp/$*.tex
	@cat dat/$*.csv \
		| tail -n +2 \
		| cut -d, -f1-3 \
		| sed 's/^/{/' \
		| sed 's/,/\//g' \
		| sed "s/$$/},/g" \
		>> tmp/$*.tex
	@sed -e '1,/INSERT_CSV_HERE/d' sankey.tex >> tmp/$*.tex

clean:
	rm -fR tmp/* fig/*
