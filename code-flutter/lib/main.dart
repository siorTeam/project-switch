import 'dart:async';
import 'dart:convert';
// import 'dart:io'; // Platform varriable
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// Connection Item
class ConnectInfo {
  String name;
  String signal;
  String remoteId;
  bool connected = false;

  // 생성자
  ConnectInfo({
    required this.name,
    required this.signal,
    required this.remoteId,
  });

  // ConnectInfo -> JSON 변환
  Map<String, dynamic> toJson() => {
    'name': name,
    'signal': signal,
    'remoteId': remoteId,
  };

  // JSON -> ConnectInfo 변환
  factory ConnectInfo.fromJson(Map<String, dynamic> json) {
    return ConnectInfo(
      name: json['name'],
      signal: json['signal'],
      remoteId: json['remoteId'],
    );
  }
}

// global snackbar
class MainSnackBar {
  static final snackBarKey = GlobalKey<ScaffoldMessengerState>();
  static show(String msg, bool error) {
    final staticSnackBar = error
      ? SnackBar(content: Text(msg, style: TextStyle(color: Colors.white),), backgroundColor: Colors.red)
      : SnackBar(content: Text(msg));
    snackBarKey.currentState?.removeCurrentSnackBar();
    snackBarKey.currentState?.showSnackBar(staticSnackBar);
  }
}

/// 블루투스 기능 모듈, Bluetooth Functionalities
class BluetoothModule {
  static List<BluetoothDevice> deviceList = [];
  static bool adapterEnabled = false;
  static late StreamSubscription<BluetoothAdapterState> subscription;

  // 어댑터 연결 확인 & 준비
  static Future<void> initSetup () async {
    FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true); // debug 용도

    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth not supported by this device");
      return;
    }
    subscription = FlutterBluePlus.adapterState.listen((BluetoothAdapterState state){
      print(state);
      if (state  == BluetoothAdapterState.on){
        adapterEnabled = true;
        print("Bluetooth is enabled, it can be ready to use");
      } else {
        adapterEnabled = false;
        print("Bluetooth is off or in error state");
      }
    });

    // if (Platform.isAndroid) {
    //   await FlutterBluePlus.turnOn();
    // }
  }
  static void dispose() {
    subscription.cancel();
  }

  // 스캔 시작
  static Future<void> startScanDevice() async {
    if (FlutterBluePlus.isScanningNow == false) {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    }
  }
  // 스캔 종료
  static Future<void> stopScanDevice() async {
    if (FlutterBluePlus.isScanningNow) {
      await FlutterBluePlus.stopScan();
    }
  }
  // 스캔 가져오기
  static Future<void> readScanDevice() async {
    // 감지된 기기 불러오기
    FlutterBluePlus.scanResults.listen(
      (results) async {
        if (results.isNotEmpty){
          deviceList.add(results.last.device);

          // Read All scan devices
          // for (ScanResult result in results){
          //   print("${result.timeStamp.toString()}:rssi=${result.rssi}:${result.device.toString()}:${result.advertisementData.toString()}");
          // }
        }
      },
      onError: (err) => print(err)
    );

    // wait for scanning to stop
    await FlutterBluePlus.adapterState.where((val)=>val==BluetoothAdapterState.on).first;
  }

  // 연결 시도
  static Future<void> connectDevice(BluetoothDevice device, ConnectInfo connectInfo) async {
    device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.connected) {
        connectInfo.connected = true;
        MainSnackBar.show("${device.advName} 이 성공적으로 연결되었습니다.", false);
      } else if (state == BluetoothConnectionState.disconnected) {
        connectInfo.connected = false;
      }
    });
    await device.connect(autoConnect: true);
  }
  // 연결 해제 시도
  static Future<void> disconnectedDevice(BluetoothDevice device, ConnectInfo connectInfo) async {
    device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.connected) {
        connectInfo.connected = true;
      } else if (state == BluetoothConnectionState.disconnected) {
        connectInfo.connected = false;
        MainSnackBar.show("${device.advName} 이 성공적으로 연결 해제되었습니다.", true);
      }
    });
    await device.disconnect();
  }

  // 값 보내기
  static Future<void> sendSignal(BluetoothDevice device, String data) async {
    try {
      List<BluetoothService> services = await device.discoverServices();
      BluetoothCharacteristic targetCharacteristic = services.first.characteristics.first; // 1st characteristic of 1st service
      targetCharacteristic.write(data.codeUnits);
      MainSnackBar.show("${device.advName}에 성공적으로 전송되었습니다.", false);
    } catch (err) {
      MainSnackBar.show("전송도중, 다음과 같은 오류: $err", true);
    }
  }
}

void main() {
  runApp(const MyApp()); // -> MaterialApp 을 바로 반환해도 동일
  BluetoothModule.initSetup();
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Switch',
      theme: ThemeData(
        brightness: Brightness.dark, // 어두운 배경
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white
        ),
        dialogTheme: DialogTheme(
          surfaceTintColor: Colors.blue,
        ),
      ),
      home: const MainPage() // start point -> Main Page
    );
  }
}

// Main Page
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<ConnectInfo> connectInfoList = [];

  void addOrModifyConnectInfo({ConnectInfo? connectInfo, int? index, String? remoteId}) {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return ConnectInfoDialog(
          connectInfo: connectInfo, 
          onSave: (name, signal) {
            setState((){
              if (connectInfo == null) {
                connectInfoList.add(ConnectInfo(name: name, signal: signal, remoteId: remoteId ?? ""));
              } else {
                connectInfoList[index!] = ConnectInfo(name: name, signal: signal, remoteId: connectInfo.remoteId);
              }
              saveConnectInfoList(); // 정보 저장
            });
          },
        );
      },
    );
  }

  void deleteConnectInfo(int index) {
    setState(() {
      connectInfoList.removeAt(index);
      saveConnectInfoList(); // 정보 저장
    });
  }

  Future<void> loadConnectInfoList() async {
    final prefs = await SharedPreferences.getInstance();
    final String? connectInfoListString = prefs.getString('connectInfoList');
    if (connectInfoListString != null) {
      final List<dynamic> jsonData = jsonDecode(connectInfoListString);
      setState(() {
        connectInfoList.clear();
        connectInfoList.addAll(jsonData.map((item) => ConnectInfo.fromJson(item)));
      });
    }
  }

  Future<void> saveConnectInfoList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("connectInfoList", jsonEncode(connectInfoList));
  }

  @override
  void initState() {
    super.initState();
    loadConnectInfoList(); // 정보 불러오기
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: MainSnackBar.snackBarKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Project Switch"),
        ),

        body: ListView.builder(
          itemCount: connectInfoList.length,
          itemBuilder: (context, index) {
            final connectInfo = connectInfoList[index];
            return Card(
              child: ListTile(
                leading: connectInfo.connected ? Icon(Icons.bluetooth_connected) : Icon(Icons.bluetooth_disabled),
                title: Text(connectInfo.name),
                subtitle: Text('Signal: ${connectInfo.signal}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => addOrModifyConnectInfo(connectInfo: connectInfo, index: index, remoteId: connectInfo.remoteId),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => deleteConnectInfo(index),
                    ),
                  ],
                ),
                onTap: () {
                  if (!BluetoothModule.adapterEnabled) {
                    MainSnackBar.show("블루투스를 연결 기능을 사용할 수 없습니다.", true);
                    return;
                  }
                  
                  if (connectInfo.connected) { // if connected -> send signal
                    BluetoothModule.sendSignal(
                      BluetoothDevice.fromId(connectInfo.remoteId),
                      connectInfo.signal
                    );
                  } else { // if not connected -> connect
                    BluetoothModule.connectDevice(
                      BluetoothDevice.fromId(connectInfo.remoteId),
                      connectInfo
                    );
                  }
                },
              ),
            );
          },
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          tooltip: '새로운 연결 추가',
          onPressed: () {
            // scan modal open
            if(!BluetoothModule.adapterEnabled){
              MainSnackBar.show("블루투스를 연결 기능을 사용할 수 없습니다.", true);
              return;
            }

            BluetoothModule.startScanDevice(); // 스캔 시작
            BluetoothModule.readScanDevice(); // 감지된 기기 목록에 추가

            List<BluetoothDevice> scannedDeviceList = BluetoothModule.deviceList;
            showModalBottomSheet(
              context: context, 
              builder: (context) => ListView.builder(
                itemCount: scannedDeviceList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        scannedDeviceList[index].advName.isEmpty
                          ? 'Unknown Device'
                          : scannedDeviceList[index].advName
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.add_link),
                        onPressed: (){
                          Navigator.of(context).pop(); // ModalBottomSheet 닫기
                          // connectInfoList에 추가 + 입력 팝업 열기
                          addOrModifyConnectInfo(connectInfo: null, index: null, remoteId: scannedDeviceList[index].remoteId.str); // device 전달
                        }
                      ),
                    ),
                  );
                },
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}



// ConnectInfo Add & Modify Page
class ConnectInfoDialog extends StatelessWidget {
  final ConnectInfo? connectInfo;
  final void Function(String name, String signal) onSave;

  const ConnectInfoDialog({
    super.key,
    this.connectInfo,
    required this.onSave
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: connectInfo?.name ?? "");
    final TextEditingController signalController = TextEditingController(text: connectInfo?.signal ?? "");

    return AlertDialog(
      title : Text(connectInfo == null ? "연결 정보 추가" : "연결 정보 수정"),
      content : Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            style: TextStyle(color: Colors.blue),
            decoration: InputDecoration(labelText: "연결 이름 (Name)", labelStyle: TextStyle(color: Colors.blue)), 
          ),
          TextField(
            controller: signalController,
            style: TextStyle(color: Colors.blue),
            decoration: InputDecoration(labelText: "전송 신호값 (Signal Value)", labelStyle: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text("취소"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            // 연결 이름에 빈 값은 입력되지 않게
            if (nameController.text.isEmpty) {
              MainSnackBar.show("연결 이름이 있어야 합니다.", false);
              return;
            }
            // 추가 & 수정
            onSave(nameController.text, signalController.text);
            Navigator.of(context).pop(true);
          }, 
          child: Text(connectInfo == null ? "추가" : "수정"),
        ),
      ],
    );
  }
}
