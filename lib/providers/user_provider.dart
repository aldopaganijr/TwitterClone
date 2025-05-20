// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/models/user.dart';

final userProvider = StateNotifierProvider<UserNotifier, LocalUser>((ref) {
  return UserNotifier();
});

class LocalUser {
  const LocalUser({required this.id, required this.user});

  final String id;
  final FirebaseUser user;

  LocalUser copyWith({String? id, FirebaseUser? user}) {
    return LocalUser(id: id ?? this.id, user: user ?? this.user);
  }
}

class UserNotifier extends StateNotifier<LocalUser> {
  UserNotifier()
    : super(
        LocalUser(
          id: "error",
          user: FirebaseUser(
            email: "error",
            name: 'error',
            profilePic: 'error',
          ),
        ),
      );

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> login(String email) async {
    QuerySnapshot response =
        await _firestore
            .collection("users")
            .where('email', isEqualTo: email)
            .get();

    state = LocalUser(
      id: response.docs[0].id,
      user: FirebaseUser.fromMap(
        response.docs[0].data() as Map<String, dynamic>,
      ),
    );
  }

  Future<void> updateName(String name) async {
    await _firestore.collection('users').doc(state.id).update({'name': name});

    state = state.copyWith(user: state.user.copyWith(name: name));
  }

  Future<void> updatePicture(File image) async {
    Reference ref = _storage.ref().child("users").child(state.id);
    TaskSnapshot snapchat = await ref.putFile(image);
    String profilePicUrl = await snapchat.ref.getDownloadURL();

    await _firestore.collection('users').doc(state.id).update({
      'profilePic': profilePicUrl,
    });

    state = state.copyWith(
      user: state.user.copyWith(profilePic: profilePicUrl),
    );
  }

  Future<void> signUp(String email) async {
    DocumentReference response = await _firestore
        .collection("users")
        .add(
          FirebaseUser(
            email: email,
            name: 'No name',
            profilePic:
                'https://plus.unsplash.com/premium_photo-1678112180514-478cd1218101?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8dXJsfGVufDB8fDB8fHww',
          ).toMap(),
        );
    DocumentSnapshot snapshot = await response.get();
    state = LocalUser(
      id: response.id,
      user: FirebaseUser.fromMap(snapshot.data() as Map<String, dynamic>),
    );
  }

  void logOut() {
    state = LocalUser(
      id: "error",
      user: FirebaseUser(email: "error", name: 'error', profilePic: 'error'),
    );
  }
}
