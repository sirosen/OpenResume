.PHONY: clean

all: resume_source.json
	ruby src/main.rb --source resume_source.json \
		--tex output/resume.tex --html output/resume.html \
		--pdf output/resume.pdf --png output/resume.png 
