import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ReportsController extends GetxController {
  CollectionReference reportRef =
      FirebaseFirestore.instance.collection('reports');
  static ReportsController instance = Get.find();
  var reports = [].obs;
  var dailyReports = [].obs;
  var weeklyReports = [].obs;
  var complaints = [].obs;
  var dailydone = [].obs;
  var weeklydone = [].obs;
  var reportsdone = [].obs;
  var isLoading = false.obs;
  var isUpdating = false.obs;
  late FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    getReports();
    getDailyReportCount();
    dailyDone();
    weeklyDone();
    allReportsDone();
    getComplaints();
  }

  getReports() async {
    isLoading(true);
    QuerySnapshot querySnapshot = await reportRef.orderBy('date', descending: true).get();
    //QuerySnapshot querySnapshot = await reportRef.get();
    var allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    reports.value = allData;
    isLoading(false);
  }
  getComplaints() async {
    isLoading(true);
    var userId = auth.currentUser!.uid;
    QuerySnapshot querySnapshot =await reportRef.orderBy('date', descending: true).where('userId',isEqualTo: userId).get();

    var allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    complaints.value = allData;
    print('complaints are ${complaints.length}');
    isLoading(false);
  }
  allReportsDone() async {
    isLoading(true);
    var userId = auth.currentUser!.uid;
    QuerySnapshot querySnapshot =
        await reportRef
        .where('status', isEqualTo: 'done')
        //.orderBy('date', descending: true)
        .get();

    var allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    reportsdone.value = allData;
    isLoading(false);
  }

  Future<void> updateReport(Timestamp time) async {
    isUpdating(true);
    try {
      final CollectionReference collectionRef = reportRef;
      final Query query = collectionRef.where('date', isEqualTo: time);
      final QuerySnapshot snapshot = await query.get();

      snapshot.docs.forEach((doc) async {
        await doc.reference.update({
          'status': 'done',
        }).then((value) {
          isUpdating(false);
          print('doc $doc updated');
        });
      });
    } catch (error) {
      isUpdating(false);
      print(error);
    }
  }

  Future getDailyReportCount() async {
    try {
      DateTime date = DateTime.now();
      DateTime startDate = DateTime(date.year, date.month, date.day);
      DateTime endDate = DateTime(date.year, date.month, date.day + 1);

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('reports')
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThan: endDate)
          .get();
      var allData = snapshot.docs.map((doc) => doc.data()).toList();
      dailyReports.value = allData;
      print('daily reports are ${dailyReports.length}');
    } catch (error) {
      print(error);
    }
  }

  Future getWeeklyReportCount() async {
    try {
      final now = DateTime.now();
      final oneWeekAgo = now.subtract(const Duration(days: 7));
      // Convert the DateTime objects to Firestore Timestamps
      final startDate = Timestamp.fromDate(oneWeekAgo);
      final endDate = Timestamp.fromDate(now);

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('reports')
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThan: endDate)
          .get();
      var allData = snapshot.docs.map((doc) => doc.data()).toList();
      weeklyReports.value = allData;
      print('weekly reports are ${weeklyReports.length}');
    } catch (error) {
      print(error);
    }
  }

  Future dailyDone() async {
    try {
      DateTime date = DateTime.now();
      DateTime startDate = DateTime(date.year, date.month, date.day);
      DateTime endDate = DateTime(date.year, date.month, date.day + 1);

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('reports')
          .where('status', isEqualTo: 'done')
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThan: endDate)
          .get();
      var allData = snapshot.docs.map((doc) => doc.data()).toList();
      dailydone.value = allData;
      print('daily done are ${dailydone.length}');
    } catch (error) {
      print(error);
    }
  }

  Future weeklyDone() async {
    try {
      final now = DateTime.now();
      final oneWeekAgo = now.subtract(const Duration(days: 7));
      // Convert the DateTime objects to Firestore Timestamps
      final startDate = Timestamp.fromDate(oneWeekAgo);
      final endDate = Timestamp.fromDate(now);

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('reports')
          .where('status', isEqualTo: 'done')
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThan: endDate)
          .get();
      var allData = snapshot.docs.map((doc) => doc.data()).toList();
      weeklydone.value = allData;
      print('weekly done are ${weeklydone.length}');
    } catch (error) {
      print(error);
    }
  }
}
