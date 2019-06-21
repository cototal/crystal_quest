require "json"

require "./action_handler"
require "./actions/*"

module CrystalQuest
  module Services
    class Container
      setter :action_handler, :help_action, :look_action, :say_action
      getter errors : Array(String) = [] of String
      getter config : JSON::Any

      def initialize(config_file : String)
        @errors << "Config file not found at #{config_file}" if (!File.exists?(config_file))
        @errors << "Config file not readable" if (!File.readable?(config_file))
        return if @errors.size > 0
        config_content = File.read(config_file)
        @config = read_json(config_content, config_file)
      end

      def action_handler : ActionHandler
        @action_handler ||= ActionHandler.new(config, {
          "help" => help_action,
          "kill" => kill_action,
          "say" => say_action,
          "look" => look_action
        } of String => Actions::Iaction)
      end

      def look_action
        @look_action ||= Actions::Look.new(config)
      end

      def say_action
        @say_action ||= Actions::Say.new(config)
      end

      def kill_action
        @kill_action ||= Actions::Kill.new(config)
      end

      def help_action
        @help_action ||= Actions::Help.new(config)
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
