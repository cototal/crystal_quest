require "json"
require "html"

module CrystalQuest
  module Services
    class ActionHandler
      getter errors : Array(String) = [] of String
      getter config : JSON::Any
      getter actions : Hash(String, Actions::Iaction)

      def initialize(@config : JSON::Any, @actions : Hash(String, Actions::Iaction))
      end

      def execute(message : String) : {errors: Array(String), output: String}
        data = read_json(message, "action message")
        @errors << "Message format invalid #{message}" if !data["message"]
        return {errors: @errors, output: ""} if @errors.size > 0
        message = data["message"].as_s
        msg_pieces = message.split(" ")
        output = ""
        case msg_pieces[0]
        when "help"
          output = actions["help"].output
        when "look"
          output = look(msg_pieces)
        when "say"
          output = say(msg_pieces[1..-1].join(" "))
        when "kill"
          output = kill(msg_pieces)
        else
          output = unknown_command
        end
        return {errors: @errors, output: output}
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

      private def kill(msg_pieces)
        return "What are you attacking?" if msg_pieces.size == 1
        key = msg_pieces[1..-1].join(" ")
        enemy = enemies_by_key[key]?
        return not_here unless enemy
        output = "You bravely attack <b>#{enemy["name"]}</b>"
        output += "<br>It is slain!<br>But as it dissolves into nothing, another appears from the darkness!"
        output
      end

      private def look(msg_pieces)
        return look_at(msg_pieces) if msg_pieces.size > 1 && msg_pieces[1] == "at"
        if !config["rooms"]
          @errors << "Missing config for 'rooms'"
          return unknown_command
        end

        room = config["rooms"][0]
        enemy = config["enemies"][0] if config["enemies"]
        enemy_list = ""
        if enemy
          enemy_list = "Also here: <b>#{enemy["name"]}</b>"
        end
        return "<b>#{room["name"]}</b><br>#{room["description"]}<br>#{enemy_list}"
      end

      private def look_at(msg_pieces)
        return "What do you want to look at?" if msg_pieces.size == 2
        key = msg_pieces[2..-1].join(" ")
        enemy = enemies_by_key[key]?
        return not_here unless enemy
        enemy["description"].to_s
      end

      private def help
        return config["help"].as_a.map { |line| line.as_a.join(" - ") }.join("<br>") if config["help"]
        @errors << "Missing config for 'help'"
        return unknown_command
      end

      private def say(message)
        HTML.escape(message)
      end

      private def unknown_command
        "I don't understand. Use 'help' to get a list of valid commands"
      end

      private def not_here
        "There is nothing like that here"
      end

      private def read_json(content : String, source = "unknown") : JSON::Any
        JSON.parse(content)
      rescue JSON::ParseException
        @errors << "#{source} contains invalid JSON"
        JSON.parse(%({"error": "Invalid JSON"}))
      end
    end
  end
end
