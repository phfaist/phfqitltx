
#
# Common useful definitions
#
LATEX = latex

PDFLATEX = TEXINPUTS="$$TEXINPUTS:../phfnote" pdflatex
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
# packages may specify additional files in the distribution with this variable
# (by default empty)
#
DIST_ADDITIONAL_FILES ?= 


PKGDTX = $(PKG).dtx
PKGINS = $(PKG).ins
PKGSTY = $(PKG).sty
PKGPDF = $(PKG).pdf
PKGTDSZIP = $(PKG).tds.zip
PKGZIP = $(PKG).zip



.PHONY: help sty pdf install install_sty install_doc tdszip dist clean cleanall cleansty cleanaux cleanpdf cleantdszip cleandist


help:
	@echo "Targets for $(PKG):"
	@echo "make sty             -- generate LaTeX package file $(PKG).sty"
	@echo "make pdf             -- generate pdf documentation"
	@echo "make install         -- install style and documentation files to TEXMF tree"
	@echo "make install PREFIX=[specify texmf directory]"
	@echo "make $(PKG).tds.zip  -- create TDS.ZIP to include in CTAN upload"
	@echo "make dist            -- create distribution ZIP, ready for upload to CTAN"
	@echo "make clean           -- remove LaTeX auxiliary files"
	@echo "make cleansty        -- remove generated style file"
	@echo "make cleanpdf        -- remove generated pdf documentation"
	@echo "make cleanall        -- remove all generated files, incl. distribution zip"


clean: cleanaux

cleanall: cleansty cleanaux cleanpdf cleantdszip cleandist

# ------------------------------------------------
# make sty
# ------------------------------------------------

sty: $(PKGSTY)

$(PKGSTY): $(PKGINS) $(PKGDTX)
	$(LATEX) $<

cleansty:
	@rm -f $(PKGSTY)

# ------------------------------------------------
# make pdf
# ------------------------------------------------

pdf: $(PKG).pdf

#
# fake index & glossary so they get a TOC entry from the beginning, and so the page
# numbers in the index are correct.
#
$(PKG).aux $(PKG).idx $(PKG).glo: $(PKGDTX) $(PKGSTY)
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
$(PKGPDF): $(PKGDTX) $(PKG).aux $(PKG).ind $(PKG).gls
	$(PDFLATEX) $(PDFLATEXOPTS) $<
	$(PDFLATEX) $(PDFLATEXOPTS) $<
	$(PDFLATEX) $(PDFLATEXOPTSLAST) $<
	touch $(PKG).ind $(PKG).gls $(PKG).pdf


cleanaux:
	@rm -f *.aux *.log *.toc *.glo *.gls *.ind *.idx *.ilg *.out *.bbl *.blg *.synctex.gz *.hd

cleanpdf:
	@rm -f $(PKGPDF)

# ------------------------------------------------
# 'make install' partial installation targets
# ------------------------------------------------

#
# The install target itself is defined per-package, in case packages want to install more
# files (such as bibtex styles)
#

install_sty: $(PKGSTY)
	mkdir -p $(DESTDIR)$(PREFIX)/tex/latex/$(PKG)
	cp $(PKGSTY)  $(DESTDIR)$(PREFIX)/tex/latex/$(PKG)

install_doc: $(PKGPDF)
	mkdir -p $(DESTDIR)$(PREFIX)/doc/latex/$(PKG)
	cp $(PKGPDF) $(PKGREADME)  $(DESTDIR)$(PREFIX)/doc/latex/$(PKG)



# ------------------------------------------------
# make tdszip
# ------------------------------------------------

TDSTMPDIR = $(CURDIR)/_install_tds_zip.make.tmp

tdszip: $(PKGTDSZIP)

$(PKGTDSZIP): $(PKGSTY) $(PKGPDF)
	mkdir $(TDSTMPDIR)
	$(MAKE) install PREFIX=$(TDSTMPDIR)
	cd $(TDSTMPDIR) && zip -r $(CURDIR)/$(PKGTDSZIP) *
	rm -rf $(TDSTMPDIR)

cleantdszip:
	@rm -f $(PKGTDSZIP)


# ------------------------------------------------
# make dist
# ------------------------------------------------

DISTTMPDIR = $(CURDIR)/_install_dist_zip.make.tmp

dist: $(PKGZIP)

$(PKGZIP): $(PKGTDSZIP)
	rm -rf $(DISTTMPDIR)
	mkdir -p $(DISTTMPDIR)/$(PKG)
	cp $(PKGTDSZIP) $(DISTTMPDIR)
	cp $(PKGDTX) $(PKGINS) $(PKGPDF) $(PKGREADME) Makefile pkg.mk $(DIST_ADDITIONAL_FILES) $(DISTTMPDIR)/$(PKG)
	cd $(DISTTMPDIR) && zip -r $(CURDIR)/$(PKGZIP) $(PKGTDSZIP) $(PKG)
	rm -rf $(DISTTMPDIR)

cleandist:
	@rm -f $(PKGZIP)
