require "json"
require "./iaction"

module CrystalQuest::Services::Actions
  class Look
    include Iaction
    getter config

    def initialize(@config : JSON::Any)
    end

    def output(input = [] of String)
      return look_at(input) if input.size > 1 && input[1] == "at"
      if !config["rooms"]
        return config["messsages"]["unknown"].to_s
      end

      room = config["rooms"][0]
      enemy = config["enemies"][0] if config["enemies"]
      enemy_list = ""
      if enemy
        enemy_list = "Also here: <b>#{enemy["name"]}</b>"
      end
      "<b>#{room["name"]}</b><br>#{room["description"]}<br>#{enemy_list}"
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

    private def look_at(input)
      return "What do you want to look at?" if input.size == 2
      key = input[2..-1].join(" ")
      enemy = enemies_by_key[key]?
      return config["messages"]["not_here"].to_s unless enemy
      enemy["description"].to_s
    end
  end
end
