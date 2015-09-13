require_relative 'args'
require_relative 'texify'

opts = ResumeBuilderOptparser.parse()

render_to_tex(opts.source, opts.textemplate, opts.tex)

`pdflatex -jobname "resume" -interaction batchmode -output-directory "tex/" "#{opts.tex}"`
if 'tex/resume.pdf' != opts.pdf
  `mv tex/resume.pdf #{opts.pdf}`
end
`cd tex; rm -f *.log *.aux *.out`
`rm -f #{opts.png}`
`convert -alpha off -density 600 "#{opts.pdf}" -quality 90 "#{opts.png}"`
