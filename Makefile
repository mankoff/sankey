.ONESHELL:

SHELL = bash
.DEFAULT_GOAL := help

CSVDIR=./dat/
TMPDIR=./tmp/
TEXDIR=./tex/

MKDIR_P := mkdir -p

CSVS = $(shell find $(CSVDIR) -name "*.csv")
PDFS=$(CSVS:.csv=.pdf)
PDFS:=${subst $(CSVDIR),,$(PDFS)}
PDFS:=${subst /,,$(PDFS)}
SRC_TEX=$(CSVS:.csv=.tex)
SRC_TEX:=${subst $(CSVDIR),$(TMPDIR),$(SRC_TEX)}

LATEXCMD=pdflatex
LATEXOPTS=-interaction nonstopmode -file-line-error --output-directory=$(TMPDIR)

.PHONY: help
.PRECIOUS: tmp/%.tex

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

all: $(TMPDIR) $(PDFS) ## Build all Sankey graphics for each dat/*.csv
	@echo "all: $(PDFS)"

$(TMPDIR):
	${MKDIR_P} $(TMPDIR)

%.pdf: $(CSVDIR)/%.csv %.tex sankey.tex Makefile ## Make a PDF
	$(LATEXCMD) $(LATEXOPTS) ./tmp/$*.tex
	# mv ./tmp/$*.pdf $*.pdf
	# pdfcrop -bbox "100 325 480 660" tmp/$*.pdf # L B W H
	# mv ./tmp/$*-crop.pdf $*.pdf
	pdfcrop tmp/$*.pdf # L B W H
	mv ./tmp/$*-crop.pdf $*.pdf

%.tex: ${CSVDIR}/%.csv
	@sed  '/INSERT_CSV_HERE/q' sankey.tex > tmp/$*.tex
	@cat dat/$*.csv \
		| tail -n +2 \
		| cut -d, -f1-3 \
		| sed 's/^/{v/' \
		| sed 's/,/\//g' \
		| sed "s/$$/},/g" \
		>> tmp/$*.tex
	@sed -e '1,/INSERT_CSV_HERE/d' sankey.tex >> tmp/$*.tex

clean: ## Delete PDFs and tmp folder contents
	rm -fR tmp/* $(PDFS)
