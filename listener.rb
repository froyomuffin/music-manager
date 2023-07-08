require "socket"

class Listener
  EXTRACTION_PATTERN = /GET \/send_command\?value=(.*?) HTTP.*/

  def initialize(host: "127.0.0.1", port:)
    @server = TCPServer.new(host, port)
  end

  def receive_command
    request = listen
    command = extract(request)
    reply(command)
    close

    return command
  end

  private

  def listen
    @session = @server.accept
    @session.gets
  end

  def extract(request)
    match = EXTRACTION_PATTERN.match(request)

    if match.nil?
      ""
    else
      match[1]
    end
  end

  def reply(extracted_command)
    @session.print("HTTP/1.1 200/OK\r\n")
    @session.print("Content-Type: text/html\r\n")
    @session.print("\r\n")
    @session.print("Extracted command: \"#{extracted_command}\"\r\n\r\n")
  end

  def close
    @session.close
  end
end
