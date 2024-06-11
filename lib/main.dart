import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smartcart_app/pages/new_list_page.dart';
import 'pages/splash_screen.dart';
import 'pages/login_page.dart';
import 'package:smartcart_app/pages/home_page.dart';
import 'pages/add_item_page.dart';
import 'pages/sign_up_page.dart';
import 'pages/profile_page.dart';
import 'bloc/login/login_cubit.dart';
import 'bloc/register/register_cubit.dart';
import 'repositories/auth_repo.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => RegisterCubit(),
        ),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginPage(),
          '/sign_up': (context) => SignUpPage(), // Define the new route
          '/home': (context) => HomePage(),
          '/new_list': (context) => NewListPage(),
          '/add_item': (context) => AddItemPage(),
          '/profile': (context) => ProfilePage(),
        },
      ),
    );
  }
}
