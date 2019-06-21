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
        action = actions[msg_pieces[0]]?
        output = action.nil? ? config["messages"]["unknown"].to_s : action.output(msg_pieces)
        return {errors: @errors, output: output}
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
