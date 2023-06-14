import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruvu/controllers/reports.dart';
import 'package:ruvu/screens/map.dart';

class Weekly extends StatefulWidget {
  const Weekly({super.key});

  @override
  State<Weekly> createState() => _WeeklyState();
}

class _WeeklyState extends State<Weekly> {
  final report = Get.put(ReportsController());
   @override
     void initState() {
    report.getWeeklyReportCount();
    report.weeklyDone();
    print('weekly reports are ${report.weeklyReports}');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final report = Get.put(ReportsController());
    var size = MediaQuery.of(context).size;
    return SizedBox(
      child: Obx(() => Center(
      child: report.isLoading.value
          ? const CircularProgressIndicator()
          : report.weeklyReports.isEmpty
              ? const Text('No Complaints this week')
              : ListView.builder(
                  itemCount: report.weeklyReports.length,
                  itemBuilder: (context, index) {
                    var reporta = report.weeklyReports[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: const Offset(15,
                                  3), // changes the position of the shadow
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
                                      image: NetworkImage(
                                          reporta['image']))),
                            ),
                            const SizedBox(width: 5),
                            SizedBox(
                              width: size.width - 115,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context)
                                          .style,
                                      children: <TextSpan>[
                                        const TextSpan(
                                          text: 'category:  ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 17,
                                              color: Colors.black),
                                        ),
                                        TextSpan(
                                          text: reporta['category'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 17,
                                              color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context)
                                          .style,
                                      children: <TextSpan>[
                                        const TextSpan(
                                          text: 'description:  ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 17,
                                              color: Colors.black),
                                        ),
                                        TextSpan(
                                          text: reporta['description'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 17,
                                              color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context)
                                          .style,
                                      children: <TextSpan>[
                                        const TextSpan(
                                          text: 'address:  ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 17,
                                              color: Colors.black),
                                        ),
                                        TextSpan(
                                          text: reporta['address'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 17,
                                              color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style:
                                              DefaultTextStyle.of(context)
                                                  .style,
                                          children: <TextSpan>[
                                            const TextSpan(
                                              text: 'status:  ',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.w300,
                                                  fontSize: 17,
                                                  color: Colors.black),
                                            ),
                                            TextSpan(
                                              text: reporta['status'],
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.w400,
                                                  fontSize: 17,
                                                  color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewMap(
                                                          data:
                                                              reporta)));
                                        },
                                        child: Container(
                                            decoration:
                                                const BoxDecoration(
                                                    color: Colors.green),
                                            child: const Padding(
                                              padding:
                                                  EdgeInsets.all(2.0),
                                              child: Icon(Icons.place,
                                                  color: Colors.white),
                                            )),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                            onTap: () {
                                              report.updateReport(
                                                  reporta['date']);
                                            },
                                            child: Container(
                                                height: 30,
                                                width: 30,
                                                decoration:
                                                    const BoxDecoration(
                                                        color:
                                                            Colors.green),
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets
                                                            .all(2.0),
                                                    child: reporta['status'] ==
                                                            "processing"
                                                        ? const Icon(
                                                            Icons.work)
                                                        : report.isUpdating
                                                                .value
                                                            ? const SizedBox(
                                                                width: 12,
                                                                height:
                                                                    12,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: Colors
                                                                      .white,
                                                                  strokeWidth:
                                                                      1,
                                                                ),
                                                              )
                                                            : const Icon(
                                                                Icons
                                                                    .done,
                                                                color: Colors
                                                                    .white))),
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
                  },
                ),
          )),
    );
  }
}
