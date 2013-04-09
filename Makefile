all: resume tidy

resume:
	pdflatex -interaction batchmode resume.tex

tidy:
	rm *.log *.aux

clean:
	make tidy
	rm *.pdf
