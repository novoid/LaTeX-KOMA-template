## please modify the following line for naming the end products (PDFs, ZIPs, ...)
PROJECTNAME = "Projectname"

## -----------------------------------------
##       DO NOT EDIT BELOW THIS LINE
## -----------------------------------------

## Makefile von Karl Voit (Karl@Voit.net)

## some Makefile-hints taken from: 
## http://www.ctan.org/tex-archive/help/uk-tex-faq/Makefile


MAINDOCUMENTBASENAME = main
MAINDOCUMENTFILENAME = ${MAINDOCUMENTBASENAME}.tex
## COMMANDS:
PDFLATEX_CMD = pdflatex
#BIBTEX_CMD = bibtex
BIBTEX_CMD = biber
MAKEIDX_CMD = makeindex
DATESTAMP = `/bin/date +%Y-%m-%d`
DATESTAMP_AND_PROJECT = ${DATESTAMP}_${PROJECTNAME}
#PDFVIEWER = xpdf
PDFVIEWER = acroread
TEMPLATEDOCUBASENAME = Template-Documentation
TEMPLATEDOCUFILE = ${TEMPLATEDOCUBASENAME}.tex

#help
#helpThe main targets of this Makefile are:
#help	help	this help
.PHONY: help
help:
	@sed -n 's/^#help//p' < Makefile

#help	all	see "pdf"
.PHONY: all
all: pdf

#help	pdf	creates a pdf file using pdflatex
.PHONY: pdf
pdf:
	${PDFLATEX_CMD} ${MAINDOCUMENTFILENAME}
	-${BIBTEX_CMD} ${MAINDOCUMENTBASENAME}
	${PDFLATEX_CMD} ${MAINDOCUMENTFILENAME}
	${PDFLATEX_CMD} ${MAINDOCUMENTFILENAME}
	-mv ${MAINDOCUMENTBASENAME}.pdf ${DATESTAMP_AND_PROJECT}.pdf

#help	wc	counts the words from the PDF generated
wc:	pdf
	pdftops ${DATESTAMP_AND_PROJECT}.pdf
	ps2ascii ${DATESTAMP_AND_PROJECT}.ps > ${DATESTAMP_AND_PROJECT}.txt
	wc -w ${DATESTAMP_AND_PROJECT}.txt


# --------------------------------------------------------

#help	view	view the PDF-file
.PHONY: view
view: pdf
	${PDFVIEWER} ${DATESTAMP_AND_PROJECT}.pdf

# --------------------------------------------------------


#help	clean	clean up temporary files
.PHONY: clean
clean: 
	-rm -r *.bcf *.run.xml _*_.* *~ *.aux *-blx.bib *.bbl ${MAINDOCUMENTBASENAME}.dvi *.ps *.blg *.idx *.ilg *.ind *.toc *.log *.log *.brf *.out *.lof *.lot *.gxg *.glx *.gxs *.glo *.gls *.tdo -f

#help	purge	cleaner than clean ;-)
.PHONY: purge
purge: clean
	-rm 20*.pdf *.ps -f

#help	force	force rebuild next run
.PHONY: force
force:
	touch *tex

# TOOLS:

#help	zip	create ZIP-file
.PHONY: zip
zip: purge pdf clean
	zip -r ../${PROJECTNAME}_${TIMESTAMP}.zip *

.PHONY: publish
publish: templatedocu pdf clean
	-rm 20*.pdf ${TEMPLATEDOCUFILE} -f
	git status

#help	templatedocu	updates tex-files for the documentation of this template
#help			needs: echo, sed, grep
.PHONY: templatedocu
templatedocu:
	grep "%doc%" template/preamble.tex | sed 's/^.*%doc% //' > ${TEMPLATEDOCUFILE}
	grep "%doc%" template/mycommands.tex | sed 's/^.*%doc% //' >> ${TEMPLATEDOCUFILE}
	grep "%doc%" template/typographic_settings.tex | sed 's/^.*%doc% //' >> ${TEMPLATEDOCUFILE}
	grep "%doc%" template/pdf_settings.tex | sed 's/^.*%doc% //' >> ${TEMPLATEDOCUFILE}
	echo "%%---------------------------------------%%" >>${TEMPLATEDOCUFILE}
	echo "\printbibliography\end{document}" >>${TEMPLATEDOCUFILE}
	${PDFLATEX_CMD} ${TEMPLATEDOCUFILE}
	${PDFLATEX_CMD} ${TEMPLATEDOCUFILE}
	${BIBTEX_CMD} ${TEMPLATEDOCUBASENAME}
	${PDFLATEX_CMD} ${TEMPLATEDOCUFILE}


#end

