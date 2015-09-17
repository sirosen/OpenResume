require 'json'
require 'erb'

require_relative 'common'

def texify_ampersands obj
  texify_str = Proc.new do |s|
    s.gsub(/(?<!\\)(?:\\{2})*\K&/) do |match|
      "#{"\\"*2}&"
    end
  end

  proc_over_json(texify_str, obj)
end

def texify_subscripts obj
  texify_str = Proc.new do |s|
    s.gsub(/(?<!\\)(?:\\{2})*_\K[^\s]*/) do |match|
      "$_{#{match}}$"
    end
  end

  proc_over_json(texify_str, obj)
end

def render_to_tex(sourcefile, texfile)
  json_str = File.read(sourcefile)
  json_obj = JSON.parse(json_str)
  json_obj = texify_ampersands json_obj
  json_obj = texify_subscripts json_obj
  json_obj = unescape_chars json_obj

  heading = json_obj['heading']

  twocolumn = false

  sections = []
  ordered_sections(json_obj).each do |jsonsection|
    if jsonsection == :columnbreak
      if not twocolumn
        twocolumn = true
        sections << {'is_columnbreak' => true}
      end

      next
    end

    section = {}
    section['title'] = jsonsection['title']
    section['sub'] = []

    ordered_subsections(jsonsection).each do |subsection|
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

  tex_template = get_template('tex')
  File.open(texfile, 'w') { |f|
    f.write(ERB.new(File.read(tex_template), 0, '-<>').result(binding))
  }
end
