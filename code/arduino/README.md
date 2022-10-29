# Arduino

## `arduino.ino`

Processor에 해당하는 Arduino에 업로드되는 코드입니다

## Pin Setting

Arduino와 연결하는 핀 구성은 아래와 같습니다

Arduino Pin | Otherside Pin
----|----
3.3V|Bluetooth VCC
  5V|Servo VCC
 GND|Bluetooth GND & Servo GND
 D12|Bluetooth TXD
 D11|Bluetooth RXD
 D10|Servo PWM

## Reference

- https://www.arduino.cc/reference/en/libraries/servo/
- https://docs.arduino.cc/learn/built-in-libraries/software-serial
