require "json"
require "html"
require "./iaction"

module CrystalQuest::Services::Actions
  class Say
    include Iaction
    getter config

    def initialize(@config : JSON::Any)
    end

    def output(input = [] of String)
      HTML.escape(input[1..-1].join(" "))
    end
  end
end
