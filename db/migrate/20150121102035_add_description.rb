class AddDescription < ActiveRecord::Migration
  def self.up
    add_column    :ad_banners, :description, :text
  end

  def self.down
    remove_column :ad_banners, :description
  end
end
