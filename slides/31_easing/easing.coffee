presentation.slide 'easing', ($, $$, slide) ->

  slide.every 3000, -> slide.toggleClass('moved')
