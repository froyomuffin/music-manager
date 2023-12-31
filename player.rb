require "faraday"
require "json"

class Player
  BASE_URL = "https://api.spotify.com"

  def initialize(access_token:, target_device_id:, target_playlist_id:)
    @headers = {
      "Authorization" => "Bearer #{access_token}",
      "Content-Type" => "application/json",
    }
    @target_device_id = target_device_id
    @target_playlist_id = target_playlist_id
  end

  def playback_state
    connection = Faraday.new(
      url: BASE_URL,
      params: { device_id: @target_device_id },
      headers: @headers
    )

    response = connection.get("/v1/me/player")

    { status: response.status, body: response.body }
  end

  def devices
    connection = Faraday.new(
      url: BASE_URL,
      params: nil,
      headers: @headers
    )

    response = connection.get("/v1/me/player/devices")

    { status: response.status, body: response.body }
  end

  def play
    connection = Faraday.new(
      url: BASE_URL,
      params: { device_id: @target_device_id },
      headers: @headers
    )

    response = connection.put("/v1/me/player/play") do |req|
      req.body = {
        context_uri: "spotify:playlist:#{@target_playlist_id}"
      }.to_json
    end

    { status: response.status, body: response.body }
  end

  def pause
    connection = Faraday.new(
      url: BASE_URL,
      params: { device_id: @target_device_id },
      headers: @headers
    )

    response = connection.put("/v1/me/player/pause")

    { status: response.status, body: response.body }
  end

  def resume
    connection = Faraday.new(
      url: BASE_URL,
      params: { device_id: @target_device_id },
      headers: @headers
    )

    response = connection.put("/v1/me/player/play")

    { status: response.status, body: response.body }
  end

  def next
    connection = Faraday.new(
      url: BASE_URL,
      params: { device_id: @target_device_id },
      headers: @headers
    )

    response = connection.post("/v1/me/player/next")

    { status: response.status, body: response.body }
  end

  def enable_shuffle
    connection = Faraday.new(
      url: BASE_URL,
      params: { state: true, device_id: @target_device_id },
      headers: @headers
    )

    response = connection.put("/v1/me/player/shuffle")

    { status: response.status, body: response.body }
  end
end
