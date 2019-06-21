require "json"
require "./iaction"

module CrystalQuest::Services::Actions
  class Help
    include Iaction
    getter config

    def initialize(@config : JSON::Any)
    end

    def output
      return config["help"].as_a.map { |line| line.as_a.join(" - ") }.join("<br>") if config["help"]
      "Help has not been configured."
    end
  end
end
