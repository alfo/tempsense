# README

## Project Description

The general purpose of this project is to collect temperature data from an Arduino, store that data in the cloud, and then live-graph it on a publicly available web page.

There are four parts to the code in this repository:

* The Arduino C Code (in `ArduinoSensor/`)

* The client Ruby code to receive data from the Arduino and send it to the server (in `client/`)

* The back end server Ruby code (data model, endpoint logic, and database/environment configuration) in the project root

* The OpenSCAD Arduino mount in `case/`

![Circuit](./circuit.JPG)

Demo video can be found [here](https://mediacentral.ucl.ac.uk/Play/9734)

To get started, connect the Arduino to your computer via the USB cable. Then launch the client:

    cd client
    bundle install
    ruby client.rb

You can then view the data as a graph at [http://tempsense.herokuapp.com](http://tempsense.herokuapp.com)

## Server Notes

There are lots of files generated by Rails, but the ones of note (where changes have actually been made):

* [`config/routes.rb`](https://github.com/alfo/tempsense/blob/master/config/routes.rb) Routes traffic to the controllers

* [`app/controllers/points_controller.rb`](https://github.com/alfo/tempsense/blob/master/app/controllers/points_controller.rb) Handles incoming GET and POST requests, as well as providing a JSON endpoint allowing auto-updating graph via AJAX

* [`app/models/point.rb`](https://github.com/alfo/tempsense/blob/master/app/models/point.rb) Defines what an individual data point must have/be to be valid

* [`app/views/points/index.html.erb`](https://github.com/alfo/tempsense/blob/master/app/views/points/index.html.erb) is the HTML/JS responsible for pulling data from the JSON endpoint at regular intervals and drawing the data on the graph

* [`db/schema.rb`](https://github.com/alfo/tempsense/blob/master/db/schema.rb) defines the database schema (auto-generated from contents of [`db/migrate/`](https://github.com/alfo/tempsense/tree/master/db/migrate))

The server is currently being hosted on [Heroku](https://www.heroku.com), because it's free for these purposes (under 10K database rows), whereas Azure would charge for the same service (their only free teir is Windows-Server only), but it could equally well run on Azure with some extra configuration.

## Client Notes

The Ruby client can be started by simply with:

    ruby client.rb

The client (which contains a `while true do` loop), will run forever waiting for new data from the Arduino. It cannot run at the same time as the Arduino Terminal is open, as they cannot both bind to the Arduino's serial port.

The client auto-searches for open serial ports (macOS-specific code), but this can also be replaced with a declaration for Linux/Windows.

## Arduino Notes

The Arduino is what determines the interval at which data is taken from the thermistor. Currently this is set to 10 seconds, which is useful for live demo purposes, but it could equally be set as low as 1s or as high as needed for data collection over long periods of time.
