import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../models/user_model.dart';
import 'package:geolocator/geolocator.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  Future<User?> getUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return User.fromMap(doc.data() as Map<String, dynamic>, user.uid);
      }
    }
    return null;
  }

  Future<bool> sendEmergencyAlert(Position position) async {
    try {
      User? userData = await getUserData();
      if (userData == null) return false;

      // Send SMS to emergency contacts
      await _sendSMS(userData, position);
      
      // Send email alert
      await _sendEmail(userData, position);
      
      // Send alert to nearest police station
      await _alertPoliceStation(userData, position);
      
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _sendSMS(User user, Position position) async {
    // In a real application, you would use a SMS API service like Twilio, Nexmo, etc.
    // For this example, we'll simulate the SMS sending
    
    String message = "EMERGENCY: ${user.name} is in danger! Location: https://maps.google.com/?q=${position.latitude},${position.longitude}";
    
    // Send to emergency contact 1
    await http.post(
      Uri.parse('https://your-sms-api-endpoint.com/send'),
      body: {
        'to': user.emergencyContact1,
        'message': message,
      },
    );
    
    // Send to emergency contact 2
    if (user.emergencyContact2.isNotEmpty) {
      await http.post(
        Uri.parse('https://your-sms-api-endpoint.com/send'),
        body: {
          'to': user.emergencyContact2,
          'message': message,
        },
      );
    }
  }

  Future<void> _sendEmail(User user, Position position) async {
    // In a real application, use an email service like SendGrid, Mailgun, etc.
    // For this example, we'll simulate the email sending
    
    String subject = "EMERGENCY ALERT: ${user.name} needs help!";
    String body = """
      Emergency Alert!
      
      ${user.name} has triggered an emergency alert.
      
      Location: https://maps.google.com/?q=${position.latitude},${position.longitude}
      Blood Group: ${user.bloodGroup}
      Address: ${user.address}
      Phone: ${user.phone}
      
      Please take immediate action.
    """;
    
    await http.post(
      Uri.parse('https://your-email-api-endpoint.com/send'),
      body: {
        'to': user.emergencyEmail,
        'subject': subject,
        'body': body,
      },
    );
  }

  Future<void> _alertPoliceStation(User user, Position position) async {
    // In a real application, you would integrate with police emergency API
    // For this example, we'll simulate the alert
    
    String message = "EMERGENCY ALERT: Citizen in danger at https://maps.google.com/?q=${position.latitude},${position.longitude}";
    
    await http.post(
      Uri.parse('https://police-emergency-api.com/alert'),
      body: {
        'station': user.nearestPoliceStation,
        'message': message,
        'name': user.name,
        'phone': user.phone,
        'location': '${position.latitude},${position.longitude}',
      },
    );
  }
}