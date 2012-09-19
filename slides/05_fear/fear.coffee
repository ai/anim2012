presentation.slide 'fear', ($, $$, slide) ->

  examples = $$('.example')

  slide.every 3000, -> examples.toggleClass('signin')
