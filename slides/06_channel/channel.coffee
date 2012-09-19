presentation.slide 'channel', ($, $$, slide) ->

  examples = $$('.example')
  slide.every 3000, -> examples.toggleClass('bad')
