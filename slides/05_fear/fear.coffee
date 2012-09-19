presentation.slide 'fear', ($, $$, slide) ->

  slide.every 3000, -> $$('.example').toggleClass('signin')
