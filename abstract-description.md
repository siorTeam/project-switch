Project Switch
===

# Architecture

## Communication

무선 통신 방법
- RF
  - 이동통신(2~5G)
  - 위성통신
- NFC
- bluetooth
- wifi
- Zigbee
- Z-wave

👉 **블루투스**로 제어

- 모바일 환경(스마트폰)에서 쉽게 제어가능 해야함(사용편의성)
- 실내 근거리 통신에 적합
- 낮은 전력과 비용
- 안드로이드, iOS 모두 동작해야함
  - Bluetooth Classic    (iOS에서 지원하지 않음)
  - Bluetooth Low Energy (BLE = bluetooth 4.0이상 버전)이 호환되어야 함

### Bluetooth 4.0+
- Hardware Module
  - HM-10
    - 3.3V, UUID: 0xFFE0
    - AT-COMMAND
- Software Module(App)
  - software reuse
    - Android : `Serial Bluetooth Terminal`
    - iOS     : `BitBlue`
  - customizing App
    - (ios, android)모두 호환, 빠르게 구현
    - 중간고사 끝나고 퍼포먼스/와이어프레임 결정
    - 구현 요소
      - GUI(Graphic User Interface): 버튼위젯 / 목록 위젯
      - 블루투스 연결
      - 추가사항 (알람기능, ...)
    - candidate SW tool
      - flutter (3시간)
      - ~~React native~~
      - unity (3시간+)

## Actuation

👉 **서보모터**로 제어
- 각도 제어와 강한 토크 전달이 주요 요인

### 서보모터 리스트

- 👉 SG90
  - 낮은 비용
  - 적은 무게
  - 작은 크기
- MG90S
- MG996R
- HS-311

## Physics Model

캐비넷 - 3D 프린팅

# Additional 

## 추가 고려사항
- 블루투스 동작과정
  - 블루투스 페어링
- 스위치는 수동으로도 누를 수 있게
  - 서보모터에 신호가 왔을 때만 동작 이후는 토크가 걸리지 않게(수동이 가능하게)
- 스위치 개수가 증가했을 때 원활히 관리방법
- 캐비넷 디자인
- 필요 전력 최소화?

## Reference

- 실제 시제품 리스트