Project Switch
===

# Architecture

## Communication

무선 통신 방법
- RF
  - 이동통신(2~5G)
  - 위성통신
- NFC
- bluetooth(실내 근거리 통신에 적합)
- wifi
- Zigbee
- Z-wave

**블루투스**로 제어

- 안드로이드, iOS 모두 동작해야함
  - Bluetooth Classic만으로는 안됌(iOS에서 지원하지 않음)
  - Bluetooth LE 통신(BLE = bluetooth 4.0이상)이 호환되어야 함

- Hardware Module
  - HM-10
    - 3.3V, UUID: 0xFFE0
    - [AT-COMMAND](./DSD%20TECH%20HM-10%20datasheet.pdf)
- Software Module(App)
  - software reuse
    - Android : Serial Bluetooth Terminal
    - iOS     : BitBlue
  - customizing App
    - (ios, android)모두 동작되어야 함
      - flutter - GUI(Graphic User Interface): 버튼위젯 / 목록 위젯 // 블루투스 연결(, 알람기능, ...) (3시간)
      - ~~React native~~
      - unity - (3시간+)
      - 중간고사 끝나고 퍼포먼스/와이어프레임 결정

## Actuation

서보모터로 제어

- SG-90
- MG996r

## Physics Model

캐비넷 - 3D 프린팅

## 추가 고려사항
- 블루투스 동작과정
  - 블루투스 페어링
- 스위치는 수동으로도 누를 수 있게
  - 서보모터에 신호가 왔을 때만 동작 이후는 토크가 걸리지 않게(수동이 가능하게)
- 스위치 개수가 증가했을 때 원활히 관리방법
- 캐비넷 디자인
- 필요 전력 최소화?
