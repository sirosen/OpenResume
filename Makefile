.PHONY: all tidy clean

all: convert tidy

resume: resume.tex
	pdflatex -interaction batchmode resume.tex

convert: resume
	convert -alpha off -density 600 resume.pdf -quality 90 resume.png

tidy:
	rm -f *.log *.aux *.out

clean:
	make tidy
	rm -f *.pdf
	rm -f *.png
