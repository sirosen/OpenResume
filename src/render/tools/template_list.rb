def get_template(format)
  render_dir = File.dirname(File.dirname(__FILE__))
  template_dir = File.join(render_dir, 'templates')

  return File.join(template_dir, "#{format}.erb")
end
