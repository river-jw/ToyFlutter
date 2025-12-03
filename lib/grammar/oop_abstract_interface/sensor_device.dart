import 'package:toy_flutter/grammar/oop_abstract_interface/OTAUpdate.dart';
import 'package:toy_flutter/grammar/oop_abstract_interface/ble_device.dart';

/*
  Flutter는 추상 클래스도 implements로 사용 할 수 있다.
 예외케이스
 1)implment 를 쓰면 부모의 구현부를 물려받지 않고 오로지 시그니처 메서드만 상속 받기 때문에 이미 구현된 메서드 까지 모두 구현해야함.
 2)생성자가 있는 추상 클래스는 implements를 쓸 수 없음.
 */
class SensorDevice extends BleDevice implements OTAUpdate {
  SensorDevice(super.deviceName);

  @override
  void connect() {
    // TODO: implement connect
  }

  @override
  void disconnect() {
    // TODO: implement disconnect
  }

  @override
  void readBatteryLevel() {
    // TODO: implement readBatteryLevel
  }

  @override
  void updateFirmware() {
    // TODO: implement updateFirmware
  }

}