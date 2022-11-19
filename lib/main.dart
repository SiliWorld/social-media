import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:social_media_app/bloc/auth_cubit.dart';
import 'package:social_media_app/screens/chat.dart';
import 'package:social_media_app/screens/create_post.dart';
import 'package:social_media_app/screens/post_screen.dart';
import 'package:social_media_app/screens/sign_in.dart';
import 'package:social_media_app/screens/sign_up.dart';

Future<void> main() async {
  await SentryFlutter.init((options) {
    options.dsn =
        'https://18d46d13b09149309d0e0c46ce071127@o4504165230903296.ingest.sentry.io/4504165232607232';
  },
      // Init your App.
      appRunner: () async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  Widget _buildHomeScreen() {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PostScreen();
          } else {
            return SignInScreen();
          }
        });
  }

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: _buildHomeScreen(),
        routes: {
          SignInScreen.id: (context) => const SignInScreen(),
          SignUpScreen.id: (context) => const SignUpScreen(),
          PostScreen.id: (context) => const PostScreen(),
          CreatePost.id: (context) => const CreatePost(),
          ChatScreen.id: (context) => const ChatScreen(),
        },
      ),
    );
  }
}
