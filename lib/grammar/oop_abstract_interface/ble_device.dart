abstract class BleDevice {
  String deviceName;
  BleDevice(this.deviceName);

  void connect();
  void disconnect();
  void readBatteryLevel();
}