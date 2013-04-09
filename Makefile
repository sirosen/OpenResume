all: resume tidy

resume:
	pdflatex -interaction batchmode resume.tex

tidy:
	rm -f *.log *.aux

clean:
	make tidy
	rm -f *.pdf
