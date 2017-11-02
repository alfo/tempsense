# Require rubygems
require 'serialport'
require 'net/http'

# Instantiate serial connection to Arduino
serial = SerialPort.new("/dev/cu.usbmodem14141", 9600, 8, 1, SerialPort::NONE)

# Responsible for sending received values to the server via HTTP
def send_to_server(message)

  begin

    uri = URI.parse('http://localhost:4567/data')
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path)
    request['data'] = message
    result = http.request(request)

    # Did the server respond with 200 OK?
    if result.kind_of? Net::HTTPSuccess
      puts "Sent #{message} to server"
    else
      puts "Server didn't store information"
    end

  rescue

    # If we get an exception, it's safe to assume the server
    # didn't respond to our HTTP request
    puts "No connection to server..."

  end

end

# Loop forever, waiting for serial input
while true do

  # Pull raw data in from serial port
  message = serial.gets

  if message

    # Remove any excess whitespace, and convert to float
    message = message.chomp.to_f

    send_to_server message
  end

end