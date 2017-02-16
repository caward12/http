gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/diagnostics'

class DiagnosticsTest < Minitest::Test


  def test_it_can_read_lines

    diagnostics = Diagnostics.new(["GET / HTTP/1.1",
     "Host: 127.0.0.1:9292",
     "Connection: keep-alive",
     "Cache-Control: max-age=0",
     "Upgrade-Insecure-Requests: 1",
     "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36",
     "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
     "Accept-Encoding: gzip, deflate, sdch, br",
     "Accept-Language: en-US,en;q=0.8"], "/")

    assert_equal "127.0.0.1:9292", diagnostics.host
    assert_equal "HTTP/1.1", diagnostics.protocol
    assert_equal "GET", diagnostics.verb
    assert_equal "9292", diagnostics.port
    assert_equal "/", diagnostics.path
  end

  def test_it_can_read_differnt_lines

    diagnostics = Diagnostics.new(["POST /start_game HTTP/1.1",
   "Host: 127.0.0.1:9292",
   "Connection: keep-alive",
   "Content-Length: 8",
   "Postman-Token: baaa5700-fa32-9dd5-c186-02851512948e",
   "Cache-Control: no-cache",
   "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
   "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36",
   "Content-Type: application/x-www-form-urlencoded",
   "Accept: */*",
   "Accept-Encoding: gzip, deflate, br",
   "Accept-Language: en-US,en;q=0.8"], "/start_game")

   assert_equal "127.0.0.1:9292", diagnostics.host
   assert_equal "HTTP/1.1", diagnostics.protocol
   assert_equal "POST", diagnostics.verb
   assert_equal "9292", diagnostics.port
   assert_equal "/start_game", diagnostics.path 
  end




end
