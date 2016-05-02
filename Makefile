

LATEX = latex

PDFLATEX = pdflatex
PDFLATEXOPTS = -interaction=batchmode

MAKEINDEX = makeindex

#
# Set default PREFIX. This can be overridden with 'make install PREFIX=/installation/directory'
#
DEFAULT_PREFIX := $(shell kpsewhich -var-value TEXMFHOME)
PREFIX ?= $(DEFAULT_PREFIX)

ALLDTX = phfnote.dtx phfquotetext.dtx phfqit.dtx
ALLSTY = phfnote.sty phfquotetext.sty phfqit.sty # only *generated* .sty
ALLPDF = phfnote.pdf phfquotetext.pdf phfqit.pdf

# for installation -- other style files to install, which aren't generated from DTX files
MANUALSTYLIST = phfsvnwatermark.sty phfparen.sty phfthm.sty phffullpagefigure.sty


.PHONY: help sty sty_from_ins cleanall install tdszip cleantdszip dist cleandist pdf clean cleanaux cleansty cleanpdf


# ------------------------------------------------
# make, make help
# ------------------------------------------------

help:
	@echo ""
	@echo "--------------------------------------------------"
	@echo "Makefile for phfqitltx packages"
	@echo "--------------------------------------------------"
	@echo ""
	@echo "Run:"
	@echo "    - 'make sty' to generate the style files;"
	@echo "    - 'make pdf' to generate all package documentation;"
	@echo "    - 'make cleanaux' to remove TeX aux files;"
	@echo "    - 'make cleansty' to remove generated .sty files;"
	@echo "    - 'make cleanpdf' to remove generated pdf documentation;"
	@echo "    - 'make cleanall' to remove all generated files, including tds.zip and distribution zip;"
	@echo "    - 'make install' to install to local TEXMF directory;"
	@echo "    - 'make install PREFIX=/path/to/texlive/texmf' to install to custom texmf directory;"
	@echo "    - 'make tdszip' to create TDS.ZIP file for automated installation in TEXMF tree;"
	@echo "    - 'make dist' to generate a distribution ZIP file, ready to upload to CTAN."
	@echo ""

# ------------------------------------------------
# make sty
# ------------------------------------------------

sty: $(ALLSTY)

%.sty: %.dtx
	$(MAKE) sty_from_ins

sty_from_ins: $(ALLDTX)
	$(LATEX) phfqitltx.ins

# ------------------------------------------------
# make cleanall
# ------------------------------------------------

cleanall:  cleanaux cleansty cleanpdf cleandist cleantdszip


# ------------------------------------------------
# make install
# ------------------------------------------------

install: $(ALLSTY) $(ALLPDF)
	mkdir -p $(DESTDIR)$(PREFIX)/tex/phfqitltx
	mkdir -p $(DESTDIR)$(PREFIX)/doc/phfqitltx
	mkdir -p $(DESTDIR)$(PREFIX)/bibtex/bst/phfqitltx
	cp $(ALLSTY) $(MANUALSTYLIST) $(DESTDIR)$(PREFIX)/tex/phfqitltx
	cp $(ALLPDF) $(DESTDIR)$(PREFIX)/doc/phfqitltx
	cp naturemagdoi.bst $(DESTDIR)$(PREFIX)/bibtex/bst/phfqitltx

# ------------------------------------------------
# make tdszip
# ------------------------------------------------

tdszip: phfqitltx.tds.zip

cleantdszip:
	@rm -f phfqitltx.tds.zip

TDSTMPDIR = $(CURDIR)/_install_tds_zip.make.tmp

phfqitltx.tds.zip: $(ALLSTY) $(ALLPDF)
	mkdir $(TDSTMPDIR)
	$(MAKE) install PREFIX=$(TDSTMPDIR)
	cd $(TDSTMPDIR) && zip -r $(CURDIR)/phfqitltx.tds.zip *
	rm -rf $(TDSTMPDIR)

# ------------------------------------------------
# make dist
# ------------------------------------------------

DISTTMPDIR = $(CURDIR)/_install_dist_zip.make.tmp

dist: tdszip
	rm -rf $(DISTTMPDIR)
	mkdir -p $(DISTTMPDIR)/phfqitltx
	cp phfqitltx.tds.zip $(DISTTMPDIR)
	cp $(ALLDTX) $(ALLPDF) phfqitltx.ins README.md naturemagdoi.bst Makefile $(MANUALSTYLIST)  $(DISTTMPDIR)/phfqitltx
	cd $(DISTTMPDIR) && zip -r $(CURDIR)/phfqitltx.zip phfqitltx.tds.zip phfqitltx
	rm -rf $(DISTTMPDIR)

cleandist:
	@rm -f phfqitltx.zip

# ------------------------------------------------
# make pdf
# ------------------------------------------------

pdf: $(ALLPDF)

clean: cleanaux

cleanaux:
	@rm -f *.aux *.log *.toc *.glo *.gls *.ind *.idx *.ilg *.out *.bbl *.blg

cleansty:
	@rm -f $(ALLSTY)

cleanpdf:
	@rm -f $(ALLPDF)


%.aux %.idx %.glo: %.dtx %.sty
	$(PDFLATEX) $(PDFLATEXOPTS) $<
	$(PDFLATEX) $(PDFLATEXOPTS) $<
	$(PDFLATEX) $(PDFLATEXOPTS) $<

%.ind: %.idx
	$(MAKEINDEX) -s gind.ist -o $@ $<

%.gls: %.glo
	$(MAKEINDEX) -s gglo.ist -o $@ $<

%.pdf: %.dtx %.aux %.ind %.gls
	$(PDFLATEX) $(PDFLATEXOPTS) $<
	$(PDFLATEX) $(PDFLATEXOPTS) $<
	$(PDFLATEX) $(PDFLATEXOPTS) $<

