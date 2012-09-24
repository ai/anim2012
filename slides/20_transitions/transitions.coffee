presentation.slide 'transitions', ($, $$, slide) ->

  slide.every 2000, ->
    slide.toggleClass('cursored')
    after 200, -> slide.toggleClass('colored')
