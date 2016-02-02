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
      String.new.tap |result|
        result << %Q{<a href="#{ad_banner.link_url}" target="#{ad_banner.link_target}">} unless ad_banner.link_url.blank?
        result << %Q{<img src="#{ad_banner.asset.thumbnail(:original)}" title="#{ad_banner.name}" alt="#{ad_banner.asset.caption || ad_banner.asset.title}" />}
        result << %Q{</a>} unless ad_banner.link_url.blank?
      end
    end
  end

end
