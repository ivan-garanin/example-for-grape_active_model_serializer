#\ -s puma
require File.expand_path('../config/environment', __FILE__)

run Nsi::App.instance
