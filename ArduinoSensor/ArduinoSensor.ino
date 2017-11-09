// Pin definitions
const int led_pin = 3;
const int thermistor_pin = A5;

const int thermistor_normal = 4700;
const int temp_normal = 25;
const int b_coeff = 3950;
const int series_resistor = 10000;

// Variables for input smoothing
const int num_samples = 5;

// Interval between datapoints in seconds
const int interval = 10;

void setup() {

  Serial.begin(9600);

  pinMode(led_pin, OUTPUT);
  pinMode(thermistor_pin, INPUT);

  // We're using the 3V3 (less noisy) voltage line, connected to the AREF pin
  // So we need to set the reference voltage to the external input
  analogReference(EXTERNAL);
}

void loop() {

  float average;

  // Read the sensor num_sample times
  for (int i; i < num_samples; i++) {
    average += analogRead(thermistor_pin);
    delay(100);
  }

  // Average our readings to account for some noise
  average /= num_samples;

  // Convert from analogue read to resistance
  average = 1023 / average - 1;
  average = 10000 / average;

  // Convert from resistance to ºC
  float steinhart;
  steinhart = average / thermistor_normal;
  steinhart = log(steinhart);
  steinhart = steinhart / b_coeff;
  steinhart += 1.0 / (temp_normal + 273.15);
  steinhart = 1.0 / steinhart;
  steinhart -= 273.15;

  // Send the data appended with '\n'
  Serial.println(steinhart);

  // Blink the status LED so we know data's been sent
  digitalWrite(led_pin, HIGH);
  delay(100);
  digitalWrite(led_pin, LOW);
  

  // Convert the interval from seconds to miliseconds
  delay(interval * 1000);
}
