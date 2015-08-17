class AddSiteSupportToAds < ActiveRecord::Migration
  def self.up
    add_column    :ad_banners, :site_id, :integer
  end

  def self.down
    remove_column :ad_banners, :site_id
  end
end
