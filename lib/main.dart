import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:multi_timer_flutter/noti/noti_controller.dart';
import 'package:multi_timer_flutter/page/home.dart';

// https://pub.dev/packages/awesome_notifications#-how-to-show-local-notifications
void main() {
  AwesomeNotifications().initialize(
    'resource://drawable/launcher_icon',
    [
      NotificationChannel(
          channelGroupKey: 'timer_channel_group',
          channelKey: 'timer_channel',
          channelName: 'Multi Timer',
          channelDescription: 'Multi Timer 알림',
          ledColor: Colors.white,
          criticalAlerts: true,
          importance: NotificationImportance.Max
      ),
    ],
    // Channel groups are only visual and are not required
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'timer_channel_group',
        channelGroupName: '타이머 알람 group'),
    ],
    debug: true
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const String name = '멀티 타이머';
  static const Color mainColor = Colors.deepPurple;

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
    );

    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      // The navigator key is necessary to allow to navigate through static methods
      navigatorKey: MyApp.navigatorKey,

      title: MyApp.name,
      color: MyApp.mainColor,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ko', ''),
      ],

      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) =>
                const MyHomePage(title: MyApp.name)
            );
          default:
            assert(false, 'Page ${settings.name} not found');
            return null;
        }
      },

      theme: ThemeData(
          primarySwatch: Colors.deepPurple
      ),
    );
  }
}