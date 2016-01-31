class WebSpellchecker <Spellchecker
  
  def initialize
  end

  def known(words)
    wordrecords= DictionaryWord.select("word, count").where(word: words).order(count: :desc)
    
    return wordrecords.map{|x| x[:word]}
  end
  
  

end
