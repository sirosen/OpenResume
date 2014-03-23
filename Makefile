.PHONY: all tidy clean

all: resume tidy

resume: resume.tex
	pdflatex -interaction batchmode resume.tex

tidy:
	rm -f *.log *.aux *.out

clean:
	make tidy
	rm -f *.pdf
