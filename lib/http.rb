require 'socket'
require './lib/dictionary'
require './lib/diagnostics'

class HTTP

  attr_reader :tcp_server, :counter, :request_lines, :response, :path, :guess_counter, :verb, :guess
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

  def handle_hello
    @response = "<h1>Hello, World! (#{counter})</h1>"
    @counter +=1
  end

  def handle_datetime
    @response = "<h5>#{Time.now.strftime('%l:%M %p on %A, %B %e, %Y')}</h5>"
  end

  def handle_shutdown
    @shutdown_server = true
    @response = "<h5> total requests: #{@number_of_requests}</h5>"
  end

  def handle_dictionary
    word = path.split("=")[1]
    @response = @dictionary.word_in_dictionary(word)
  end

  def start_game
    number=Random.new
    @random_number= number.rand(100)

    @response = "Let's play a game: pick a number between 0 and 100. Good Luck!"
  end

  def post_game(content_length)
    @guess = @client.read(content_length).split("=")[1].to_i
    @response = "You made a guess of: #{guess}"
  end

  def get_game(guess)
    @guess_counter +=1
    answer = ""
    if guess > @random_number
      answer << "was too high."
    elsif guess < @random_number
      answer << "was too low."
    else
      answer << "was correct!"
    end
    @response = "You've made #{guess_counter} guess(es) and your most recent guess of #{guess} " + answer
  end

  def determine_path(request_lines, path, verb)
    if path == '/hello'
      handle_hello
    elsif path == '/datetime'
      handle_datetime
    elsif path == '/shutdown'
      handle_shutdown
    elsif path.include?("/word_search")
      handle_dictionary
    elsif path == '/start_game' && verb == 'POST'
      start_game
    elsif path.include?('/game') && verb == 'POST'
      content_length = request_lines[3].split[1].to_i
      post_game(content_length)
    elsif path == '/game' && verb == 'GET'
      get_game(guess)
    else
      @response
    end
  end


  def request

    while @shutdown_server == false
      @client = tcp_server.accept
      puts "Ready for a request"
      @request_lines = []
      while line = @client.gets and !line.chomp.empty?
        @request_lines << line.chomp
      end

      @path = @request_lines[0].split[1]
      @verb = @request_lines[0].split[0]

      @number_of_requests +=1

      determine_path(@request_lines, @path, @verb)
      diagnostics = Diagnostics.new(request_lines, path)

      output = "<html><head></head><body>#{@response} #{diagnostics.header_string}</body></html>"
      headers = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{output.length}\r\n\r\n"].join("\r\n")
      @client.puts headers
      @client.puts output

    end
    @client.close
  end
end
