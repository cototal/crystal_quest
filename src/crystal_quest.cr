require "kemal"

module CrystalQuest
  VERSION = "0.1.0"

  get "/" do
    render "src/views/home.ecr", "src/views/layouts/layout.ecr"
  end

  Kemal.run
end
