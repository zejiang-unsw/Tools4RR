# Common portion of the Makefile for each lecture:
# everything except the definition of LEC
#   (Thanks, Jianan!)

WEBDIR = ../Web/assets/lectures
DROPBOXDIR = ~/Dropbox/Teaching/Tools4RR
R_OPTS=--no-save --no-restore --no-init-file --no-site-file # --vanilla, but without --no-environ

pdf: ${LEC}.pdf notes

${LEC}.pdf: ${LEC}.tex ../LaTeX/header.tex
	xelatex ${LEC}

notes: ${LEC}_withnotes.pdf
all: ${LEC}.pdf notes web dropbox
hw: ${LECNUM}_homework.pdf
hwsoln: ${LECNUM}_hw_solutions.pdf
hwsolns: hwsoln

${LECNUM}_homework.pdf: ${LECNUM}_homework.tex
	pdflatex $<

${LECNUM}_hw_solutions.pdf: ${LECNUM}_hw_solutions.tex
	pdflatex $<

${LEC}_withnotes.pdf: ${LEC}_withnotes.tex ../LaTeX/header.tex
	xelatex ${LEC}_withnotes
	pdfnup ${LEC}_withnotes.pdf --nup 1x2 --no-landscape --paper letterpaper --frame true --scale 0.9
	mv ${LEC}_withnotes-nup.pdf ${LEC}_withnotes.pdf

${LEC}_withnotes.tex: ${LEC}.tex ../Ruby/createVersionWithNotes.rb
	../Ruby/createVersionWithNotes.rb ${LEC}.tex ${LEC}_withnotes.tex

web: ${WEBDIR}/${LEC}.pdf ${WEBDIR}/${LEC}_withnotes.pdf

${WEBDIR}/${LEC}.pdf: ${LEC}.pdf
	cp ${LEC}.pdf ${WEBDIR}/

${WEBDIR}/${LEC}_withnotes.pdf: ${LEC}_withnotes.pdf
	cp ${LEC}_withnotes.pdf ${WEBDIR}/

dropbox: ${DROPBOXDIR}/${LEC}_withnotes.pdf

${DROPBOXDIR}/${LEC}_withnotes.pdf: ${LEC}_withnotes.pdf
	cp ${LEC}_withnotes.pdf ${DROPBOXDIR}/

clean:
	rm *.aux *.log *.nav *.out *.snm *.toc *.vrb
