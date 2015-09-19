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
  json_obj = filename_to_json(sourcefile)
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

    modify_twocol_item = Proc.new do |subsection|
      if subsection['itemstyle'] == 'twocol' and subsection['tex']
        (subsection['tex']['itemstyles'] rescue {}).each do |k, v|
          subsection['items'].each do |twocol_item|
            twocol_item[k] = "#{v['prefix']}#{twocol_item[k]}#{v['suffix']}"
          end
        end
      end

      next subsection
    end

    section['sub'] = process_subsections(jsonsection,
                                         func: modify_twocol_item)

    sections << section
  end

  render_template(get_template('tex'), texfile, binding)
end
