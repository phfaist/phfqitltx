
#
# Common useful definitions
#
LATEX = latex

PDFLATEX = pdflatex
PDFLATEXOPTS = -interaction=batchmode
PDFLATEXOPTSLAST = -interaction=batchmode --synctex=1

MAKEINDEX = makeindex


#
# Set default PREFIX. This can be overridden with 'make install PREFIX=/installation/directory'
#
DEFAULT_PREFIX := $(shell kpsewhich -var-value TEXMFHOME)
PREFIX ?= $(DEFAULT_PREFIX)


#
# package should be set in variable PKG
#
PKGREADME = README.md

#
# packages may specify additional files in the distribution with this variable (by default
# empty)
#
DIST_ADDITIONAL_FILES ?= 



.PHONY: default clean cleanall cleansty cleanaux cleanpdf cleantdszip cleandist  install_sty install_doc



help:
	@echo "Targets for $(PKG):"
	@echo "make $(PKG).sty"
	@echo "make $(PKG).pdf"
	@echo "make install"
	@echo "make install PREFIX=[specify texmf directory]"
	@echo "make $(PKG).tds.zip"
	@echo "make dist"


clean: cleanaux

cleanall: cleansty cleanaux cleanpdf cleantdszip cleandist

# ------------------------------------------------
# make PKG.sty
# ------------------------------------------------

PKGSTY = $(PKG).sty

$(PKGSTY): $(PKG).ins $(PKG).dtx
	$(LATEX) $<

cleansty:
	@rm -f $(PKGSTY)

# ------------------------------------------------
# make PKG.pdf
# ------------------------------------------------

PKGPDF = $(PKG).pdf

cleanaux:
	@rm -f *.aux *.log *.toc *.glo *.gls *.ind *.idx *.ilg *.out *.bbl *.blg *.synctex.gz *.hd

cleanpdf:
	@rm -f $(PKGPDF)

#
# fake index & glossary so they get a TOC entry from the beginning, and so the page
# numbers in the index are correct.
#
$(PKG).aux $(PKG).idx $(PKG).glo: $(PKG).dtx $(PKG).sty
	DTX=$< ; echo '\\begin{theindex}\\item index here \\end{theindex}' >$${DTX%.dtx}.ind
	DTX=$< ; echo '\\begin{theglossary}\\item changes here\\end{theglossary}' >$${DTX%.dtx}.gls
	$(PDFLATEX) $(PDFLATEXOPTS) $<
	$(PDFLATEX) $(PDFLATEXOPTS) $<
	$(PDFLATEX) $(PDFLATEXOPTS) $<

$(PKG).ind: $(PKG).idx
	$(MAKEINDEX) -s gind.ist -o $@ $<

$(PKG).gls: $(PKG).glo
	$(MAKEINDEX) -s gglo.ist -o $@ $<

# final steps of making the PKG.pdf doc file.  At the end, touch the ind and gls files so
# that they don't look out-of-date (because the idx and glo files were overwritten again)
$(PKG).pdf: $(PKG).dtx $(PKG).aux $(PKG).ind $(PKG).gls
	$(PDFLATEX) $(PDFLATEXOPTS) $<
	$(PDFLATEX) $(PDFLATEXOPTS) $<
	$(PDFLATEX) $(PDFLATEXOPTSLAST) $<
	touch $(PKG).ind $(PKG).gls $(PKG).pdf


#
# partial installation targets
#

install_sty:
	mkdir -p $(DESTDIR)$(PREFIX)/tex/latex/$(PKG)
	cp $(PKG).sty  $(DESTDIR)$(PREFIX)/tex/latex/$(PKG)

install_doc:
	mkdir -p $(DESTDIR)$(PREFIX)/doc/latex/$(PKG)
	cp $(PKGPDF) $(PKGREADME)  $(DESTDIR)$(PREFIX)/doc/latex/$(PKG)



# ------------------------------------------------
# make PKG.tds.zip
# ------------------------------------------------

PKGTDSZIP = $(PKG).tds.zip

cleantdszip:
	@rm -f $(PKGTDSZIP)

TDSTMPDIR = $(CURDIR)/_install_tds_zip.make.tmp

$(PKGTDSZIP): $(PKGSTY) $(PKGPDF)
	mkdir $(TDSTMPDIR)
	$(MAKE) install PREFIX=$(TDSTMPDIR)
	cd $(TDSTMPDIR) && zip -r $(CURDIR)/$(PKGTDSZIP) *
	rm -rf $(TDSTMPDIR)


# ------------------------------------------------
# make dist
# ------------------------------------------------

DISTTMPDIR = $(CURDIR)/_install_dist_zip.make.tmp

dist: $(PKGTDSZIP)
	rm -rf $(DISTTMPDIR)
	mkdir -p $(DISTTMPDIR)/$(PKG)
	cp $(PKGTDSZIP) $(DISTTMPDIR)
	cp $(PKG).dtx $(PKGPDF) $(PKGREADME) Makefile $(DIST_ADDITIONAL_FILES) $(DISTTMPDIR)/$(PKG)
	cd $(DISTTMPDIR) && zip -r $(CURDIR)/$(PKG).zip $(PKGTDSZIP) $(PKG)
	rm -rf $(DISTTMPDIR)

cleandist:
	@rm -f $(PKG).zip
