class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :name
      t.string :source
      t.integer :soundcloud_id

      t.timestamps
    end
  end
end
