// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/event_model.dart';
import '../services/api_service.dart';
import 'auth_screen.dart';
import 'create_event_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Event>> _eventsFuture;

  @override
  void initState() {
    super.initState();

    _loadEvents();
  }


  void _loadEvents() {
    setState(() {
      _eventsFuture = _apiService.getEvents().then((events) =>
          events.map((event) => Event.fromJson(event)).toList());
    });
  }


  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); //


    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AuthScreen()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event List"),
        actions: [

          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),

      body: FutureBuilder<List<Event>>(
        future: _eventsFuture,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          /
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No events found."));
          }

          final events = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async => _loadEvents(),
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(event.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${event.location}\n${event.date} at ${event.time}"),
                    isThreeLine: true,

                  ),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {

          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => CreateEventScreen()),
          ).then((_) {

            _loadEvents();
          });
        },
        tooltip: 'Create Event',
        child: const Icon(Icons.add),
      ),
    );
  }
}