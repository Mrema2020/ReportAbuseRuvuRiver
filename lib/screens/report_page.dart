import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ruvu/screens/home_page.dart';

class ReportPage extends StatefulWidget {
  final address;
  const ReportPage({super.key, this.address});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _controller = TextEditingController();
  final _mapLocation = TextEditingController();
  File? _image;
  final _picker = ImagePicker();
  var isLoading = false;
  UploadTask? uploadTask;
  var progress = 0.0;

  // @override
  // void initState() {
  //   _mapLocation.text = widget.address;
  //   //print('address is ${widget.address}');
  //   super.initState();
  // }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  uploadImages() async {
    final image = File(_image!.path);
    User? user = FirebaseAuth.instance.currentUser;
    if (_image != null &&
        _controller.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _mapLocation.text.isNotEmpty) {
      try {
        setState(() {
          isLoading = true;
        });
        String fileName = image.path.split('/').last;
        final storageRef = FirebaseStorage.instance.ref();
        final metadata = SettableMetadata(contentType: "image/jpeg");
        final uploadTask =storageRef.child("images/$fileName").putFile(image, metadata);

        uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
          switch (taskSnapshot.state) {
            case TaskState.running:
              setState(() {
                progress = 100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes).round();
              });
              break;
            case TaskState.paused:
              print("Upload is paused.");
              break;
            case TaskState.canceled:
              print("Upload was canceled");
              break;
            case TaskState.error:
              setState(() {
                isLoading = false;
              });
              // Handle unsuccessful uploads
              break;
            case TaskState.success:
              taskSnapshot.ref.getDownloadURL().then((value) {
                _firestore.collection('reports').add({
                  'category': _controller.text.trim(),
                  'address': _addressController.text.trim(),
                  'mapLocation': _mapLocation.text.trim(),
                  'description': _descriptionController.text.trim(),
                  'image': value,
                  'userId': user!.uid,
                  'status': 'processing',
                  'date': DateTime.now()
                }).then((value) {
                  _controller.clear();
                  _addressController.clear();
                  _mapLocation.clear();
                  _descriptionController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data added successfully')),
                  );
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomePage()));
                }).catchError((error) {
                  setState(() {
                    isLoading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error)),
                  );
                });
              });
              // Handle successful uploads on complete
              // ...
              break;
          }
        });
      } catch (error) {
        print("error is $error");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('please fill out all the fields')),
      );
    }
  }

  String _selectedValue = '';

  final List<String> _dropdownItems = [
    'Select category',
    'Water pollution',
    'Animal keeping',
    'Water blockage',
    'Agriculture activities',
    'Waste disposal',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Report'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Report a problem',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Help to protect the environment',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Select category',
                        border: OutlineInputBorder(),
                      ),
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _showDropdown(context);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Address',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _addressController,
                      keyboardType: TextInputType.streetAddress,
                      decoration: const InputDecoration(
                        labelText: 'address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Map Location',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _mapLocation,
                      keyboardType: TextInputType.streetAddress,
                      decoration: const InputDecoration(
                        labelText: 'Map Location',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Add pictures',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ClipRRect(
                child: Card(
                  color: Colors.blueGrey,
                  child: IconButton(
                    onPressed: () {
                      _openImagePicker();
                    },
                    icon: const Icon(Icons.cloud),
                  ),
                ),
              ),
              const SizedBox(height: 35),
              // The picked image will be displayed here
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 300,
                color: Colors.grey[300],
                child: _image != null
                    ? Image.file(_image!, fit: BoxFit.cover)
                    : const Text('Please select an image'),
              ),
              const SizedBox(
                height: 20,
              ),
              buildProgress(),
              const SizedBox(
                height: 20,
              ),
            ]),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 70,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    isLoading ? () {} : uploadImages();
                  },
                  child: Container(
                    height: 70,
                    width: isLoading ? size.width - 60 : size.width - 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.green),
                    child: Center(
                        child: Text(isLoading ? progress>=100?"finishing..":progress.toString() : 'submit',
                            style: const TextStyle(color: Colors.white))),
                  ),
                ),
                Visibility(
                  visible: isLoading ? true : false,
                  child: Container(
                    height: 70,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.green),
                    child: const Center(
                        child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            double progress = data.bytesTransferred / data.totalBytes;
            return SizedBox(
              height: 50,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.green,
                  ),
                  Center(
                    child: Text(
                      '${(100 * progress).roundToDouble()}%',
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            );
          } else {}
          return Container();
        },
      );

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  void _showDropdown(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select category'),
          content: DropdownButton<String>(
            value: _dropdownItems[0],
            onChanged: (value) {
              setState(() {
                _selectedValue = value!;
                _controller.text = value;
              });
              Navigator.of(context).pop();
            },
            items: _dropdownItems.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
