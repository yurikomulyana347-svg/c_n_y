// lib/models/event_model.dart

class Event {
  final int id;
  final String name;
  final String description;
  final String date;
  final String time;
  final String location;
  final String category;
  final int maxParticipants;
  final int currentParticipants;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.category,
    required this.maxParticipants,
    required this.currentParticipants,
  });


  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'] ?? 'No Name',
      description: json['description'] ?? 'No Description',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      location: json['location'] ?? 'No Location',
      category: json['category'] ?? 'Uncategorized',
      maxParticipants: json['max_participants'] ?? 0,
      currentParticipants: json['current_participants'] ?? 0,
    );
  }
}