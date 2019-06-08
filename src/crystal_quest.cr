require "kemal"
require "json"

module CrystalQuest
  VERSION = "0.1.0"

  get "/" do
    render "src/views/home.ecr", "src/views/layouts/layout.ecr"
  end

  sockets = [] of HTTP::WebSocket

  ws "/chat" do |socket|
    sockets.push socket

    socket.on_message do |message|
      puts JSON.parse(message).inspect
      sockets.each do |a_socket|
        a_socket.send message
      end
    end

    socket.on_close do |_|
      sockets.delete(socket)
      puts "Closing socket: #{socket}"
    end
  end

  Kemal.run
end
