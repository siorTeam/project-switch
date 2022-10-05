Project FORCE
===

# Architecture

## Communication

무선 통신 방법
- RF
  - 이동통신(2~5G)
  - 위성통신
- RFID
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
    - 3.3V, UUID:
    - [AT-COMMAND](./DSD%20TECH%20HM-10%20datasheet.pdf)
- Software Module(App)
  - pre-made
    - Android : Serial Bluetooth Terminal
    - iOS     : ???, BitBlue
  - customizing App
    - (ios, android)모두 동작되어야 함
      - flutter
      - React native
      - unity

## Actuation

서보모터로 제어
- PWM 제어
- [SG-90](./SG90.pdf)
- MG996r

## Physics Model

캐비넷 - 3D 프린팅

## 추가 고려사항
- 블루투스 동작과정
  - 블루투스 페어링
- 스위치는 수동으로도 누를 수 있게
- 스위치 개수가 증가했을 때 원활히 관리방법
- 캐비넷 디자인
- 필요 전력 최소화?
- 서보모터에 신호가 왔을 때만 동작 이후는 토크가 걸리지 않게(수동이 가능하게)

# Source code

[source code link](bt-servo.ino)

## Reference

- https://www.arduino.cc/reference/en/libraries/servo/
- https://docs.arduino.cc/learn/built-in-libraries/software-serial

https://www.11st.co.kr/products/3628094230?vkey=RLHIS0HZX24SKUXZ3933LKVUU4XMJ4&utm_term=&utm_campaign=%B4%D9%C0%BDpc_%B0%A1%B0%DD%BA%F1%B1%B3%B1%E2%BA%BB&utm_source=%B4%D9%C0%BD_PC_PCS&utm_medium=%B0%A1%B0%DD%BA%F1%B1%B3

https://www.ssg.com/item/itemView.ssg?itemId=1000360879248&siteNo=7014&salestrNo=6005&ckwhere=ssg_naver&appPopYn=n&utm_medium=PCS&utm_source=naver&utm_campaign=naver_pcs&NaPm=ct%3Dl8qp2gzc%7Cci%3Da2d01369b895f6abfc5981103c02d82697578c3c%7Ctr%3Dsls%7Csn%3D218835%7Chk%3Dcdeb0c0484a78bc4c0fe57161b5c79d2a4e7ff19