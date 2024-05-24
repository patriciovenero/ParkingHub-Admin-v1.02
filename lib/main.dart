import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyectogaraje/AuthState.dart';
import 'package:proyectogaraje/screen/NavigationBarApp.dart';
import 'package:proyectogaraje/screen/login.dart';
import 'package:proyectogaraje/screen/WelcomeScreen.dart';
import 'package:proyectogaraje/socket_service.dart';

void main() {
  // Inicializa OneSignal antes de ejecutar la aplicación
  WidgetsFlutterBinding.ensureInitialized();

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize("d9f94d6b-d05c-4268-98af-7cd5c052fe9c");

  // Habilita las notificaciones push
  OneSignal.Notifications.requestPermission(true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthState>(create: (context) => AuthState()),
        ChangeNotifierProvider<SocketService>(
          create: (context) =>
              SocketService(serverUrl: 'https://test-2-slyp.onrender.com'),
        ),
      ],
      child: MaterialApp(
        title: 'PARKING HUB',
        home: AuthCheck(),
      ),
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkLoginStatus(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.data == true) {
            final authState = Provider.of<AuthState>(context);
            return authState.isAuthenticated
                ? const NavigationBarApp()
                : LoginPage();
          } else {
            return WelcomeScreen();
          }
        }
      },
    );
  }

  Future<bool> _checkLoginStatus(BuildContext context) async {
    final authState = Provider.of<AuthState>(context, listen: false);
    await authState.loadToken();
    return authState.isAuthenticated;
  }
}
