presentation.slide 'channel', ($, $$, slide) ->

  examples = $$('.example')
  animated = examples.filter('.animated')

  slide.every 3000, ->
    examples.toggleClass('bad')

    #    if animated.hasClass('bad')
    #      animated.animate left: -60, 150, 'easeOutCubic', ->
    #        animated.animate left: 0, 1200, 'easeOutElastic'
