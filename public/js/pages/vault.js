+function ($) {
  'use strict';

  if(typeof SC !== 'object') return

  // initialize soundcloud
  var client_id = "fa5bf446b6b4c23df73d59e808f20dfb"
  SC.initialize({ client_id: client_id })

  $('.vault-track').each(function(){
    var $track = $(this),
        sc_id = $track.attr('data-soundcloud-id')

    if(sc_id) {

      SC.get("/tracks/" + sc_id, function(track){
        if(track.streamable) {
          $track.find('audio').attr('src', track.stream_url + '?client_id=' + client_id)
        } else {
          $track.find('audio').hide().after('<p class="stream-error">This track is not streamable. <a href="'+track.permalink_url+'" target="_blank">Listen on SoundCloud &rsaquo;</a></p>')
        }
      })

    }
  })

}(jQuery);