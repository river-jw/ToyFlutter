// 실행: dart run lib/grammar/mixin/practice.dart

/*
  ================================================================
   문제: BLE 기기 관리
  ================================================================

  각 요구사항마다 extends / implements / with 중 무엇을 쓸지 직접 고르고,
  고른 키워드 위에 "왜 이걸 골랐는지" 주석을 한 줄씩 달아보세요.

  [등장 클래스]
   - HeartRateSensor : 심박 센서
   - SmartWatch      : 스마트워치
   - Thermometer     : 온도계
   - ServerApi       : 서버 통신 (BLE 기기 아님!)

  [힌트]
   - extends    : 코드 O, 1개만
   - implements : 코드 X (약속만), 여러 개
   - with       : 코드 O, 여러 개
 */

// ----------------------------------------------------------------
// [요구사항 3]  ※ BleDevice 에서 먼저 쓰기 때문에 맨 위로 올림
//  모든 BLE 기기 + ServerApi 는 log(String msg) 로 로그를 찍는다.
//  형식은 전부 똑같다 →  [클래스이름] 메시지
//  (힌트: 클래스 이름은 runtimeType 으로 얻을 수 있다)
// ----------------------------------------------------------------
// [왜 mixin?] 부모가 서로 다른 BleDevice 계열과 ServerApi 가 "똑같은 코드" 를 같이 써야 하니까.
mixin Logger {
  void log(String msg) {
    print("[$runtimeType] $msg");   // 문자열 안 변수는 $변수
  }
}


// ----------------------------------------------------------------
// [요구사항 1]
//  모든 BLE 기기는 "이름(name)" 과 "MAC 주소(macAddress)" 없이는 만들 수 없다.
//  모든 BLE 기기는 connect() 를 가진다.
//  connect() 는 "[클래스이름] {name} 연결" 을 출력한다.
// ----------------------------------------------------------------
// [왜 abstract class?] "BLE 기기다" 라는 정체성(is-a) + 생성자로 name, mac 을 강제해야 하니까.
//                      BleDevice 자체로 객체를 만들 일은 없으니 abstract.
// [왜 with Logger?]   connect() 에서 log() 를 쓰려고. 여기 붙이면 자식들도 자동으로 Logger 를 가진다.
abstract class BleDevice with Logger {
  final String name;
  final String macAddress;
  BleDevice(this.name, this.macAddress);   // this.xxx → 받은 값을 필드에 바로 저장

  // 연결 출력은 모든 기기가 똑같으니 여기서 구현
  void connect() {
    log("$name 연결");
  }
}


// ----------------------------------------------------------------
// [요구사항 2]
//  HeartRateSensor 와 SmartWatch 는 펌웨어 업데이트 updateFirmware() 를 할 수 있다.
//  단, 업데이트 "방법" 이 서로 다르다.
//   - HeartRateSensor : "BLE로 펌웨어 전송"
//   - SmartWatch      : "Wi-Fi로 펌웨어 다운로드"
//  Thermometer 는 업데이트 기능이 없다.
// ----------------------------------------------------------------
// [왜 implements?] 기능(업데이트)은 같지만 "방법(코드)" 이 기기마다 다르다.
//                  나눠 쓸 코드가 없으니 약속만 정하고, 구현은 각 클래스가 직접.
abstract class FirmwareUpdater {
  void updateFirmware();
}


// ----------------------------------------------------------------
// [요구사항 4]
//  HeartRateSensor 와 SmartWatch 는 배터리가 있다. (Thermometer 는 전원 연결형)
//  checkBattery() : 배터리가 20 미만이면 "배터리 부족!" 로그를 찍는다.
//                   → 이 로직은 둘 다 "똑같다".
//  배터리 "값" 은 기기마다 다르다.
//   - HeartRateSensor : 15
//   - SmartWatch      : 80
//  (힌트: mixin 안에 "추상 getter" 를 두면 값은 각 클래스가 채울 수 있다)
// ----------------------------------------------------------------
// [왜 mixin?]     checkBattery() 로직이 둘 다 "똑같다" → 코드를 한 곳에 두고 나눠 쓴다.
// [왜 on Logger?] Battery 안에서 log() 를 부르려면 "Logger 가 있는 클래스에만 붙는다" 는 보장이 필요.
mixin Battery on Logger {
  int get batteryLevel;   // 추상 getter: 값은 붙이는 클래스가 채운다 (mixin 은 생성자가 없으니까)

  void checkBattery() {
    if (batteryLevel < 20) {   // 20 "미만"
      log("배터리 부족!");
    }
  }
}


// ----------------------------------------------------------------
// [클래스 작성]
//  위에서 만든 것들을 조합해서 4개 클래스를 완성하세요.
// ----------------------------------------------------------------
class HeartRateSensor extends BleDevice with Battery implements FirmwareUpdater {
  HeartRateSensor() : super("HR-01", "AA:BB:CC:00:00:01");   // 부모가 요구한 값을 super 로 넘김

  @override
  int get batteryLevel => 15;

  @override
  void updateFirmware() {
    log("BLE로 펌웨어 전송");
  }
}

class SmartWatch extends BleDevice with Battery implements FirmwareUpdater {
  SmartWatch() : super("Watch-7", "AA:BB:CC:00:00:02");

  @override
  int get batteryLevel => 80;

  @override
  void updateFirmware() {
    log("Wi-Fi로 펌웨어 다운로드");
  }
}

// 배터리 X, 업데이트 X → BleDevice 만 상속
class Thermometer extends BleDevice {
  Thermometer() : super("Thermo-1", "AA:BB:CC:00:00:03");
}

// BLE 기기가 아니니까 BleDevice 상속 X, 로그 기능만 빌려 쓴다
class ServerApi with Logger {
  void fetch() {
    log("서버 응답 수신");
  }
}


void main() {
  final sensor = HeartRateSensor();
  sensor.connect();
  sensor.updateFirmware();
  sensor.checkBattery();

  final watch = SmartWatch();
  watch.connect();
  watch.updateFirmware();
  watch.checkBattery();      // 80 이라 아무것도 안 찍혀야 정상

  Thermometer().connect();
  ServerApi().fetch();

  /*
    [기대 출력]
    [HeartRateSensor] HR-01 연결
    [HeartRateSensor] BLE로 펌웨어 전송
    [HeartRateSensor] 배터리 부족!
    [SmartWatch] Watch-7 연결
    [SmartWatch] Wi-Fi로 펌웨어 다운로드
    [Thermometer] Thermo-1 연결
    [ServerApi] 서버 응답 수신
   */

  // ----------------------------------------------------------------
  // [마지막 확인] 아래 줄의 주석을 하나씩 풀었을 때 "컴파일 에러" 가 나야 정상입니다.
  //  왜 에러가 나는지 설명할 수 있으면 완벽하게 이해한 것!
  // ----------------------------------------------------------------
  // Thermometer().updateFirmware();   // 온도계는 FirmwareUpdater 를 implements 안 했으니까
  // Thermometer().checkBattery();     // 온도계는 Battery 를 with 안 했으니까
  // ServerApi().connect();            // 서버는 BleDevice 를 extends 안 했으니까
}
