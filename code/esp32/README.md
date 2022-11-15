# ESP32

## IDE set up

아두이노 IDE에서 ESP32에 코드를 이식하기 위한 준비 방법입니다.

### Arduino IDE Set-up

1. `환경설정`을 선택
   1. 추가적인 보드 매니저 URLs의 항목에 아래의 내용을 입력(또는 옆의 창 버튼 클릭후 추가)
   2. `https://dl.espressif.com/dl/package_esp32_index.json`
2. `보드매니저`를 선택
   1. `esp32`를 검색하여 설치(`Espressif Systems`의 패키지)
3. `툴 > 보드`를 `ESP32 Dev Modules`로 설정합니다

### Driver Set-up

ESP32 보드에 있는 CP2102 칩(시리얼 통신 칩)의 드라이버를 설치합니다.

아래의 홈페이지에서 다운로드 해줍니다

https://www.silabs.com/developers/usb-to-uart-bridge-vcp-drivers?tab=downloads

64비트 Windows의 경우, `CP210xVCPInstaller_x64.exe`를 실행해줍니다

## `esp32.ino`

Processor에 해당하는 ESP32 개발보드에 업로드되는 코드입니다

- 단말기(스마트폰)에서
  - '0'을 보내면 45도로 설정
  - '1'을 보내면 135도로 설정
- 각도 설정후, 0.5초 뒤에 토크가 풀림

## Pin Setting

ESP32 보드와 연결하는 핀 구성은 아래와 같습니다

ESP32 Board Pin | Servo Pin
----|----
  5V|Servo VCC
 GND|Servo GND
 P13|Servo PWM


## Reference

- https://en.wikipedia.org/wiki/ESP32
- https://github.com/siorTeam/project-switch/issues/4
- https://github.com/espressif/arduino-esp32
