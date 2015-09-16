require "optparse"
require "ostruct"
require "set"

def ostruct_memberset ostruct
  ostruct.to_h.keys.to_set
end

class ResumeBuilderOptparser
  @required_args = Set.new [:source, :tex, :html, :pdf, :png]

  def self.gen_parser(option_struct)
    parser = OptionParser.new do |opts|
      opts.on("-s", "--source SOURCE_JSON") do |source|
        option_struct.source = source
      end
      opts.on("--tex TEX_TARGET") do |tex|
        option_struct.tex = tex
      end
      opts.on("--html HTML_TARGET") do |html|
        option_struct.html = html
      end
      opts.on("--pdf PDF_TARGET") do |pdf|
        option_struct.pdf = pdf
      end
      opts.on("--png PNG_TARGET") do |png|
        option_struct.png = png
      end
    end
  end

  def self.unsafe_parse(args)
    options = OpenStruct.new

    parser = gen_parser options

    parser.parse!(args)
    if not @required_args.subset?(ostruct_memberset options)
      raise OptionParser::InvalidArgument.new("Missing Required Argument. Required args are #{@required_args.to_s}")
    end

    return options
  end

  def self.handle_parse_errors(&parse_proc)
    begin
      return parse_proc.call()
    rescue OptionParser::InvalidArgument
      puts 'Some bad error with args! Bad you! Bad me! Bad message!'
      exit 1
    end
  end

  def self.parse()
    return self.handle_parse_errors { self.unsafe_parse(ARGV) }
  end
end
