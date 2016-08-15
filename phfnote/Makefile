
PKG = phfnote

DIST_ADDITIONAL_FILES = naturemagdoi.bst

-include pkg.mk

pkg.mk:
	ln -sf ../mkcommon/pkg.mk pkg.mk

install:  install_sty install_doc
	mkdir -p $(DESTDIR)$(PREFIX)/bibtex/bst/$(PKG)
	cp naturemagdoi.bst  $(DESTDIR)$(PREFIX)/bibtex/bst/$(PKG)

