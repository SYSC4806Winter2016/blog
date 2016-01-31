# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

CORPUSFILE = "#{Rails.root}/db/brown_sample.txt"
DictionaryWord.destroy_all
puts "destroyed all existing records -- "
sp = Spellchecker.new(CORPUSFILE)
my_dictionary = sp.dictionary
puts "trained dict -- "

ActiveRecord::Base.transaction do #wrap this stuff in a transaction  
  my_dictionary.each do |w,c|
    DictionaryWord.create(word: w, count: c) 
  end
end

puts "Inserted #{DictionaryWord.count} words"
