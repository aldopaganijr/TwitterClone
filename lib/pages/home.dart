import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/pages/create.dart';
import 'package:twitter_clone/pages/settings.dart';
import 'package:twitter_clone/providers/user_provider.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Padding(
                padding: const EdgeInsets.all(9),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    ref.watch(userProvider).user.profilePic,
                  ),
                ),
              ),
            );
          },
        ),
        title: Text("Home"),
      ),
      body: Column(
        children: [Text(currentUser.user.email), Text(currentUser.user.name)],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Image.network(currentUser.user.profilePic),
            ListTile(
              title: Text(
                'Hello ${currentUser.user.name}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            ListTile(
              title: Text('Settings'),
              onTap:
                  () => {
                    Navigator.pop(context),
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Settings()),
                    ),
                  },
            ),
            ListTile(
              title: Text('Sign Out'),
              onTap:
                  () => {
                    FirebaseAuth.instance.signOut(),
                    ref.read(userProvider.notifier).logOut(),
                  },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => CreateTweet()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
