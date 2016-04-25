

LATEX = latex

PDFLATEX = pdflatex
PDFLATEXOPTS = -interaction=batchmode

MAKEINDEX = makeindex

ALLDTX = phfnote.dtx phfquotetext.dtx
ALLSTY = phfnote.sty phfquotetext.sty
ALLPDF = phfnote.pdf phfquotetext.pdf

.PHONY: help pdf sty cleanall clean cleanaux cleansty cleanpdf

help:
	@echo ""
	@echo "--------------------------------------------------"
	@echo "Makefile for phfqitltx packages"
	@echo "--------------------------------------------------"
	@echo ""
	@echo "Run:"
	@echo "    - 'make sty' to generate the style files;"
	@echo "    - 'make pdf' to generate all package documentation;"
	@echo "    - 'make cleanaux' to clean up TeX aux files;"
	@echo "    - 'make cleansty' to clean up generated .sty files;"
	@echo "    - 'make cleanpdf' to clean up generated pdf documentation;"
	@echo "    - 'make cleanall' to clean up all generated files."
	@echo ""

pdf: $(ALLPDF)

sty: $(ALLDTX)
	$(LATEX) phfqitltx.ins

clean: cleanaux

cleanall:  cleanaux cleansty cleanpdf

cleanaux:
	@rm -f *.aux *.log *.toc *.glo *.gls *.ind *.idx *.ilg *.out *.bbl *.blg

cleansty:
	@rm -f $(ALLSTY)

cleanpdf:
	@rm -f $(ALLPDF)


%.sty: %.dtx allsty

%.aux: %.dtx %.sty
	$(PDFLATEX) $(PDFLATEXOPTS) $<
	$(PDFLATEX) $(PDFLATEXOPTS) $<
	$(PDFLATEX) $(PDFLATEXOPTS) $<

%.idx: %.dtx %.aux

%.glo: %.dtx %.aux

%.ind: %.idx
	$(MAKEINDEX) -s gind.ist -o $@ $<

%.gls: %.glo
	$(MAKEINDEX) -s gglo.ist -o $@ $<

%.pdf: %.dtx %.aux %.ind %.gls
	$(PDFLATEX) $(PDFLATEXOPTS) $<
	$(PDFLATEX) $(PDFLATEXOPTS) $<
	$(PDFLATEX) $(PDFLATEXOPTS) $<

