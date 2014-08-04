class TrackController < ApplicationController

  require 'nokogiri'
  require 'open-uri'
  require 'cgi'
  require 'soundcloud'

  def create
    doc = Nokogiri::HTML(open(params[:url]))

    track = Track.new

    # strip query string from original URL
    source_url = URI.parse(params[:url])
    track.source = params[:url].gsub("?#{source_url.query}", '')

    # initialize soundcloud
    client = Soundcloud.new(:client_id => ENV['SOUNDCLOUD_CLIENT_ID'])

    # start scraping tools
    if params[:url].include?('edmtunes.com')

      track.source_name = 'EDMTunes'

      doc.xpath('//iframe[contains(@src, "soundcloud.com")]').each do |player|
        soundcloud_url = player.attributes['src']

        parsed_url = URI.parse(player.attributes['src'])
        query_strings = CGI.parse(parsed_url.query)

        if query_strings['url'].include?('%2F')
          soundcloud_url = URI.decode(query_strings['url'][0])
        else
          soundcloud_url = query_strings['url'][0]
        end

        track.soundcloud_id = soundcloud_url.split('/tracks/')[1].to_i

        sc_track = client.get("/tracks/#{track.soundcloud_id}")

        Rails.logger.info sc_track

        track.name = sc_track['title']
      end

      # doc.css('h1.headline').each do |h1|
      #   track.name = h1.content
      # end

      track.save

    elsif params[:url].include?('dancingastronaut.com')

      track.source_name = 'Dancing Astronaut'

      doc.css('div.content div.player div.play').each do |player|
        track.name = player['data-title']
        track.audio_url = player['data-url']

        if player['data-url'].include?('soundcloud')
          track.soundcloud_id = player['data-url'].split('/tracks/')[1].to_i

          sc_track = client.get("/tracks/#{track.soundcloud_id}")

          track.name = sc_track['title']
        end
      end

      track.save

    end


    redirect_to vault_path
  end

  def destroy
    Track.find(params[:id]).destroy

    redirect_to vault_path
  end

end
