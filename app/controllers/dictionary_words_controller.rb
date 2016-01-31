class DictionaryWordsController < ApplicationController

  def spellcheck
    
    sp = WebSpellchecker.new
    word=params[:term]
    #render :text => "you want to correct: #{word}"  
    @suggestions = sp.correct(word)
    if @suggestions
      known = @suggestions.include? word
    else
      known= false
      @suggestions= []
    end
    returnobject = {"term"=> word, "known" => known}
    unless known
      returnobject["suggestions"] = @suggestions
    end
    render :json => returnobject
    
  end
  
end
