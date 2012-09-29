presentation.slide 'animations', ($, $$, slide) ->

  slide.every 5000, ->
    slide.toggleClass('cursored')
    after 200, -> slide.toggleClass('colored')
