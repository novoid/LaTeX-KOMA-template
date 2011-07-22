## please modify following line for naming the end products (PDFs, ZIPs, ...)
PROJECTNAME = "Projectname"

## -----------------------------------------
##       DO NOT EDIT BELOW THIS LINE
## -----------------------------------------

## Makefile von Karl Voit (Karl@Voit.net)

## some Makefile-hints taken from: 
## http://www.ctan.org/tex-archive/help/uk-tex-faq/Makefile


MAINDOCUMENT = "main"
## COMMANDS:
PDFLATEX_CMD = pdflatex
LATEX_CMD = latex
DVIPS_CMD = dvips
BIBTEX_CMD = bibtex
MAKEIDX_CMD = makeindex
DATESTAMP = `/bin/date +%Y-%m-%d`
DATESTAMP_AND_PROJECT = ${DATESTAMP}_${PROJECTNAME}
#PDFVIEWER = xpdf
PDFVIEWER = acroread
DVIVIEWER = xdvi
TEMPLATEDOCUFILE = template_documentation.tex

#help
#helpThe main targets of this Makefile are:
#help	help	this help
.PHONY: help
help:
	@sed -n 's/^#help//p' < Makefile

#help	all	see "pdf"
.PHONY: all
all: pdf

#help	ps	makes a ps-file
.PHONY: ps
ps: dvi
	${DVIPS_CMD} ${MAINDOCUMENT}.dvi -o ${DATESTAMP_AND_PROJECT}.ps

#help	pdf	makes a file per pdflatex
.PHONY: pdf
pdf: templatedocu
	${PDFLATEX_CMD} ${MAINDOCUMENT}.tex
	${PDFLATEX_CMD} ${MAINDOCUMENT}.tex
	-${BIBTEX_CMD} ${MAINDOCUMENT}
	${PDFLATEX_CMD} ${MAINDOCUMENT}.tex
	-mv ${MAINDOCUMENT}.pdf ${DATESTAMP_AND_PROJECT}.pdf

#help	wc	counts the words from the PDF generated
wc:	pdf
	pdftops ${DATESTAMP_AND_PROJECT}.pdf
	ps2ascii ${DATESTAMP_AND_PROJECT}.ps > ${DATESTAMP_AND_PROJECT}.txt
	wc -w ${DATESTAMP_AND_PROJECT}.txt

#help	dvi	generates a DVI-file
.PHONY: dvi
dvi:
	${LATEX_CMD} ${MAINDOCUMENT}.tex

# --------------------------------------------------------

#help	view	view the PDF-file
.PHONY: view
view: pdf
	${PDFVIEWER} *_${PROJECTNAME}.pdf

# --------------------------------------------------------


#help	clean	clean up temporary files
.PHONY: clean
clean: templatedocu
	-rm -r _*_.* *~ *.aux *.bbl ${MAINDOCUMENT}.dvi *.ps *.blg *.idx *.ilg *.ind *.toc *.log *.log *.brf *.out *.lof *.lot *.gxg *.glx *.gxs *.glo *.gls -f

#help	purge	cleaner than clean ;-)
.PHONY: purge
purge: clean
	-rm *.pdf *.ps -f

#help	force	force rebuild next run
.PHONY: force
force:
	touch *tex

# TOOLS:

#help	tar	create TAR.GZ-file
.PHONY: tar
tar: clean
	tar -czf ../${PROJECTNAME}_${TIMESTAMP}.tar.gz *

#help	zip	create ZIP-file
.PHONY: zip
zip: purge pdf clean
	zip -r ../${PROJECTNAME}_${TIMESTAMP}.zip *

#help	templatedocu	updates tex-files for the documentation of this template
.PHONY: templatedocu
templatedocu:
	grep "%doc%" preamble/preamble.tex | sed 's/^.*%doc% //' > ${TEMPLATEDOCUFILE}
	grep "%doc%" preamble/typographic_settings.tex | sed 's/^.*%doc% //' >> ${TEMPLATEDOCUFILE}
	grep "%doc%" preamble/pdf_settings.tex | sed 's/^.*%doc% //' >> ${TEMPLATEDOCUFILE}

## Hinweis: dies Methode der getrennten PDF-Dateien (siehe mv-Befehl bei
##          der Regel "%pdf: %.tex") hat Vor- und Nachteile:
##          + Akutalität bei view wird erkannt
##          + Endprodukte sind leicht erkennbar/"startbar"
##          - Getrenntes Loeschen der beiden PDFs bewirkt Fehlverhalten beim Loeschen ...
##              * ... von basename.pdf: Unnoetiges Neuerstellen von PROJEKTNAME_basename.pdf
##                                      --> 1x umsonst berechnet
##              * ... von PROJEKTNAME_basename.pdf: make meint, Ziel waere aktuell
##                                      --> Korrektur durch Loeschen von basename.pdf
##          Alternative(n):
##          * extra Regeln fuer slides.pdf und radastro.pdf
##              - Unflexibel, unuebersichtlich
##              + obige Fehlverhalten verhindert
##          * simples Script wie zB:
##
## (example taken from: http://xpt.sourceforge.net/techdocs/Latex/MakefileForTeX/latex08.000.html)
##
## example:  RERUN = "(There were undefined references|Rerun to get (cross-references|the bars) right)"
## example:  RERUNBIB = "No file.*\.bbl|Citation.*undefined" 
## example:  
## example:  GOALS = enonce.ps enonce.pdf
## example:  DVIFILES = enonce.dvi 
## example:  
## example:  COPY = if test -r $*.toc; then cp $*.toc $*.toc.bak; fi RM = /usr/bin/rm -f 
## example:  
## example:  
## example:  main:           $(DVIFILES)
## example:  
## example:  all:            $(GOALS)
## example:  
## example:  %.dvi:          %.tex
## example:                  $(COPY);$(LATEX) $<
## example:                  egrep -c $(RERUNBIB) $*.log && ($(BIBTEX) $*;$(COPY);$(LATEX) $<) ;
## example:  true
## example:                  egrep $(RERUN) $*.log && ($(COPY);$(LATEX) $<) ; true
## example:                  egrep $(RERUN) $*.log && ($(COPY);$(LATEX) $<) ; true
## example:                  if cmp -s $*.toc $*.toc.bak; then . ;else $(LATEX) $< ; fi
## example:                  $(RM) $*.toc.bak
## example:  # Display relevant warnings
## example:                  egrep -i "(Reference|Citation).*undefined" $*.log ; true
## example:  
## example:  %.ps:           %.dvi
## example:                  dvips $< -o $@
## example:  
## example:  %.pdf:          %.ps
## example:                  $(PDFLATEX) $<


#end
