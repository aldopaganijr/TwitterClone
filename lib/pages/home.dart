import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart' hide Image;
import 'package:twitter_clone/models/tweet.dart';
import 'package:twitter_clone/pages/create.dart';
import 'package:twitter_clone/pages/settings.dart';
import 'package:twitter_clone/providers/tweet_provider.dart';
import 'package:twitter_clone/providers/user_provider.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<Home> {
  bool clicked = false;
  SMIInput<bool>? _pressed;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(artboard, 'Button');
    artboard.addController(controller!);
    _pressed = controller.findInput('Press');
  }

  @override
  Widget build(BuildContext context) {
    LocalUser currentUser = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: Container(color: Colors.grey, height: 1),
        ),
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
        actions: [
          AnimatedOpacity(
            opacity: clicked ? 1 : 0,
            duration: Duration(seconds: 1),
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: CircleAvatar(
                radius: 60,
                child: Image.asset('assets/mars.png'),
              ),
            ),
          ),
        ],
        title: Image(image: AssetImage('assets/twitterlogo.png'), width: 50),
      ),
      body: ref
          .watch(feedProvider)
          .when(
            data: (List<Tweet> tweets) {
              return ListView.separated(
                separatorBuilder:
                    (context, index) => Divider(color: Colors.black),
                itemCount: tweets.length,
                itemBuilder: (context, count) {
                  return ListTile(
                    leading: CircleAvatar(
                      foregroundImage: NetworkImage(tweets[count].profilePic),
                    ),
                    title: Text(
                      tweets[count].name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      tweets[count].tweet,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  );
                },
              );
            },
            error: (error, stackTrace) => Center(child: Text('Error')),
            loading: () => CircularProgressIndicator(),
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
      floatingActionButton: AnimatedContainer(
        padding: const EdgeInsets.only(top: 90),
        alignment: clicked ? Alignment.topRight : Alignment.bottomRight,
        duration: const Duration(seconds: 1),
        child: SizedBox(
          width: 100,
          height: 100,
          child: GestureDetector(
            onTapDown: (_) {
              setState(() {
                clicked = true;
              });
              _pressed?.value = true;
              Future.delayed(const Duration(seconds: 2), () {
                setState(() {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CreateTweet()),
                  );
                  setState(() {
                    clicked = false;
                  });
                });
              });
            },
            onTapCancel: () => _pressed?.value = false,
            onTapUp: (_) => _pressed?.value = false,
            child: RiveAnimation.asset(
              'assets/rocket.riv',
              onInit: _onRiveInit,
            ),
          ),
        ),
      ),
    );
  }
}
