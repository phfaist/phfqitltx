
#
# Set default PREFIX. This can be overridden with 'make install PREFIX=/installation/directory'
#
DEFAULT_PREFIX := $(shell kpsewhich -var-value TEXMFHOME)
PREFIX ?= $(DEFAULT_PREFIX)

ALLPKGS = phfnote phfquotetext phfqit phffullpagefigure phfsvnwatermark phfparen phfthm


.PHONY: help sty pdf install versioncheck tdszip dist clean cleanall cleanaux cleansty cleanpdf cleantdszip cleandist

# Don't remove intermediate files
.SECONDARY:


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
	@echo "    - 'make sty' to generate all the style files;"
	@echo "    - 'make pdf' to generate all package documentation files;"
	@echo "    - 'make cleanaux' to remove TeX aux files;"
	@echo "    - 'make cleansty' to remove generated .sty files;"
	@echo "    - 'make cleanpdf' to remove generated pdf documentation;"
	@echo "    - 'make cleanall' to remove all generated files, including tds.zip's and distribution zip's;"
	@echo "    - 'make install' to install all packages to local TEXMF directory;"
	@echo "    - 'make install PREFIX=/path/to/texlive/texmf' to install to custom texmf directory;"
	@echo "    - 'make tdszip' to create TDS.ZIP files for automated installation in TEXMF tree;"
	@echo "    - 'make dist' to generate a distribution ZIP file, ready to upload to CTAN;"
	@echo "    - 'make versioncheck' to list the version information in the packages and the README file(s)."
	@echo ""

# ------------------------------------------------
# make sty
# ------------------------------------------------

sty:  $(ALLSTY)

%/%.sty: %/%.ins %/%.dtx
	$(LATEX) $<

cleansty:
	@rm -f $(ALLSTY)
	@rm -f _stamp_sty_from_ins.mkstamp

# ------------------------------------------------
# make cleanall
# ------------------------------------------------

cleanall:  cleanaux cleansty cleanpdf cleandist cleantdszip


# ------------------------------------------------
# make install
# ------------------------------------------------

install: $(ALLSTY) $(ALLPDF)
	mkdir -p $(DESTDIR)$(PREFIX)/tex/latex/phfqitltx
	mkdir -p $(DESTDIR)$(PREFIX)/doc/latex/phfqitltx
	mkdir -p $(DESTDIR)$(PREFIX)/bibtex/bst/phfqitltx
	cp $(ALLSTY)  $(DESTDIR)$(PREFIX)/tex/latex/phfqitltx
	cp $(ALLPDF) $(README)  $(DESTDIR)$(PREFIX)/doc/latex/phfqitltx
	cp naturemagdoi.bst  $(DESTDIR)$(PREFIX)/bibtex/bst/phfqitltx


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

versioncheck:
	@echo
	@echo
	@echo "================================================================================"
	@echo
	@echo "Please make sure that the version numbers are correct:"
	@echo
	@echo "In $(README): "
	@grep -i 'Bundle Version:' $(README)
	@echo "Individual package versions: "
	@egrep -h '\[.* phf\w+ package\]' $(ALLDTX)
	@echo
	@echo "================================================================================"
	@echo

dist: versioncheck tdszip
	rm -rf $(DISTTMPDIR)
	mkdir -p $(DISTTMPDIR)/phfqitltx
	cp phfqitltx.tds.zip $(DISTTMPDIR)
	cp $(ALLDTX) $(ALLPDF) phfqitltx.ins README.md naturemagdoi.bst Makefile $(DISTTMPDIR)/phfqitltx
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
	@rm -f *.aux *.log *.toc *.glo *.gls *.ind *.idx *.ilg *.out *.bbl *.blg *.synctex.gz *.hd

cleanpdf:
	@rm -f $(ALLPDF)


#
# fake index & glossary so they get a TOC entry from the beginning, and so the page
# numbers in the index are correct.
#
%.aux %.idx %.glo: %.dtx %.sty
	DTX=$< ; echo '\\begin{theindex}\\item index here \\end{theindex}' >$${DTX%.dtx}.ind
	DTX=$< ; echo '\\begin{theglossary}\\item changes here\\end{theglossary}' >$${DTX%.dtx}.gls
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
