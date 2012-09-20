presentation.slide 'fear', ($, $$, slide) ->

  examples = $$('.example')
  slide.every 3000, -> examples.toggleClass('signin')
  slide.close -> examples.removeClass('signin')
