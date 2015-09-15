require 'json'
require 'erb'

require_relative 'json_tools'

def texify_ampersands obj
  texify_str = Proc.new do |s|
    s.gsub('&','\\\\&')
    s.gsub(/(?<!\\)(?:\\{2})*\K&/) do |match|
      "#{"\\"*4}&"
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

  items = []
  ordered_sections.each do |section_name|
    if section_name == '<columnbreak>'
      if not twocolumn
        twocolumn = true
        items << {'is_columnbreak' => true}
      end

      next
    end

    section = json_obj['sections'][section_name]
    ordered_subsections = section['ordered_sub']
    item = {}
    item['title'] = section['title']
    item['sub'] = []

    ordered_subsections.each do |sub_name|
      sub_item = section['subsections'][sub_name]
      if sub_item['itemstyle'].nil?
        sub_item['itemstyle'] = 'list'
      end

      if sub_item['itemstyle'] == 'two_col'
        if sub_item['tex']
          (sub_item['tex']['itemstyles'] rescue {}).each do |k, v|
            sub_item['items'].each do |twocol_item|
              twocol_item[k] = "#{v['prefix']}#{twocol_item[k]}#{v['suffix']}"
            end
          end
        end
      end

      item['sub'] << sub_item
    end

    items << item
  end

  File.open(texfile, 'w') { |f|
    f.write(ERB.new(File.read(textemplate), 0, '-<>').result(binding))
  }
end
