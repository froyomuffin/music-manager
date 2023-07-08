require "socket"

class Listener
  EXTRACTION_PATTERN = /GET \/send_command\?value=(.*?) HTTP.*/

  def initialize(host: "127.0.0.1", port:)
    @server = TCPServer.new(host, port)
  end

  def receive_command(auto_close: true)
    request = listen
    command = extract(request)

    if auto_close
      close(message: "Received command: \"#{command}\"")
    end

    return command
  end

  def close(message:)
    reply(message: message)
    @session.close
  end

  private

  def listen
    @session = @server.accept
    @session.gets
  end

  def extract(request)
    match = EXTRACTION_PATTERN.match(request)

    command =
      if match.nil?
        ""
      else
        match[1]
      end

    command.downcase
  end

  def reply(message:)
    @session.print("HTTP/1.1 200/OK\r\n")
    @session.print("Content-Type: text/html\r\n")
    @session.print("\r\n")
    @session.print(message)
    @session.print("\r\n\r\n")
  end
end
