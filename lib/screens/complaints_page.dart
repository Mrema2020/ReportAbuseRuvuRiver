import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruvu/controllers/reports.dart';
import 'package:ruvu/screens/map.dart';

class ComplaintsPage extends StatefulWidget {
  final String? userId;

  const ComplaintsPage({super.key, required this.userId});

  @override
  State<ComplaintsPage> createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  User? user = FirebaseAuth.instance.currentUser;
  final report = Get.put(ReportsController());

  @override
  void initState() {
    report.getComplaints();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My complaints'),
        centerTitle: true,
      ),
      body: Obx(()=> Center(
        child: report.isLoading.value
        ? const CircularProgressIndicator()
        : report.complaints.isEmpty
        ? const Text('No Complaints')
        : ListView.builder(
          itemCount: report.complaints.length,
          itemBuilder: (context,index){
            var reporta = report.complaints[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(15,3), // changes the position of the shadow
                    ),
                  ],
                ),
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(reporta['image'])
                        )
                      ),
                    ),
                    const SizedBox(width: 5),
                    SizedBox(
                      width: size.width-115,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children:  <TextSpan>[
                                const TextSpan(
                                  text: 'category:  ',
                                  style: TextStyle(fontWeight: FontWeight.w300,fontSize: 17,color: Colors.black),
                                ),
                                TextSpan(
                                  text: reporta['category'],
                                  style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 17,color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children:  <TextSpan>[
                                const TextSpan(
                                  text: 'description:  ',
                                  style: TextStyle(fontWeight: FontWeight.w300,fontSize: 17,color: Colors.black),
                                ),
                                TextSpan(
                                  text: reporta['description'],
                                  style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 17,color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children:  <TextSpan>[
                                const TextSpan(
                                  text: 'address:  ',
                                  style: TextStyle(fontWeight: FontWeight.w300,fontSize: 17,color: Colors.black),
                                ),
                                TextSpan(
                                  text: reporta['address'],
                                  style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 17,color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children:  <TextSpan>[
                                    const TextSpan(
                                      text: 'status:  ',
                                      style: TextStyle(fontWeight: FontWeight.w300,fontSize: 17,color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: reporta['status'],
                                      style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 17,color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute( builder: (context) =>  ViewMap(data: reporta)));
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.green
                                  ),
                                  child: const Padding(
                                    padding:  EdgeInsets.all(2.0),
                                    child: Icon(Icons.place,color: Colors.white),
                                  )
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
            // return Padding(
            //   padding: const EdgeInsets.all(2.0),
            //   child: ListTile(
            //     title: Text("Category: ${reporta['category']}"),
            //     subtitle:Text("Description: ${reporta['description']}"),
            //     trailing:  Text("Address: ${reporta['address']}"),
            //     leading: const Icon(Icons.feedback,
            //       color: Colors.orangeAccent,
            //     ),
            //   ),
            // );
          },
        ),
      )),
    );
  }
}
