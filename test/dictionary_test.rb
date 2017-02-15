gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/dictionary'

class DictionaryTest < Minitest::Test
  def test_it_exists
    dictionary2 = Dictionary.new

    assert_instance_of Dictionary, dictionary2
  end

  def test_it_knows_if_its_a_word
    dictionary2 = Dictionary.new

    assert_equal "EXTRA is a known word", dictionary2.word_in_dictionary("extra")
    assert_equal "WORD is a known word", dictionary2.word_in_dictionary("word")
    assert_equal "I is a known word", dictionary2.word_in_dictionary("i")
  end

  def test_it_knows_its_not_a_word
    dictionary2 = Dictionary.new

    assert_equal "ALKSJDOPV is not a known word", dictionary2.word_in_dictionary("alksjdopv")
    assert_equal ";LKA/.S,DMVK is not a known word", dictionary2.word_in_dictionary(";lka/.s,dmvk")
    assert_equal "LIBARY is not a known word", dictionary2.word_in_dictionary("libary")
  end

end
