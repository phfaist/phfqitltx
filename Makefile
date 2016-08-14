
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
	@echo "You may also run make on individual packages.  Run 'make' or 'make help' within"
	@echo "the corresponding subdirectory for more info."
	@echo ""

# ------------------------------------------------
# make sty
# ------------------------------------------------

ALLSTY = $(foreach x,$(ALLPKGS),$(x)/$(x).sty)
ALLSTYCMDS = $(foreach x,$(ALLPKGS),$(MAKE) -C $(x) $(x).sty && ) true

sty:
	$(ALLSTYCMDS)

cleansty:
	@rm -f $(ALLSTY)

# ------------------------------------------------
# make clean, make cleanall
# ------------------------------------------------

ALLCLEANCMDS = $(foreach x,$(ALLPKGS),$(MAKE) -C clean && ) true
ALLCLEANALLCMDS = $(foreach x,$(ALLPKGS),$(MAKE) -C cleanall && ) true

clean:
	$(ALLCLEANCMDS)

cleanall:
	$(ALLCLEANALLCMDS)

# ------------------------------------------------
# make pdf
# ------------------------------------------------

ALLPDF = $(foreach x,$(ALLPKGS),$(x)/$(x).pdf)
ALLPDFCMDS = $(foreach x,$(ALLPKGS),$(MAKE) -C $(x) $(x).pdf && ) true

pdf:
	$(ALLPDFCMDS)

cleanpdf:
	@rm -f $(ALLPDF)

# ------------------------------------------------
# make cleanaux
# ------------------------------------------------

ALLCLEANAUXCMDS = $(foreach x,$(ALLPKGS),$(MAKE) -C cleanaux && ) true

cleanaux:
	$(ALLCLEANAUXCMDS)

# ------------------------------------------------
# make install
# ------------------------------------------------

ALLINSTALLCMDS = $(foreach x,$(ALLPKGS),$(MAKE) -C $(x) install && ) true

install:
	$(ALLINSTALLCMDS)


# ------------------------------------------------
# make tdszip
# ------------------------------------------------

ALLTDSZIPCMDS = $(foreach x,$(ALLPKGS),$(MAKE) -C $(x) $(x).tds.zip && ) true

tdszip:
	$(ALLTDSZIPCMDS)

cleantdszip:
	..........

# ------------------------------------------------
# make dist
# ------------------------------------------------

ALLDISTCMDS = $(foreach x,$(ALLPKGS),$(MAKE) -C $(x) dist && ) true

dist:
	$(ALLDISTCMDS)

cleandist: ............
	@rm -f phfqitltx.zip

...........

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

