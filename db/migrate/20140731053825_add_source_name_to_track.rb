class AddSourceNameToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :source_name, :string
  end
end
