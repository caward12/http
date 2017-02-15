gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/http_iteration3'
require 'faraday'

class HttpIteration2Test < Minitest::Test

  def test_it_exists
    skip
    server = HTTP.new

    assert_instance_of HTTP, server
  end

  def test_it_can_handle_root
    skip
    response = Faraday.get 'http://127.0.0.1:9292'

    expected = %Q[Verb: GET
   Path: /
   Protocol: HTTP/1.1
   Host: Faraday
   Port:
   Origin: Faraday
   Accept:
</body></html>]

    assert_equal expected, response.body.split("<pre>")[1]
  end

  def test_it_knows_hello_path
    skip
    response = Faraday.get 'http://127.0.0.1:9292/hello'

    assert_equal "GET", response.body.split
  end


  def test_it_can_handle_hello
    skip
    response = Faraday.get 'http://127.0.0.1:9292/hello'

    assert_equal "<html><head></head><body><h1>Hello, World! (0)", response.body.split("</h1>")[0]
  end

  def test_it_can_handle_hello_and_count
    skip
    response = Faraday.get 'http://127.0.0.1:9292/hello'
    assert_equal "<html><head></head><body><h1>Hello, World! (0)", response.body.split("</h1>")[0]

    response2 = Faraday.get 'http://127.0.0.1:9292/hello'
    assert_equal "<html><head></head><body><h1>Hello, World! (1)", response2.body.split("</h1>")[0]
  end

  def test_it_can_handle_datetime
    skip
    response = Faraday.get 'http://127.0.0.1:9292/datetime'

    assert_equal "<html><head></head><body><h5>" + Time.now.strftime('%l:%M %p on %A, %B %e, %Y'), response.body.split("</h5>")[0]
  end

  def test_it_can_handle_shutdown
    skip
    response = Faraday.get 'http://127.0.0.1:9292/datetime'
    response = Faraday.get 'http://127.0.0.1:9292/shutdown'

    assert_equal "<html><head></head><body><h5> total requests: 2", response.body.split("</h5>")[0]
  end

  def test_it_can_handle_dictionary
    skip
    response = Faraday.get 'http://127.0.0.1:9292/word_search?word=t'

    assert_equal "<html><head></head><body>T is a known word    ", response.body.split("<pre>")[0]
  end

  def test_it_can_handle_other_words
    skip
    response = Faraday.get 'http://127.0.0.1:9292/word_search?word=game'

    assert_equal "<html><head></head><body>GAME is a known word    ", response.body.split("<pre>")[0]
  end

  def test_it_can_handle_non_words
    skip
    response = Faraday.get 'http://127.0.0.1:9292/word_search?word=alksjd'

    assert_equal "<html><head></head><body>ALKSJD is not a known word    ", response.body.split("<pre>")[0]
  end

  def test_it_can_handle_startgame
    skip
    response = Faraday.post 'http://127.0.0.1:9292/start_game'

    assert_equal "<html><head></head><body>Good Luck!     ", response.body.split("<pre>")[0]
  end

  def test_it_can_post_to_game
    response = Faraday.post 'http://127.0.0.1:9292/game?guess=23'

    assert_equal "<html><head></head><body>You've made 1 guess and it was too high.     ", response.body.split("<pre>")[0]
  end

end
