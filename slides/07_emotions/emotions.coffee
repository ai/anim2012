presentation.slide 'emotions', ($, $$, slide) ->

  examples = $$('.example')
  animated = examples.filter('.animated')
  back     = animated.find('.back')
  slide.every 3000, ->
    examples.toggleClass('rotated')
    after 200, -> back.toggle()
  slide.close ->
    examples.removeClass('rotated')
    back.hide()
