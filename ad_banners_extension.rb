require "radiant-ad_banners-extension"

class AdBannersExtension < Radiant::Extension
  version     RadiantAdBannersExtension::VERSION
  description RadiantAdBannersExtension::DESCRIPTION
  url         RadiantAdBannersExtension::URL
 
  def activate
    Radiant::AdminUI.send :include, AdBannersAdminUI unless defined? admin.ad_banner
    admin.ad_banner = Radiant::AdminUI.load_default_ad_banner_regions

    Radiant::Config["ad_banners.image_size.short"] ||= "300px"
    Radiant::Config["ad_banners.image_size.wide"]  ||= "700px"
    
    Radiant::Config["ad_banners.image_size.short_srcset"] ||= "2x:700px"
    Radiant::Config["ad_banners.image_size.wide_srcset"]  ||= "2x:original"
    
    tab "Content" do
      add_item "ads", "/admin/ad_banners", :after => "Pages"
    end
    Page.send :include, AdBannerTags
  end
 
end
