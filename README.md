# phfqitltx

LaTeX packages for QIT stuff which I use often

# List of Packages

- `phfnote` - format documents for short notes.  Nicer title, saves more space
  on paper, and provides some handy definitions

- `phfqit` - some useful definitions for LaTeXing stuff in quantum information
  theory, which I use often

- `phfparen` - cool definitions for mathematical parenthetic expressions.  Easy
  to resize, short code which is still readable.

- `phfquotetext` - quote verbatim text, from e.g. an email, without worrying
  about LaTeX special characters.  Differs from
  `\begin{verbatim}...\end{verbatim}` environment in that whitespace is not
  preformatted.

- `phfsvnwatermark` - add a watermark to your documents with the SVN ID, so that
  you know which document is which version

- `phffullpagefigure` - as the package name suggests, place figures on full pages.
  The caption e.g. reads "Figure 1 (on next page): blah blah" and the figure
  may occupy the full next page.


# Installation

From source: clone this repo, then type

    > make install
    
to install into your local TEXMF tree.  For a list of available actions, type

    > make


# Package Documentation

[Doc incomplete. Sorry. Check out the source code, there should be helpful
comments.]

IN PROGRESS -- the packages are currently migrating to fully documented DTX files.  Currently ready are:

  - `phfquotetext` --- ready
  - `phfnote` --- ready
  - `phfqit` --- ready
  - others hopefully coming soon!
