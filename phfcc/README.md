# The phfcc package

Utilities for inline commenting in collaborative documents.

Easily define helper macros to insert comments in a LaTeX document. A convenient syntax enables you to mark text additions (e.g., "... \phf{I'm adding this text} ..." or "... \phf I'm adding this text\endphf ..."), an in-line comment (e.g., "... We're the best \phf[I'm not sure about this.] ..."), and text removals (e.g., "... \phf*{remove me} ..."). New colors are assigned automatically to each commenter by default, and the appearance of all comments is highly customizable.

# Documentation

Run `make sty` to generate the style file, `make pdf` to generate the package
documentation, and `make install` to install the package in your local texmf
tree. Run 'make' or 'make help' for more info.


# Author and License

(C) 2020 Philippe Faist, philippe.faist@bluewin.ch

License: [LaTeX project public license](http://www.ctan.org/license/lppl1.3),
version 1.3 or above
