.PHONY: clean

all: tex/resume.tex.erb resume_source.json
	ruby src/main.rb --source resume_source.json \
		--tex tex/resume.tex --tex-template tex/resume.tex.erb \
		--pdf tex/resume.pdf --png tex/resume.png

clean:
	rm -f tex/resume.tex
