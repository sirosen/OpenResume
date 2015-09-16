require_relative 'args'
require_relative 'render/tex'
require_relative 'render/html'

src_dir = File.dirname(__FILE__)

opts = ResumeBuilderOptparser.parse()

render_to_tex(opts.source, opts.tex)
render_to_html(opts.source, opts.html)

`pdflatex -jobname "resume" -interaction batchmode -output-directory "output/" "#{opts.tex}"`
if 'output/resume.pdf' != opts.pdf
  `mv output/resume.pdf #{opts.pdf}`
end
`cd output; rm -f *.log *.aux *.out`
`rm -f #{opts.png}`
`convert -alpha off -density 600 "#{opts.pdf}" -quality 90 "#{opts.png}"`
