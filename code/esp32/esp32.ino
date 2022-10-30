/**
 * @file esp32.ino
 * @author switch-team, siorTeam
 * @version 0.1.0
 * @date 2022-10-28
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <ESP32Servo.h>

Servo serv;  // servo object
 
void setup() {
  serv.setPeriodHertz(50); 
  serv.attach(13);
}
 
void loop() {
  serv.write(0); 
  delay(2000);
  serv.write(180);
  delay(2000);
}
