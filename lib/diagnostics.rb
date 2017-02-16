class Diagnostics

  attr_reader :verb, :path, :protocol, :host, :port, :origin, :accept 

  def initialize(request_lines, path)
    @verb = request_lines[0].split[0]
    @path = request_lines[0].split[1]
    @protocol = request_lines[0].split[2]
    @host = request_lines[1].split[1]
    @port = request_lines[1].split(":")[2]
    @origin = request_lines[1].split[1]
    @accept = request_lines[6]
  end

  def header_string
    header_string = <<END_OF_HEADERS
    <pre>
    Verb: #{@verb}
    Path: #{@path}
    Protocol: #{@protocol}
    Host: #{@host}
    Port: #{@port}
    Origin: #{@origin}
    Accept: #{@accept}
END_OF_HEADERS
    header_string
  end
end
