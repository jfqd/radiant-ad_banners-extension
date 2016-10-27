class AdBanner < ActiveRecord::Base
  default_scope :order => 'name ASC'

  belongs_to :asset

  validates_presence_of :name
  validates_presence_of :asset

  validates_format_of :link_url,
                      :allow_blank => true,
                      :with => /\Ahttps?:\/\/.+\z/,
                      :message => :invalid

  def self.select_banner(options = {})
    exclusions = options[:exclude] || []
    format = options[:format] || ""
    query = if format.blank?
      "SELECT ad_banners.id,weight FROM ad_banners INNER JOIN assets ON assets.id = ad_banners.asset_id WHERE ad_banners.weight > 0"
    else
      ["SELECT ad_banners.id,weight FROM ad_banners INNER JOIN assets ON assets.id = ad_banners.asset_id WHERE ad_banners.weight > 0 AND ad_banners.format LIKE ?", format]
    end
    weightings = find_by_sql(query).map do |banner|
      [banner.id] * (exclusions.include?(banner.id) ? 0 : banner.weight)
    end.flatten
    find_by_id(weightings[rand(weightings.size)])
  end

end
