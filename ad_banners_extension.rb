require "radiant-ad_banners-extension"

class AdBannersExtension < Radiant::Extension
  version     RadiantAdBannersExtension::VERSION
  description RadiantAdBannersExtension::DESCRIPTION
  url         RadiantAdBannersExtension::URL
 
  def activate
    Radiant::AdminUI.send :include, AdBannersAdminUI unless defined? admin.ad_banner
    admin.ad_banner = Radiant::AdminUI.load_default_ad_banner_regions

    tab "Content" do
      add_item "ads", "/admin/ad_banners", :after => "Pages"
    end
    Page.send :include, AdBannerTags
  end
 
end
