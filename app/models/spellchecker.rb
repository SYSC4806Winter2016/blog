
class Spellchecker

  
  ALPHABET = 'abcdefghijklmnopqrstuvwxyz'

  #constructor.
  #text_file_name is the path to a local file with text to train the model (find actual words and their #frequency)
  #verbose is a flag to show traces of what's going on (useful for large files)
  def initialize(text_file_name, verbose=false)
    if verbose 
      puts "getting corpus"
    end
    atext = File.read(text_file_name)
    if verbose 
      puts "training!"
    end
    train!(words(atext.downcase))
  end
  
  def dictionary
    @dictionary
  end
  
  #returns an array of words in the text.
  def words (text)
    return text.scan(/[a-z]+/)
  end

  def train!(features)
    @dictionary = Hash.new(0)
    features.each do |f|
      @dictionary[f] += 1
    end
  end
  
  def edits1(word)
    splits     =  Array(0..word.length).map{|i| [word[0...i], word[i..word.length]]}
    deletes    = []
    transposes = []
    replaces = []
    inserts = []
    #use the splits to generate distance-1 edits, with an extra letter (insert) a word missing (delete), two consecutive letters switched, or replaced letters (replaces).
    splits.each do |a,b| 
      #delete
      drop =b[1..b.length]
      if (drop)
        deletes << a + drop    #beginning of word + end of word minus last letter of beginning
      end
      #transpose
      if b.length>1
        trans = a + b[1] + b[0] + b[2..b.length]
        transposes << trans
      end
      #replace
      if b.length>0
        ALPHABET.each_char do |c|
          repl   = a + c + b[1..b.length]
          replaces << repl
        end
      end
      #inserts
      ALPHABET.each_char do |c|
        ins   = a + c + b
        inserts << ins
      end     
    end
   
    return (deletes + transposes + replaces + inserts).uniq
  end
  
  #lookup frequency
  def lookup(word)
    return @dictionary[word]
  end

  # find known (in dictionary) distance-2 edits of target word.
  def known_edits2 (word)
    result = []
    edits1(word).each do |e1| 
      result += edits1(e1)
    end
    if result.empty? 
      return nil 
    else
      uniques = result.uniq
      return known(uniques) #remove duplicates, check if the words are in the dictionary
    end
  end

  #return subset of the input words that are known by this dictionary
  def known(words)
    result = words.find_all {|w| @dictionary.key?(w) } #find all words for which condition is true
    if result.empty? 
      return [] 
    else
      return result.sort_by {|e| 1-@dictionary[e]} #sort by descending frequency
    end
  end


  # if word is known, then
  # returns [word], 
  # else if there are valid distance-1 replacements, 
  # returns distance-1 replacements sorted by descending frequency in the model
  # else if there are valid distance-2 replacements,
  # returns distance-2 replacements sorted by descending frequency in the model
  # else returns nil
  
  def correct(w)
    unless known([w]).empty?
      return [w] 
    else
      eds = known(edits1(w))
      if eds.empty? #if no distance 1 edits
        eds = known_edits2(w) #try distance 2 edits
      end
      unless (eds.empty?)
        #eds.sort_by! {|e| 1-@dictionary[e]} #sorting was moved to 'known' method
        return eds
      else
        return nil 
      end #endif eds
    end
  end
    
  def manual_test
    unless @dictionary
      puts "untrained model"
      return nil
    end
    loop do 
      print "lookup word:"
      w = gets.chomp
      if w == ""
        break
      else 
        eds = correct(w)
        unless eds 
          puts "-- no suggestions --"
        end
        if (eds == [w])
          puts w + 'is a correct word'
        else
          eds.each do |e|
            puts e +": "+ @dictionary[e].to_s
          end
        end
      end
    end
  end
  
end

