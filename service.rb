#!/usr/bin/ruby

require_relative "listener"
require_relative "player"
require_relative "../spotify-tokens/token_generator"

class Service
  HOST = ENV["SPOTIFY_MANAGER_HOST"]
  PORT = ENV["SPOTIFY_MANAGER_PORT"]

  def run
    puts "Starting"

    listener = Listener.new(host: HOST, port: PORT)
    generator = TokenGenerator.new(
      client_id: ENV["SPOTIFY_CLIENT_ID"],
      client_secret: ENV["SPOTIFY_CLIENT_SECRET"],
      refresh_token: ENV["SPOTIFY_REFRESH_TOKEN"],
    )

    loop do
      access_token = generator.generate
      player = Player.new(
        access_token: access_token,
        target_device_id: ENV["SPOTIFY_TARGET_DEVICE_ID"],
        target_playlist_id: ENV["SPOTIFY_TARGET_PLAYLIST_ID"],
      )

      command = listener.receive_command(auto_close: false)
      puts "Received command \"#{command}\""

      case command
      when "music"
        player.enable_shuffle
        result = player.play
        puts result
        listener.close(message: result)
      when "play"
        result = player.play
        puts result
        listener.close(message: result)
      when "pause"
        result = player.pause
        puts result
        listener.close(message: result)
      when "next"
        result = player.next
        puts result
        listener.close(message: result)
      else
        puts "Error: Unknown command"
      end
    rescue => e
      puts "Error: #{e}"
    end
  end
end

Service.new.run
