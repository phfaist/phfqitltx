# phfqitltx

Collection of LaTeX utility packages for scientific documents

These packages provide useful definitions which I use often when writing
scientific documents (and more specifically for quantum information theory).
Some packages may be of more general use (formatting notes as a short document,
full-page figures, quoting unformatted text, adding an SVN version watermark).
Other packages are meant for scientific documents (more advanced theorems/proofs
framework, handy parens in equations).  The phfqit package is specifically for
quantum information theory.

Each package version evolves independently, and each package is submitted
independently to CTAN.


# List of Packages

- `phfnote` — format documents for short notes.  Nicer title, saves more space
  on paper, and provides some handy definitions.  Choose between several presets
  to get your preferred document appearance.

- `phffullpagefigure` — as the package name suggests, place figures on full pages.
  The caption e.g. reads "Figure 1 (on next page): blah blah" and the figure
  may occupy the full next page.

- `phfquotetext` — quote verbatim text, from e.g. an email, without worrying
  about LaTeX special characters.  Differs from
  `\begin{verbatim}...\end{verbatim}` environment in that whitespace is not
  preformatted.

- `phfsvnwatermark` — add a watermark to your documents with the SVN ID, so that
  you know which document is which version

- `phfthm` — goodies for theorems and proofs.

- `phfparen` — cool definitions for mathematical parenthetic expressions.  Easy
  to resize, short code which is still readable.

- `phfqit` — some useful definitions for LaTeXing stuff in quantum information
  theory, which I use often

- `phfcc` — inline commenting in collaborative documents

- `phfextendedabstract` — Typeset extended abstracts for conferences, such as
  often encountered in quantum information theory.


# Installation

From source: clone this repo, then type

    > make install
    
to install into your local TEXMF tree.  For a list of available actions, type

    > make


# Package Documentation

Package documentation is provided via LaTeX' standard dtx scheme.  To build the
package documentation, run

    > make pdf


# License

(C) 2016-2021 Philippe Faist, philippe.faist@bluewin.ch

This material is subject to the [LaTeX Project Public License](http://www.ctan.org/license/lppl1.3),
version 1.3 or above.
