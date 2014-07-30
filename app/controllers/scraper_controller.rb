class ScraperController < ApplicationController

  require 'nokogiri'
  require 'open-uri'

  def scrape
    doc = Nokogiri::HTML(open(params[:url]))

    doc.xpath('//iframe[contains(@src, "soundcloud.com")]').each do |player|
      @result = player
    end

    doc.css('h1.headline').each do |h1|
      @track_name = h1.content
    end

    render 'scraper/results'
  end

end
