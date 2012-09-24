presentation.slide 'more', ($, $$, slide) ->

  slide.every 4500, -> slide.toggleClass('rotated')
