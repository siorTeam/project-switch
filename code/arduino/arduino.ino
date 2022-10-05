/**
 * @file arduino.ino
 * @author switch-team, siorTeam
 * @version 0.1.0
 * @date 2022-10-06
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <SoftwareSerial.h>
#include <Servo.h>

#define PIN_BT_TX     12 
#define PIN_BT_RX     11
#define PIN_SERVO_PWM 10

// Declare module Bluetooth as UART
SoftwareSerial BT_Serial(PIN_BT_TX, PIN_BT_RX);
// Declare Servo
Servo serv;

// DEBUG :: test for getting bluetooth module informations
void test_bluetooth_connect(){
  while(BT_Serial.available()){
    Serial.write(BT_Serial.read());
  }
  while(Serial.available()){
    BT_Serial.write(Serial.read());
  }
}

void setup() {
  // set baud rate & servo pin setup
  Serial.begin(9600);
  BT_Serial.begin(9600);
  serv.attach(PIN_SERVO_PWM);

  Serial.println("READY!"); // DEBUG
  serv.write(0); // initial setting
  delay(100); // pause until servo setting finish
}

void loop() {

  // DEBUG
  // test_bluetooth_connect();

  // Is there receiving data from bluetooth
  while(BT_Serial.available()){
    byte data = BT_Serial.read(); // Get Data from bluetooth module(mobile)
    Serial.write(data); // DEBUG
    
    switch(data){
      case 0x30: serv.write(  0); break; // '0' ->   0 degree
      case 0x31: serv.write( 90); break; // '1' ->  90 degree
      case 0x32: serv.write(180); break; // '2' -> 180 degree
      case 0x33: serv.write(  0); break; // '3' ->   0 degree
    }
    delay(100); // pause until servo setting finish
  }

  // DEBUG
  while(Serial.available()){
    BT_Serial.write(Serial.read());
  }
}
