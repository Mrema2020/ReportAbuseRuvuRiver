import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruvu/controllers/reports.dart';
import 'package:ruvu/screens/admin/allTime.dart';
import 'package:ruvu/screens/admin/daily.dart';
import 'package:ruvu/screens/admin/weekly.dart';
import 'package:ruvu/screens/map.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final report = Get.put(ReportsController());
  int index = 0;

  @override
  void initState() {
    report.getDailyReportCount();
    report.dailyDone();
    report.getWeeklyReportCount();
    report.weeklyDone();
    report.allReportsDone();
    report.getReports();
    print('daily reports are ${report.dailyReports}');
    print('weekly reports are ${report.weeklyReports}');
    print('all reports done ${report.reportsdone}');
    super.initState();
  }

  Widget show() {
    if (index == 0) {
      return const Daily();
    } else if(index==1) {
      return const Weekly();
    }else {
      return const AllTime();
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          show(),
          Positioned(
            bottom: 10,
            child: SizedBox(
              width: size.width - 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        index = 0;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: index == 0 ? Colors.green : Colors.grey,
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(() => Row(
                              children: [
                                const Text('Today'),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                    "${report.dailyReports.length.toString()}(${report.dailydone.length.toString()})"),
                              ],
                            )),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        index = 1;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: index == 1 ? Colors.green : Colors.grey,
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(() => Row(
                              children: [
                                const Text('This week'),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                    "${report.weeklyReports.length.toString()}(${report.weeklydone.length.toString()})"),
                              ],
                            )),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        index = 2;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: index == 2 ? Colors.green : Colors.grey,
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(() => Row(
                              children: [
                                const Text('all time'),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("${report.reports.length.toString()}(${report.reportsdone.length.toString()})"),
                              ],
                            )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
