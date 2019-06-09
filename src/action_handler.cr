require "json"

module CrystalQuest
  class ActionHandler
    getter errors : Array(String) = [] of String
    getter config : JSON::Any

    def initialize(config_file : String)
      @errors << "Config file not found at #{config_file}" if (!File.exists?(config_file))
      @errors << "Config file not readable" if (!File.readable?(config_file))
      return if @errors.size > 0
      config_content = File.read(config_file)
      @config = read_json(config_content, config_file)
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
        if config["help"]
          output = config["help"].as_a.map { |line| line.as_a.join(" - ") }.join("<br>")
        else
          @errors << "Missing config for 'help'"
        end
      else
        output = "I don't understand. Use 'help' to get a list of valid commands"
      end
      return {errors: @errors, output: output}
    end

    def read_json(content : String, source = "unknown") : JSON::Any
      JSON.parse(content)
    rescue JSON::ParseException
      @errors << "#{source} contains invalid JSON"
      JSON.parse(%({"error": "Invalid JSON"}))
    end
  end
end
