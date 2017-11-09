# Require rubygems
require 'serialport'
require 'net/http'
require 'fileutils'
require './color'

serial = false

# Scan through open serial ports that match Arduino's signature
# (This only works on Mac)
Dir.glob("/dev/cu.usbmodem*").each do |port|

  # Skip if we've already established the serial connection
  next if serial

  # Try to instantiate serial connection to Arduino
  begin
    serial = SerialPort.new(port, 9600, 8, 1, SerialPort::NONE)
  rescue
    puts "Skipped #{port}"
    next
  end
end

# If we've got this far without opening a port, we're never going to
unless serial
  # It didn't work :(
  puts "Could not open any serial connections :(".pink
  return
end

# Responsible for sending received values to the server via HTTP
def send_to_server(message)

  begin

    # Send a POST request to the server with the data attached
    result = Net::HTTP.post_form(URI.parse('http://tempsense.herokuapp.com/points/create'), {'data': message})

    # Did the server respond with 200-series OK?
    if result.kind_of? Net::HTTPSuccess
      puts "Sent #{message} to server"
    else
      puts "Server didn't store information"
    end

  rescue

    # If we get an exception, it's safe to assume the server
    # didn't respond to our HTTP request
    puts "No connection to server... #{message}"

  end

end

# Loop forever, waiting for serial input
while true do

  # Pull raw data in from serial port
  message = serial.gets

  if message

    # Remove any excess whitespace, and convert to float
    message = message.chomp.to_f

    # Sometimes the Arduino restarts mid-way through sending Serial data
    # Validate data to make sure we're not sending something like 2122.52
    # (Arduino prints 21, restarts, then prints 22.52)
    send_to_server message if message.between?(-20, 60)

  end

end
