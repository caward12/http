gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/http_iteration2'
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

    assert_equal "
   Verb: GET
   Path: /
   Protocol: HTTP/1.1
   Host: Faraday
   Port:
   Origin: Faraday
   Accept:
</body></html>", response.body.split("<pre>")[1]
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

end
