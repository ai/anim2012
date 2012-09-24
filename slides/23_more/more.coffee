presentation.slide 'more', ($, $$, slide) ->

  slide.every 3000, -> slide.toggleClass('rotated')
