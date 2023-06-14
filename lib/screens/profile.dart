import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String? uid;

  const ProfilePage({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var user = snapshot.data!;
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // SizedBox(
                    //   height:5,
                    // ),
                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 25,
                    ),
                    Text(
                      'Name:  ${user['name']}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 50,
                    ),
                    Text(
                      'Email: ${user['email']}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 50,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      padding: EdgeInsets.only(left: 100, right: 100),
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to the edit profile page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfilePage(uid: uid)),
                          );
                        },
                        child: const Text('Edit'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final String? uid;

  EditProfilePage({super.key, required this.uid});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  void validateData() async {
    if (nameController.text.trim().isEmpty) {
      Flushbar(
        title: 'Name is Missing',
        message: 'Please name',
        flushbarPosition: FlushbarPosition.BOTTOM,
        backgroundColor: Colors.black54,
        duration: const Duration(seconds: 3),
      ).show(context);
    } else if (emailController.text.trim().isEmpty) {
      Flushbar(
        title: 'Email is Missing',
        message: 'Please enter email',
        flushbarPosition: FlushbarPosition.BOTTOM,
        backgroundColor: Colors.black54,
        duration: const Duration(seconds: 3),
      ).show(context);
    } else {
      updateProfile();
    }
  }

  void updateProfile() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .update({
        'name': nameController.text,
        'email': emailController.text,
      });
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle update error
      if (kDebugMode) {
        print('Error updating profile: $e');
      }
    }
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 150,
            ),
            Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 1.5,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(7.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          labelText: 'Name', border: InputBorder.none)),
                )),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width / 1.5,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(7.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        labelText: 'Email', border: InputBorder.none)),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              padding: const EdgeInsets.only(left: 100, right: 100),
              child: ElevatedButton(
                  onPressed: validateData,
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Update Profile',
                          style: TextStyle(fontSize: 18),
                        )),
            ),
          ],
        ),
      ),
    );
  }
}
