import 'package:flutter/material.dart';
import '../services/api_service.dart';

class StudentDashboard extends StatefulWidget {
  final String token;

  const StudentDashboard({super.key, required this.token});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}


class _StudentDashboardState extends State<StudentDashboard> {
  String username = '';
  String registrationNumber = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStudentInfo();
  }

  Future<void> fetchStudentInfo() async {
    try {
      final result = await ApiService.getStudentDashboard(widget.token);

      setState(() {
        username = result['username'];
        registrationNumber = result['registration_number'];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching data: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Dashboard")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome, $username",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("Reg No: $registrationNumber", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 30),
                  Card(
                    child: ListTile(
                      title: const Text("Project Topic"),
                      subtitle: const Text("You haven’t submitted a topic yet."),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.pushNamed(context, '/submit_topic');
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
