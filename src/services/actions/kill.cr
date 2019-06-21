require "json"
require "./iaction"

module CrystalQuest::Services::Actions
  class Kill
    include Iaction
    getter config

    def initialize(@config : JSON::Any)
    end

    def output(input = [] of String)
      return "What are you attacking?" if input.size == 1
      key = input[1..-1].join(" ")
      enemy = enemies_by_key[key]?
      return config["messages"]["not_here"].to_s unless enemy
      output = "You bravely attack <b>#{enemy["name"]}</b>"
      output += "<br>It is slain!<br>But as it dissolves into nothing, another appears from the darkness!"
      output
    end

    def enemies_by_key
      enemies = {} of String => JSON::Any
      return enemies unless config["enemies"]
      config["enemies"].as_a.each do |enemy|
        enemy["keys"].as_a.each do |enemy_key|
          enemies[enemy_key.as_s] = enemy
        end
      end
      enemies
    end
  end
end

