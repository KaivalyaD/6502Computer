#include <Arduino.h>

const uint8_t CLOCK_PIN = 2;
const uint8_t READ_WRITE_PIN = 3;
const uint8_t ADDRESS_BUS[16] = { 52, 50, 48, 46, 44, 42, 40, 38, 36, 34, 32, 30, 28, 26, 24, 22 };
const uint8_t DATA_BUS[8] = { 53, 51, 49, 47, 45, 43, 41, 39 };

void setup(void) {
  for (size_t i = 0; i < sizeof(ADDRESS_BUS); i++) {
    pinMode(ADDRESS_BUS[i], INPUT);
  }
  for(size_t i = 0; i < sizeof(DATA_BUS); i++) {
    pinMode(DATA_BUS[i], INPUT);
  }
  pinMode(CLOCK_PIN, INPUT);
  pinMode(READ_WRITE_PIN, INPUT);
  
  attachInterrupt(digitalPinToInterrupt(CLOCK_PIN), onClock, RISING);
  Serial.begin(57600);
}

void onClock(void) {
  uint16_t address = 0x0000;
  for(size_t i = 0; i < sizeof(ADDRESS_BUS); i++) {
    int bit = digitalRead(ADDRESS_BUS[i]) ? 1 : 0;
    address = (address << 1) | bit;
    Serial.print(bit);
  }
  Serial.print("    ");
  
  uint8_t data = 0x00;
  for(size_t i = 0; i < sizeof(DATA_BUS); i++) {
    int bit = digitalRead(DATA_BUS[i]) ? 1 : 0;
    data = (data << 1) | bit;
    Serial.print(bit);
  }
  Serial.print("    ");
  
  char output[16];
  sprintf(output, "0x%04x  %c 0x%02x", address, digitalRead(READ_WRITE_PIN) ? 'r' : 'W', data);
  Serial.println(output);
}

void loop(void) {}
