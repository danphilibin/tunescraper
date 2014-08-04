class PagesController < ApplicationController

  def index

  end

  def vault
    @tracks = Track.all.order(created_at: :desc)
  end

end
