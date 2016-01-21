require 'set'

class Spellchecker

  
  ALPHABET = 'abcdefghijklmnopqrstuvwxyz'

  #constructor.
  #text_file_name is the path to a local file with text to train the model (find actual words and their #frequency)
  #verbose is a flag to show traces of what's going on (useful for large files)
  def initialize(text_file_name)
    #read file text_file_name
    #extract words from string (file contents) using method 'words' below.
    #put in dictionary with their frequency (calling train! method)
  end

  def dictionary
    #getter for instance attribute
  end
  
  #returns an array of words in the text.
  def words (text)
    return text.downcase.scan(/[a-z]+/) #find all matches of this simple regular expression
  end

  #train model (create dictionary)
  def train!(word_list)
    #create @dictionary, an attribute of type Hash mapping words to their count in the text {word => count}. Default count should be 0 (argument of Hash constructor).
  end

  #lookup frequency of a word, a simple lookup in the @dictionary Hash
  def lookup(word)
  end
  
  #generate all correction candidates at an edit distance of 1 from the input word.
  def edits1(word)
    
    deletes    = []
    #all strings obtained by deleting a letter (each letter)
    transposes = []
    #all strings obtained by switching two consecutive letters
    inserts = []
    # all strings obtained by inserting letters (all possible letters in all possible positions)
    replaces = []
    #all strings obtained by replacing letters (all possible letters in all possible positions)

    return (deletes + transposes + replaces + inserts).to_set.to_a #eliminate duplicates, then convert back to array
  end
  

  # find known (in dictionary) distance-2 edits of target word.
  def known_edits2 (word)
    # get every possible distance - 2 edit of the input word. Return those that are in the dictionary.
  end

  #return subset of the input words (argument is an array) that are known by this dictionary
  def known(words)
    return words.find_all {true } #find all words for which condition is true,
                                    #you need to figure out this condition
    
  end


  # if word is known, then
  # returns [word], 
  # else if there are valid distance-1 replacements, 
  # returns distance-1 replacements sorted by descending frequency in the model
  # else if there are valid distance-2 replacements,
  # returns distance-2 replacements sorted by descending frequency in the model
  # else returns nil
  def correct(word)
  end
    
  
end

