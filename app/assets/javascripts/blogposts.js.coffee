# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'page:change', ->
  current_word =""
  $('#blogpost_contents').keypress (e) ->
    inp = String.fromCharCode(e.which)
    if ( inp.match /[a-zA-Z]/ ) #if this was a letter
      current_word = current_word + inp
    else
      if current_word.match /[a-zA-Z]+/ #a sequence of letters
        $.get '/spellcheck/'+current_word.toLowerCase(), (obj) ->
          #r = $.parseJSON(json_data);
          #obj = JSON.parse(json_data)
          #alert(r)
          unless obj.known
            suggestions = obj.suggestions.join(',')
            $('#unknown_words').append('<div class="a_word">&quot;'+obj.term+'&quot; not in dictionary! suggestions:'+suggestions + '</div>')
      current_word =""
        
      # 1 make sure the last thing typed is a letter or several letters
      # 2 if it's letters, ajax lookup of word
      