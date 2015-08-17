# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "radiant-ad_banners-extension"

Gem::Specification.new do |s|
  s.name        = "radiant-ad_banners-extension"
  s.version     = RadiantAdBannersExtension::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = RadiantAdBannersExtension::AUTHORS
  s.email       = RadiantAdBannersExtension::EMAIL
  s.homepage    = RadiantAdBannersExtension::URL
  s.summary     = RadiantAdBannersExtension::SUMMARY
  s.description = RadiantAdBannersExtension::DESCRIPTION
  
  ignores = if File.exist?('.gitignore')
    File.read('.gitignore').split("\n").inject([]) {|a,p| a + Dir[p] }
  else
    []
  end
  s.files         = Dir['**/*'] - ignores
  s.test_files    = Dir['test/**/*','spec/**/*','features/**/*'] - ignores
  s.require_paths = ["lib"]
  
  # TODO: update for usage with Bundler/Gemfile once Radiant gets that capability
  s.post_install_message = %{
  Add this to your radiant project by adding the following line to your environment.rb:
    config.gem 'radiant-ad_banners-extension', :version => '#{RadiantAdBannersExtension::VERSION}'
  }
end
