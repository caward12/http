require 'socket'
require 'pry'
require './lib/dictionary'
class HTTP

  attr_reader :tcp_server, :counter, :request_lines, :response, :path, :guess_counter
  def initialize
    @tcp_server = TCPServer.new(9292)
    @counter = 0
    @request_lines = []
    @number_of_requests = 0
    @response = response
    @path = path
    @shutdown_server = false
    @dictionary = Dictionary.new
    @guess_counter = 0
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

  def handle_dictionary
    get_diagnostics(request_lines, path)
    word = path.split("=")[1]
    @response = @dictionary.word_in_dictionary(word) + @header_string
  end

  def start_game
    get_diagnostics(request_lines, path)
    number=Random.new
    @random_number= number.rand(100)

    @response = "Good Luck! #{@header_string}"
  end

  def post_game
    guess = path.split("=")[1].to_i
    get_game(guess)
  end

  def get_game(guess)
    get_diagnostics(request_lines, path)
    @guess_counter +=1
    answer = ""
    #binding.pry
    if guess > @random_number
      answer << "was too high."
    elsif guess < @random_number
      answer << "was too low."
    else
      answer << "was correct!"
    end
    @response = "You've made #{guess_counter} guess(es) and it " + answer + @header_string
  end

  def determine_path(request_lines, path)
    if path == '/hello'
      response = handle_hello
    elsif path == '/datetime'
      response = handle_datetime
    elsif path == '/shutdown'
      response = handle_shutdown
    elsif path.include?("/word_search")
      response = handle_dictionary
    elsif path == '/start_game'
      response = start_game
    elsif path.include?("/game?")
      response = post_game
    else
      response = handle_root
    end
    @response
  end


  def get_request

    while @shutdown_server == false
      client = tcp_server.accept
      puts "Ready for a request"
      @request_lines = []
      while line = client.gets and !line.chomp.empty?
        @request_lines << line.chomp
      end
      #binding.pry
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
