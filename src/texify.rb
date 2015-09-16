require 'json'
require 'erb'

require_relative 'json_tools'

def texify_ampersands obj
  texify_str = Proc.new do |s|
    s.gsub(/(?<!\\)(?:\\{2})*\K&/) do |match|
      "#{"\\"*2}&"
    end
  end

  apply_proc_over(texify_str, obj)
end

def texify_subscripts obj
  texify_str = Proc.new do |s|
    s.gsub(/(?<!\\)(?:\\{2})*_\K[^\s]*/) do |match|
      "$_{#{match}}$"
    end
  end

  apply_proc_over(texify_str, obj)
end

def render_to_tex(sourcefile, textemplate, texfile)
  json_str = File.read(sourcefile)
  json_obj = JSON.parse(json_str)
  json_obj = texify_ampersands(json_obj)
  json_obj = texify_subscripts(json_obj)
  json_obj = unescape_chars(json_obj)

  heading = json_obj['heading']
  ordered_sections = json_obj['ordered_sections']

  twocolumn = false

  sections = []
  ordered_sections.each do |section_name|
    if section_name == '<columnbreak>'
      if not twocolumn
        twocolumn = true
        sections << {'is_columnbreak' => true}
      end

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

      if subsection['itemstyle'] == 'two_col'
        if subsection['tex']
          (subsection['tex']['itemstyles'] rescue {}).each do |k, v|
            subsection['items'].each do |twocol_item|
              twocol_item[k] = "#{v['prefix']}#{twocol_item[k]}#{v['suffix']}"
            end
          end
        end
      end

      section['sub'] << subsection
    end

    sections << section
  end

  File.open(texfile, 'w') { |f|
    f.write(ERB.new(File.read(textemplate), 0, '-<>').result(binding))
  }
end
