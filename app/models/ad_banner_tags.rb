module AdBannerTags
  include Radiant::Taggable

  desc %{
    Selects a banner. A specific banner may be specified with the @name@ attribute, otherwise a random banner is selected.

    A banner will only appear once on a given page unless otherwise forced with the @name@ attribute.

    *Usage:*
    <pre><code><r:ad_banner [name="banner_name"] [format="wide|short"]/></code></pre>
  }
  tag 'ad_banner' do |tag|
    @selected_banners ||= []
    ad_banner = if tag.attr['name']
      AdBanner.find_by_name(tag.attr['name'], :joins => "INNER JOIN assets ON assets.id = ad_banners.asset_id")
    else
      AdBanner.select_banner(:exclude => @selected_banners, :format => tag.attr['format'])
    end
    unless ad_banner.nil?
      @selected_banners << ad_banner.id
      # The HTML is simple enough to roll by hand instead of sucking in REXML
      String.new.tap do |result|
        img_size    = ( ad_banner.format == 'wide' ? Radiant::Config["ad_banners.image_size.wide"] : Radiant::Config["ad_banners.image_size.short"] ) rescue :original
        srcset_size = ( ad_banner.format == 'wide' ? Radiant::Config["ad_banners.image_size.wide_srcset"] : Radiant::Config["ad_banners.image_size.short_srcset"] )
        srcset      = parse_srcset(ad_banner.asset,srcset_size,true)
        if ad_banner.link_url.present?
          result << %Q{<a href="#{ad_banner.link_url}"}
          result << %Q{ target="#{ad_banner.link_target}"} if ad_banner.link_target.present?
          result << %Q{ title="#{tag.attr['title']}"} if tag.attr['title'].present?
          result << %Q{>}
        end
        result << %Q{<img src="#{ad_banner.asset.thumbnail(img_size)}" srcset="#{srcset}" title="#{ad_banner.name}" alt="#{ad_banner.asset.caption.present? ? ad_banner.asset.caption : ad_banner.asset.title}" />}
        result << %Q{</a>} if ad_banner.link_url.present?
      end # String.new.tap
    end # unless ad_banner.nil?
  end # tag 'ad_banner'

  private
  
  # srcset looks like:
  # "320w: 400px, 480w: 600px, 768w: 1000px, 1024w: 1000px, 1280w: original, 2x: original, 3x: original"
  def parse_srcset(asset,srcset,timestamp=nil)
    begin
      String.new.tap do |output|
        sizes = srcset.split(',').map(&:strip)
        o = []
        sizes.each { |size|
          s = size.split(':').map(&:strip) # looks like: ["480w", "600px"] 
          o << "#{asset.thumbnail(s[1],timestamp)} #{s[0]}"
        }
        output << o.join(', ')
      end # String.new.tap
    rescue Exception => e
      Rails.logger.warn("[AdBannerTags#parse_srcset] error: #{e.inspect} (#{srcset})")
    end
  end # parse_srcset
  
end
