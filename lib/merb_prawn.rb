# make sure we're running inside Merb
if defined?(Merb::Plugins)
  $LOAD_PATH << File.dirname(__FILE__)
  require 'prawn'
  require 'prawn/layout' rescue LoadError
  require 'merb_prawn/template'
  
  Merb::Plugins.config[:merb_prawn] = {
  }
  
  Merb::BootLoader.before_app_loads do
  end
  
  Merb::BootLoader.after_app_loads do
  end
end