
#
# Set default PREFIX. This can be overridden with 'make install PREFIX=/installation/directory'
#
DEFAULT_PREFIX := $(shell kpsewhich -var-value TEXMFHOME)
PREFIX ?= $(DEFAULT_PREFIX)

# phfnote must go first (all docs need phfnote.sty)
ALLPKGS = phfnote phffullpagefigure phfqit phfquotetext phfparen phfsvnwatermark phfthm phfcc phfextendedabstract

.PHONY: help clean cleanall sty cleansty pdf cleanpdf cleanaux install tdszip cleantdszip dist versionlist cleandist $(ALLPKGS)

# Don't remove intermediate files
.SECONDARY:


README = README.md


ALLDTX = $(foreach x,$(ALLPKGS),$(x)/$(x).dtx)
ALLSTY = $(foreach x,$(ALLPKGS),$(x)/$(x).sty)
ALLPDF = $(foreach x,$(ALLPKGS),$(x)/$(x).pdf)


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
	@echo "    - 'make install' to install all packages to $(DEFAULT_PREFIX);"
	@echo "    - 'make install PREFIX=/path/to/texmf' to install to custom texmf directory;"
	@echo "    - 'make tdszip' to create TDS.ZIP files for automated installation in TEXMF tree;"
	@echo "    - 'make dist' to generate a distribution ZIP file, ready to upload to CTAN;"
	@echo "    - 'make versionlist' to list the version information in the packages."
	@echo ""
	@echo "You may also run make on individual packages.  Run 'make' or 'make help' within"
	@echo "the corresponding subdirectory for more info."
	@echo ""

# ------------------------------------------------
# make clean, make cleanall
# ------------------------------------------------

ALLCLEANCMDS = $(foreach x,$(ALLPKGS),$(MAKE) -C $(x) clean && ) true
ALLCLEANALLCMDS = $(foreach x,$(ALLPKGS),$(MAKE) -C $(x) cleanall && ) true

ALLLINKPKGMK = $(foreach x,$(ALLPKGS),$(x)/pkg.mk)

clean:
	$(ALLCLEANCMDS)

cleanall:
	$(ALLCLEANALLCMDS)
	@rm -f $(ALLLINKPKGMK)

# ------------------------------------------------
# make sty
# ------------------------------------------------

ALLSTYCMDS = $(foreach x,$(ALLPKGS),$(MAKE) -C $(x) sty && ) true

sty:
	$(ALLSTYCMDS)

cleansty:
	@rm -f $(ALLSTY)

# ------------------------------------------------
# make pdf
# ------------------------------------------------

ALLPDFCMDS = $(foreach x,$(ALLPKGS),$(MAKE) -C $(x) pdf && ) true

pdf:
	$(ALLPDFCMDS)

cleanpdf:
	@rm -f $(ALLPDF)

# ------------------------------------------------
# make cleanaux
# ------------------------------------------------

ALLCLEANAUXCMDS = $(foreach x,$(ALLPKGS),$(MAKE) -C $(x) cleanaux && ) true

cleanaux:
	$(ALLCLEANAUXCMDS)

# ------------------------------------------------
# make install
# ------------------------------------------------

ALLINSTALLCMDS = $(foreach x,$(ALLPKGS),$(MAKE) -C $(x) install PREFIX="$(PREFIX)" && ) true

install:
	$(ALLINSTALLCMDS)


# ------------------------------------------------
# make tdszip
# ------------------------------------------------

ALLTDSZIPCMDS = $(foreach x,$(ALLPKGS),$(MAKE) -C $(x) tdszip && ) true
ALLCLEANTDSZIPCMDS = $(foreach x,$(ALLPKGS),$(MAKE) -C $(x) cleantdszip && ) true

tdszip:
	$(ALLTDSZIPCMDS)

cleantdszip:
	$(ALLCLEANTDSZIPCMDS)

# ------------------------------------------------
# make dist
# ------------------------------------------------

ALLDISTCMDS = $(foreach x,$(ALLPKGS),$(MAKE) -C $(x) dist && ) true
ALLCLEANDISTCMDS = $(foreach x,$(ALLPKGS),$(MAKE) -C $(x) cleandist && ) true

dist: versionlist
	$(ALLDISTCMDS)

cleandist: 
	$(ALLCLEANDISTCMDS)

# ------------------------------------------------
# make versionlist
# ------------------------------------------------

versionlist:
	@echo
	@echo
	@echo "================================================================================"
	@echo
	@echo "Individual package versions: "
	@egrep -h '\[.* phf\w+ package\]' $(ALLDTX)
	@echo
	@echo "================================================================================"
	@echo


# -------------------------------------------------
# make phfnote, make phfXXX
# -------------------------------------------------

$(ALLPKGS):
	@echo "Don't run 'make $@', run 'make' or 'make help' for more information"
	exit 1
