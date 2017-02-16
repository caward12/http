
class Dictionary
  attr_reader :dictionary
  def initialize
    @dictionary = File.read("/usr/share/dict/words").split("\n")
  end

  def word_in_dictionary(word)
    if @dictionary.include?(word)
      "#{word.upcase} is a known word"
    else
      "#{word.upcase} is not a known word"
    end
  end

end
