require 'json'
require 'erb'

require_relative 'tools/json'
require_relative 'tools/template_list'

def render_to_html(sourcefile, htmlfile)
  json_str = File.read(sourcefile)
  json_obj = JSON.parse(json_str)
  json_obj = unescape_chars(json_obj)

  heading = json_obj['heading']
  ordered_sections = json_obj['ordered_sections']

  sections = []
  ordered_sections.each do |section_name|
    if section_name == '<columnbreak>'
      next
    end

    jsonsection = json_obj['sections'][section_name]
    ordered_subsections = jsonsection['ordered_sub']
    section = {}
    section['title'] = jsonsection['title']
    section['sub'] = []

    ordered_subsections.each do |sub_name|
      subsection = jsonsection['subsections'][sub_name]
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
