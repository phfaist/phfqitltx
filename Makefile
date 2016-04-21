

LATEX = latex
PDFLATEX = pdflatex

MAKEINDEX = makeindex


phfnote.sty:	phfnote.dtx phfqitltx.ins
	$(LATEX) phfqitltx.ins


phfnote.aux: phfnote.dtx phfnote.sty
	$(PDFLATEX) phfnote.dtx
	$(PDFLATEX) phfnote.dtx

phfnote.ind: phfnote.dtx phfnote.aux

phfnote.idx: phfnote.dtx phfnote.ind
	$(MAKEINDEX) -s gind.ist phfnote.idx

phfnote.glo: phfnote.dtx phfnote.aux

phfnote.gls: phfnote.dtx phfnote.glo
	$(MAKEINDEX) -s gglo.ist -o phfnote.gls phfnote.glo

phfnote.pdf: phfnote.dtx phfnote.aux phfnote.idx phfnote.gls
	$(PDFLATEX) phfnote.dtx
	$(PDFLATEX) phfnote.dtx
	$(PDFLATEX) phfnote.dtx

