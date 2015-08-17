class AddFormat < ActiveRecord::Migration
  def self.up
    add_column    :ad_banners, :format, :string
  end

  def self.down
    remove_column :ad_banners, :format
  end
end
