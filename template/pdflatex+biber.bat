REM =====================================================
REM  This is a batch file to compile using pdflatex and biber (biblatex).
REM  When used with TeXworks, add it as batch tool:
REM =====================================================
REM  English:
REM    Edit > Preferences ... > Typesetting > Processing tools
REM    + (new tool):
REM      Name: pdflatex+biber
REM      Program: (find this pdflatex+biber.bat on your disk and use it here)
REM      Arguments:
REM                  $fullname
REM                  $basename
REM      [x] View PDF after running
REM =====================================================
REM  German:
REM    Bearbeiten > Einstellungen ... > Textsatz > Verarbeitungsprogramme
REM    + (neues Verarbeitungsprogramm):
REM      Name: pdflatex+biber
REM      Befehl/Datei: (diese pdflatex+biber.bat im Laufwerk suchen und einbinden)
REM      Argumente:
REM                  $fullname
REM                  $basename
REM      [x] PDF nach Beendigung anzeigen
REM =====================================================
REM idea from:  http://tex.stackexchange.com/questions/69705/how-to-automate-using-biber-in-miktex-texworks
REM adopted by: Karl Voit, 2013-02-02
REM =====================================================

REM call pdflatex using parameters suitable for miktex:
miktex-pdftex.exe -synctex=1 -undump=pdflatex "%1"

REM generate the references metadata for biblatex (using biber):
biber.exe "%2"

REM call pdflatex twice to compile the references and finalize PDF:
miktex-pdftex.exe -synctex=1 -undump=pdflatex "%1"
miktex-pdftex.exe -synctex=1 -undump=pdflatex "%1"

REM end