require 'socket'
require 'pry'
class HTTP

  attr_reader :tcp_server, :counter
  def initialize
    @tcp_server = TCPServer.new(9292)
    @counter = 0

  end

  def get_request
    while client = tcp_server.accept
      puts "Ready for a request"
      request_lines = []
      while line = client.gets and !line.chomp.empty?
        request_lines << line.chomp
      end

      response = "<pre>" + request_lines.join("\n") + "</pre>"

      output = "<html><head></head><body>Hello, World! (#{counter})</body></html>"
      headers = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{output.length}\r\n\r\n"].join("\r\n")
      client.puts headers
      client.print output

      @counter += 1
      #binding.pry
    end
    client.close
  end
end
http = HTTP.new
http.get_request
