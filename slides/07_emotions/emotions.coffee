presentation.slide 'emotions', ($, $$, slide) ->

  examples = $$('.example')
  slide.every 3000, -> examples.toggleClass('rotated')
  slide.close -> examples.removeClass('rotated')
