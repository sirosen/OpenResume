require 'cgi'
require_relative 'common'


def escape_htmlchars obj
  escape_html = Proc.new do |s|
    CGI.escapeHTML(s)
  end

  proc_over_json(escape_html, obj)
end


def render_to_html(sourcefile, htmlfile)
  json_obj = filename_to_json(sourcefile)
  json_obj = escape_htmlchars(json_obj)
  json_obj = unescape_chars(json_obj)

  heading = json_obj['heading']
  sections = []

  json_obj["sections"].each do |jsonsection|
    if jsonsection == "COLUMNBREAK"
      next
    end

    section = {}
    section['title'] = jsonsection['title']
    section['sub'] = process_subsections(jsonsection)

    sections << section
  end

  render_template(get_template('html'), htmlfile, binding)
end
