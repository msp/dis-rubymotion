# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

require 'bundler'
Bundler.require


Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'DiS'

  app.device_family = :iphone
  app.interface_orientations = [:portrait]

  # app.codesign_certificate = 'iPhone Distribution: Radial Solutions Ltd'
  # The name of your personal distribution profile, from your keychain.
  # Distribution profile, NOT development profile!
  # This was from step 2.

  app.identifier = 'org.cenatus'
  # The bundle identifier, from step 4.
  # Exactly as you typed it then.

  # app.provisioning_profile = '/data/development/rubymotion/ios/provisioning-profiles/DiS_Testing.mobileprovision'
  # The filename and full path of your distribution provisioning profile.
  # The name is probably an enormous hex string.
  # From step 5.

  app.pods do
    pod 'SVPullToRefresh'
    # pod 'SVProgressHUD'
  end

  app.files << Dir.glob("./config/*.rb")
end
