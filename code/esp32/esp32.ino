/**
 * @file esp32.ino
 * @author switch-team, siorTeam
 * @version 0.4.0
 * @date 2022-11-16
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <ESP32Servo.h>

Servo serv; 

#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

BLEServer         *pServer;
BLEService        *pService;
BLECharacteristic *pCharacteristic;

class MyCallbacks: public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {
    std::string value = pCharacteristic->getValue();

    if (value.length() > 0) {
      Serial.print("FROM MOBILE: ");
      for (int i = 0; i < value.length(); i++) {
        Serial.print(value[i]);
        if(value[i] == '1'){
          serv.write(0); 
          delay(2000);
        }
        else{
          serv.write(90); 
          delay(2000);
        }
      }
      Serial.println();
    }
  }
};

void setup() {
  Serial.begin(115200);
  Serial.println("Starting BLE work!");

  BLEDevice::init("remote-SW");
  pServer         = BLEDevice::createServer();
  pService        = pServer->createService(SERVICE_UUID);
  pCharacteristic = pService->createCharacteristic(CHARACTERISTIC_UUID, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE);

  pCharacteristic->setCallbacks(new MyCallbacks());
  pCharacteristic->setValue("Hello World");
  pService->start();

  BLEAdvertising *pAdvertising = pServer->getAdvertising();
  pAdvertising->start();

  serv.setPeriodHertz(50); 
  serv.attach(13);
}
 
void loop() {
  delay(2000);
}
