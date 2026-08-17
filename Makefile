DOCNAME=main
OPEN := $(shell grep -qi microsoft /proc/version 2>/dev/null && echo wslview || echo open)
TEMPLATE_URL=https://assets.ctfassets.net/o78em1y1w4i4/4MpsJHO0MOJ2xZuwGTAbOZ/7bc64af36477c5d6cfce335a1f872363/elsarticle.zip

all: report

.PHONY: clean distclean

template.zip:
	curl -L -o template.zip $(TEMPLATE_URL)
	unzip -jo template.zip '*.ins' '*.dtx' '*.bst'
	latex elsarticle.ins

report: template.zip
	pdflatex $(DOCNAME).tex
	bibtex $(DOCNAME).aux
	pdflatex $(DOCNAME).tex
	pdflatex $(DOCNAME).tex
	@echo "Word Count:"
	detex $(DOCNAME).tex | wc -w

view: report
	open $(DOCNAME).pdf

submit: report
	rm -rf submit/
	lateflat .
	cp *.bst *.ins *.dtx submit/
	cd submit && pdflatex $(DOCNAME).tex && bibtex $(DOCNAME).aux && pdflatex $(DOCNAME).tex && pdflatex $(DOCNAME).tex
	pdflatex abstract_only.tex
	mv abstract_only.pdf submit/
	$(OPEN) submit/$(DOCNAME).pdf
	
clean:
	rm -f *.blg *.bbl *.aux *.log *.spl

distclean: clean
	rm -f template.zip elsarticle.cls elsarticle.ins elsarticle.dtx elsarticle-harv.bst elsarticle-num.bst elsarticle-num-names.bst