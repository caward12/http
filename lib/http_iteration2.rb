require 'socket'
require 'pry'
class HTTP

  attr_reader :tcp_server, :counter, :request_lines, :response, :path
  def initialize
    @tcp_server = TCPServer.new(9292)
    @counter = 0
    @request_lines = []
    @number_of_requests = 0
    @response = response
    @path = path
    @shutdown_server = false
  end

  def get_diagnostics(request_lines, path)
    verb = request_lines[0].split[0]
    path = request_lines[0].split[1]
    protocol = request_lines[0].split[2]
    host = request_lines[1].split[1]
    port = request_lines[1].split(":")[2]
    origin = request_lines[1].split[1]
    accept = request_lines[6]

    @header_string = <<END_OF_HEADERS
    <pre>
    Verb: #{verb}
    Path: #{path}
    Protocol: #{protocol}
    Host: #{host}
    Port: #{port}
    Origin: #{origin}
    Accept: #{accept}
END_OF_HEADERS
    @header_string
  end

  def handle_root
    get_diagnostics(request_lines, path)
    @response = @header_string
  end

  def handle_hello
    get_diagnostics(request_lines, path)
    @response = "<h1>Hello, World! (#{counter})</h1> \n\n #{@header_string}"
    @counter +=1
  end

  def handle_datetime
    get_diagnostics(request_lines, path)
    @response = "<h5>#{Time.now.strftime('%l:%M %p on %A, %B %e, %Y')}</h5> \n\n #{@header_string}"
  end

  def handle_shutdown
    get_diagnostics(request_lines, path)
    @shutdown_server = true
    @response = "<h5> total requests: #{@number_of_requests}</h5> \n\n #{@header_string}"
  end

  def determine_path(request_lines, path)
    if path == '/hello'
      response = handle_hello
    elsif path == '/datetime'
      response = handle_datetime
    elsif path == '/shutdown'
      response = handle_shutdown
    else
      response = handle_root
    end
    @response
  end


  def get_request
    while @shutdown_server ==false
      client = tcp_server.accept
      puts "Ready for a request"
      @request_lines = []
      while line = client.gets and !line.chomp.empty?
        @request_lines << line.chomp
      end

      @path = @request_lines[0].split[1]

      @number_of_requests +=1

      determine_path(@request_lines, @path)

      output = "<html><head></head><body>#{@response}</body></html>"
      headers = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{output.length}\r\n\r\n"].join("\r\n")
      client.puts headers
      client.print output

      #binding.pry

    end
    client.close
  end
end
# http = HTTP.new
# http.get_request
