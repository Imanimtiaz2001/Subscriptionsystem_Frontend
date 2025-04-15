import 'package:flutter/material.dart';
import 'auth_provider.dart';

class AdminPage extends StatefulWidget {
  final String accessToken;
  const AdminPage({super.key, required this.accessToken});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<dynamic> expiredSubscriptions = [];
  bool _isLoading = true;
  final AuthProvider authProvider = AuthProvider();  // Initialize AuthProvider

  @override
  void initState() {
    super.initState();
    fetchExpiredSubscriptions();
  }

  // Fetch expired subscriptions from AuthProvider
  Future<void> fetchExpiredSubscriptions() async {
    try {
      final expiredSubs = await authProvider.fetchExpiredSubscriptions(widget.accessToken); // Call function from AuthProvider
      setState(() {
        expiredSubscriptions = expiredSubs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: expiredSubscriptions.length,
        itemBuilder: (context, index) {
          final subscription = expiredSubscriptions[index];
          return ListTile(
            title: Text(subscription['email']),
            subtitle: Text('Plan: ${subscription['plan']}, End Date: ${subscription['end_date']}'),
            trailing: Text(subscription['is_active'] ? 'Active' : 'Expired'),
          );
        },
      ),
    );
  }
}
