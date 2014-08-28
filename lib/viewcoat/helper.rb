require "viewcoat/store"

module Viewcoat
  module Helper
    def coat
      instance_variable_get("@viewcoat_store") ||\
        instance_variable_set("@viewcoat_store", Viewcoat::Store.new)
    end
  end
end
