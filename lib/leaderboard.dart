import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeaderboardEntry {
  final String userId;
  final String name;
  final int totalPoints;

  LeaderboardEntry({
    required this.userId,
    required this.name,
    required this.totalPoints,
  });
}

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  // Define a class to represent a user's leaderboard entry


// Fetch all user documents from the 'users' collection
Future<List<LeaderboardEntry>> fetchLeaderboardData() async {
  final usersRef = FirebaseFirestore.instance.collection('users');
  final querySnapshot = await usersRef.get();

  List<LeaderboardEntry> leaderboardData = [];

  for (final userDoc in querySnapshot.docs) {
    final userData = userDoc.data() as Map<String, dynamic>;
    final userId = userDoc.id;
    final name = userData['name'] as String;

    // Fetch points for the current user
    final pointsSnapshot = await FirebaseFirestore.instance
        .collection('garbageDB')
        .doc(userId)
        .collection('points')
        .get();

    int totalPoints = 0;

    for (final pointDoc in pointsSnapshot.docs) {
      final pointData = pointDoc.data() as Map<String, dynamic>;
      final point = pointData['point'] as int;
      totalPoints += point;
    }

    // Create a leaderboard entry for the current user
    final leaderboardEntry = LeaderboardEntry(
      userId: userId,
      name: name,
      totalPoints: totalPoints,
    );

    leaderboardData.add(leaderboardEntry);
  }

  // Sort the leaderboard data based on total points in descending order
  leaderboardData.sort((a, b) => b.totalPoints.compareTo(a.totalPoints));

  return leaderboardData;
}

  List<LeaderboardEntry> leaderboardData = [];

  @override
  void initState() {
    super.initState();
    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard() async {
    try {
      List<LeaderboardEntry> data = await fetchLeaderboardData();
      setState(() {
        leaderboardData = data;
      });
    } catch (error) {
      // Handle error
      print('Error fetching leaderboard data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
        backgroundColor: Color(0xFFF7CC00),
      ),
      body: ListView.builder(
        itemCount: leaderboardData.length,
        itemBuilder: (context, index) {
          final entry = leaderboardData[index];
          return ListTile(
            leading: Text('${index + 1}'),
            title: Text(entry.name),
            subtitle: Text('Total Points: ${entry.totalPoints}'),
          );
        },
      ),
    );
  }
}
