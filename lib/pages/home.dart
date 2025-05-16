import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/providers/user_provider.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              ref.read(userProvider.notifier).logOut();
            },
            child: Text('Sign Out', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Column(
        children: [
          Text(ref.watch(userProvider).user.email),
          Text(ref.watch(userProvider).user.name),
          CircleAvatar(
            backgroundImage: NetworkImage(
              ref.watch(userProvider).user.profilePic,
            ),
          ),
        ],
      ),
    );
  }
}
