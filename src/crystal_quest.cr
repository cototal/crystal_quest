require "kemal"
require "json"
require "./services/container"

module CrystalQuest
  VERSION = "0.1.0"

  container = Services::Container.new("data/game_config.json")
  ah = container.action_handler

  get "/" do
    render "src/views/home.ecr", "src/views/layouts/layout.ecr"
  end

  sockets = [] of HTTP::WebSocket

  ws "/chat" do |socket|
    sockets.push socket

    socket.on_message do |message|
      sockets.each do |a_socket|
        output = ah.execute(message)[:output]
        result = %({"user": "Test", "message": "#{output}"})
        a_socket.send result
      end
    end

    socket.on_close do |_|
      sockets.delete(socket)
      puts "Closing socket: #{socket}"
    end
  end

  Kemal.run
end
