def apply_proc_over(func, obj)
  if obj.is_a? String
    return func.call(obj)
  elsif obj.is_a? Array
    return obj.collect{ |elem| apply_proc_over(func, elem) }
  elsif obj.is_a? Hash
    new = {}
    obj.each do |k,v|
      new[k] = apply_proc_over(func, v)
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

  apply_proc_over(reduce_escapes, obj)
end
