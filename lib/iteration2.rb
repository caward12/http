require 'socket'

class NewServer

  attr_reader :tcp_server, :client, :request_lines
  def initialize
    @tcp_server = TCPServer.new(9292)
    @counter = 0
    @client = client

  end

  def connect
    @client = @tcp_server.accept
    puts "Ready for a request"
    @request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    respond
  end

  def respond
      puts "Sending response."
      response = "Hello World!"
      output = "<html><head></head><body>#{response} (#{@counter})</body></html>"
      headers = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{output.length}\r\n\r\n"].join("\r\n")
      @client.puts headers
      @client.puts output
      @counter +=1

    @client.close
  end

end
server = NewServer.new
server.connect
