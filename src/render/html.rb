require 'json'
require 'erb'
require 'cgi'

require_relative 'common'

def escape_htmlchars obj
  escape_html = Proc.new do |s|
    CGI.escapeHTML(s)
  end

  proc_over_json(escape_html, obj)
end

def render_to_html(sourcefile, htmlfile)
  json_str = File.read(sourcefile)
  json_obj = JSON.parse(json_str)
  json_obj = escape_htmlchars(json_obj)
  json_obj = unescape_chars(json_obj)

  heading = json_obj['heading']

  sections = []
  ordered_sections(json_obj).each do |jsonsection|
    if jsonsection == :columnbreak
      next
    end

    section = {}
    section['title'] = jsonsection['title']
    section['sub'] = []

    ordered_subsections(jsonsection).each do |subsection|
      if subsection['itemstyle'].nil?
        subsection['itemstyle'] = 'list'
      end

      section['sub'] << subsection
    end

    sections << section
  end

  html_template = get_template('html')
  File.open(htmlfile, 'w') { |f|
    f.write(ERB.new(File.read(html_template), 0, '-<>').result(binding))
  }
end
