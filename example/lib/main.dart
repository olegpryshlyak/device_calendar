import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';

import 'common/app_routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(),
      routes: {
        AppRoutes.calendars: (context) {
          return const CalendarPermissionsPage();
        }
      },
    );
  }
}



class CalendarPermissionsPage extends StatefulWidget {
  const CalendarPermissionsPage({Key? key}) : super(key: key);

  @override
  State<CalendarPermissionsPage> createState() => _CalendarPermissionsPageState();
}

class _CalendarPermissionsPageState extends State<CalendarPermissionsPage> {
  String _permissionStatus = "Unknown";
  late final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Calendar Permissions'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _showActionSheet(context),
              child: Text('Manage Calendar Permissions'),
            ),
            SizedBox(height: 20),
            Text('Permission Status: $_permissionStatus'),
          ],
        ),
      ),
    );
  }

  void _showActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text('Request Write Only Access'),
                  onTap: () => _requestCalendarAccess(context, false)),
              ListTile(
                  leading: Icon(Icons.calendar_view_day),
                  title: Text('Request Full Access'),
                  onTap: () => _requestCalendarAccess(context, true)),
              ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Check Permission Status'),
                  onTap: () {
                    _checkPermissionStatus();
                    Navigator.pop(context);
                  }),
            ],
          ),
        );
      },
    );
  }

  Future<void> _requestCalendarAccess(BuildContext context, bool fullAccess) async {
    final result = await _deviceCalendarPlugin.requestPermissions(fullAccess);
    setState(() {
      _permissionStatus = result.data == true ? 'Granted' : 'Denied';
    });
    Navigator.pop(context);
  }

  void _checkPermissionStatus() async {
    final result1 = (await _deviceCalendarPlugin.hasPermissions(true))?.data == true;
    final result2 = (await _deviceCalendarPlugin.hasPermissions(false))?.data == true;
    final result3 = (await _deviceCalendarPlugin.permissionsPermanentlyDenied())?.data == true;
    setState(() {
      _permissionStatus = 'full: $result1, write: $result2, denied: $result3';
    });
  }
}