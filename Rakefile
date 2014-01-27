# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

require 'bundler'
Bundler.require


Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'DiS'
  app.identifier = 'org.cenatus'
  app.device_family = :iphone
  app.interface_orientations = [:portrait]

  app.pods do
    pod 'SVPullToRefresh'
    pod 'SVProgressHUD'
  end

  app.files << Dir.glob("./config/*.rb")
end
