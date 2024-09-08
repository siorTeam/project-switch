# Project Switch

무선으로 전등 스위치, Mobile App Part

## 시작하기

구현된 앱은 [build 폴더](build/) 아래에 있는 빌드파일을 각 플랫폼(안드로이드/iOS)에 맞게 다운로드후 실행.
- 안드로이드: *.aab, *.apk
- iOS: *.ipa

## 개발 가이드

App을 구성하는 모든 소스코드는 [lib 폴더](lib/) 내에 있다.  
[`main.dart`](lib/main.dart)에서 메인 소스코드가 시작되며 개발에 필요한 모든 위젯과 동작코드들이 있다.

1. 개발 시작

   1. 플러터, 편집기/IDE 구성
   2. 아래 명령 실행하여 프로젝트 준비
      ```sh
      git clone git@github.com:siorTeam/project-switch.git # 소스코드 다운로드
      cd project-switch/code-flutter # 프로젝트 폴더로 이동
      # flutter clean                # 패키지 정리 (필요시)
      flutter pub get                # 필요 패키지 설치 + 구성
      flutter run                    # 최초 실행: 빌드 자료 구성 + 테스트
      ```

2. 개발 테스트

   개발 도중 결과물 테스트를 위해 아래 명령을 실행
   ```sh
   flutter run
   # 타겟 플랫폼 기기 선택
   # Hot reload는 `r` 입력
   ```

3. 개발 앱 빌드

   1. 개발이 완료되어 최종 결과물을 빌드하기 위해서는 아래 명령을 실행
      ```sh
      # Android Platform
      flutter build appbundle --release  # .aab
      flutter build apk --release        # .apk
   
      # iOS Platform
      flutter build ipa --release        # .ipa
      ```
   2. 결과는 깃헙 build 폴더 아래에 직접 추가 (.gitignore 에서 push를 막아둬 직접 업로드 필요)
