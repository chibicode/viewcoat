require 'rails'
require "viewcoat/helper"

module Viewcoat
  class Railtie < Rails::Railtie
    initializer "viewcoat.helper" do
      ActiveSupport.on_load(:action_view) do
        include Viewcoat::Helper
      end
    end
  end
end
