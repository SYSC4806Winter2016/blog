require 'test_helper'

class SpellcheckerTest < ActiveSupport::TestCase

  
  test "word counting" do
    sp = load_spellchecker #helper method to load sample Spellchecker
    check = sp.lookup("hello")==3 &&
        sp.lookup("ruby")==3 &&
        sp.lookup("rudy")==2 &&
        sp.lookup("rails")==1
    assert check, "problem with counting words"
    check = (sp.lookup("nothing")==0)
    assert check , "lookup missing words should return 0"
  end

  
  test "known words" do
    sp = load_spellchecker #helper method to load sample Spellchecker
    knowns1 = sp.known(["notthere", "hello", "ruby", "nonono", "ru"])
    knowns2 = sp.known(["hello", "goodbye", "rude", "yayaya", "ru", "rails"])
    expected = ["hello", "ruby"]
    assert knowns1==expected, "known words! got #{knowns1}, expected #{expected}"
    expected = ["hello", "rude", "rails"]
    assert knowns2==expected, "known words!  got #{knowns2}, expected #{expected}"
  end
  
# all the types of 1-distance edits
  
  test "deletes" do
    sp = load_spellchecker #helper method to load sample Spellchecker
    eds = sp.edits1("hel")
    #deletes
    deletes = ["he", "hl", "el"]
    deletes.each {|d| assert eds.include?(d) , "problem with deletes: test case #{d}" }    
  end
  
  test "inserts" do
    sp = load_spellchecker #helper method to load sample Spellchecker
    eds = sp.edits1("hel")
    #subset of possible includes
    inserts = ["ahel", "hkel", "herl", "helz"]
    inserts.each {|d| assert eds.include?(d) , "problem with includes: test case #{d}" }    
  end
   
  test "transposes" do
    sp = load_spellchecker #helper method to load sample Spellchecker
    eds = sp.edits1("hel")
    #tranposes
    transposes = ["ehl", "hle"]
    transposes.each {|d| assert eds.include?(d) , "problem with transposes: test case #{d}"}    
  end
  
  test "replaces" do
    sp = load_spellchecker #helper method to load sample Spellchecker
    eds = sp.edits1("hel")
    #subset of replaces
    replaces = ["vel","hfl", "hep"]
    replaces.each {|d| assert eds.include?(d), "problem with replaces: test case= #{d}"}    
  end
  
# 
  test "correct" do
    sp = load_spellchecker #helper method to load sample Spellchecker
    
    eds = sp.correct("rude") #d1 edits exist
    know =["rude"] #known word
    
    assert eds==know, "correction error: known word! Got #{eds}, expected: #{know}"
    
    eds = sp.correct("uby") #d1 edits exist
    e1s =["ruby", #insert
          "by"] #replace                
    assert eds == e1s, "correction error: known distance-1 edits! Got #{eds}, expected: #{e1s}"
    
    eds = sp.correct("duy") #no d1 edits

    e2s =["ruby", #insert, replace
          "rudy", #transpose, insert
          "by"] #delete, delete                
    assert eds == e2s, "correction error: distance-2 edits! Got #{eds}, expected: #{e2s}"

  end

end
