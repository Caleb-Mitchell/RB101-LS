def word_sizes(string)
  word_size_count = Hash.new(0)

  string.split.each do |word|
    clean_word = word.delete('^a-zA-Z')
    word_size_count[clean_word.size] += 1
  end

  word_size_count
end

puts word_sizes('Four score and seven.') == { 3 => 1, 4 => 1, 5 => 2 }
puts word_sizes('Hey diddle diddle, the cat and the fiddle!') == { 3 => 5, 6 => 3 }
puts word_sizes("What's up doc?") == { 5 => 1, 2 => 1, 3 => 1 }
puts word_sizes('') == {}
