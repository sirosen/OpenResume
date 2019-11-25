require 'erb'
require 'json'

def filename_to_json(filename)
  json_str = File.read(filename)
  return JSON.parse(json_str)
end

def render_template(templatename, destination, binding)
  File.open(destination, 'w') { |f|
    f.write(ERB.new(File.read(templatename), 0, '-<>').result(binding))
  }
end

def proc_over_json(func, obj)
  if obj.is_a? String
    return func.call(obj)
  elsif obj.is_a? Array
    return obj.collect{ |elem| proc_over_json(func, elem) }
  elsif obj.is_a? Hash
    new = {}
    obj.each do |k,v|
      new[k] = proc_over_json(func, v)
    end
    return new
  end
end

def unescape_chars obj
  reduce_escapes = Proc.new do |s|
    s.gsub(/\\./) do |match|
      match[-1]
    end
  end

  proc_over_json(reduce_escapes, obj)
end

def get_template(format)
  return File.join(File.dirname(__FILE__), "templates", "#{format}.erb")
end

def process_subsections(section, func: nil)
  subs = []
  section["subsections"].each do |sub|
    if sub['itemstyle'].nil?
      sub['itemstyle'] = 'list'
    end

    if sub['itemstyle'] == 'commasep'
      sub['separator'] = "#{sub['separator'] || ','} "
    end

    if func
      sub = func.call(sub)
    end

    subs << sub
  end

  return subs
end
