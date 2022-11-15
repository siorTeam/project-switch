/**
 * @file esp32.ino
 * @author switch-team, siorTeam
 * @version 0.6.0
 * @date 2022-11-16
 * 
 * @copyright Copyright (c) 2022
 * 
 */

/*****

  Video: https://www.youtube.com/watch?v=oCMOYS71NIU
  Based on Neil Kolban example for IDF: https://github.com/nkolban/esp32-snippets/blob/master/cpp_utils/tests/BLE%20Tests/SampleNotify.cpp
  Ported to Arduino ESP32 by Evandro Copercini

  The design of creating the BLE server is:
  1. Create a BLE Server
  2. Create a BLE Service
  3. Create a BLE Characteristic on the Service
  4. Create a BLE Descriptor on the characteristic
  5. Start the service.
  6. Start advertising.

*****/

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <ESP32Servo.h>

Servo serv; 

BLEServer *pServer;
BLEService *pService;
BLECharacteristic *pTxCharacteristic;
BLECharacteristic *pRxCharacteristic;
bool deviceConnected    = false;
bool oldDeviceConnected = false;

#define SERVICE_UUID           "6E400001-B5A3-F393-E0A9-E50E24DCCA9E" // UART service UUID
#define CHARACTERISTIC_UUID_RX "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
#define CHARACTERISTIC_UUID_TX "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"

class MyServerCallbacks: public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) {
    deviceConnected = true;
  };

  void onDisconnect(BLEServer* pServer) {
    deviceConnected = false;
  };
};

class MyCallbacks: public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {
    std::string rxValue = pCharacteristic->getValue();

    if (rxValue.length() > 0) {
      Serial.println("*********");
      Serial.print("Received Value: ");

      // values for TowerPro SG90
      // https://github.com/jkb-git/ESP32Servo/blob/master/src/ESP32_Servo.h
      serv.attach(13, 400, 2400);
      for (int i = 0; i < rxValue.length(); i++) {
        Serial.print(rxValue[i]);

        if ('0' <= rxValue[i] && rxValue[i] <= '1') {
          if('0' == rxValue[i])       serv.write(45);
          else if('1' == rxValue[i])  serv.write(135);
          delay(500);
        }

      }
      serv.detach();
    }
  }
};

void setup() {
  Serial.begin(115200);
  serv.setPeriodHertz(50);

  // Create the BLE Device
  BLEDevice::init("remote-SW");

  // Create the BLE Server
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  // Create the BLE Service
  pService = pServer->createService(SERVICE_UUID);

  // Create a BLE Characteristic
  pTxCharacteristic = pService->createCharacteristic( CHARACTERISTIC_UUID_TX, BLECharacteristic::PROPERTY_NOTIFY );
  pTxCharacteristic->addDescriptor(new BLE2902());

  pRxCharacteristic = pService->createCharacteristic( CHARACTERISTIC_UUID_RX, BLECharacteristic::PROPERTY_WRITE );
  pRxCharacteristic->setCallbacks(new MyCallbacks());

  // Start the service
  pService->start();

  // Start advertising
  pServer->getAdvertising()->start();
  Serial.println("Waiting a client connection to notify...");
}

void loop() {
  // disconnecting
  if (!deviceConnected && oldDeviceConnected) {
    delay(500); // give the bluetooth stack the chance to get things ready
    pServer->startAdvertising(); // restart advertising
    Serial.println("Disconnected, Start Advertising");
    oldDeviceConnected = deviceConnected;
  }

  // connecting
  if (deviceConnected && !oldDeviceConnected) {
    Serial.println("Connected");
    oldDeviceConnected = deviceConnected;
  }
}
