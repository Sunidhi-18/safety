// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  
  String _name = '';
  String _phone = '';
  String _emergencyContact1 = '';
  String _emergencyContact2 = '';
  String _emergencyEmail = '';
  String _nearestPoliceStation = '';
  String _bloodGroup = '';
  String _address = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          setState(() {
            _name = data['name'] ?? '';
            _phone = data['phone'] ?? '';
            _emergencyContact1 = data['emergencyContact1'] ?? '';
            _emergencyContact2 = data['emergencyContact2'] ?? '';
            _emergencyEmail = data['emergencyEmail'] ?? '';
            _nearestPoliceStation = data['nearestPoliceStation'] ?? '';
            _bloodGroup = data['bloodGroup'] ?? '';
            _address = data['address'] ?? '';
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error loading profile data'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        final user = _auth.currentUser;
        if (user != null) {
          await _firestore.collection('users').doc(user.uid).set({
            'name': _name,
            'phone': _phone,
            'email': user.email,
            'emergencyContact1': _emergencyContact1,
            'emergencyContact2': _emergencyContact2,
            'emergencyEmail': _emergencyEmail,
            'nearestPoliceStation': _nearestPoliceStation,
            'bloodGroup': _bloodGroup,
            'address': _address,
          });

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isProfileComplete', true);

          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save profile'),
            backgroundColor: Colors.red,
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.pink[100],
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.pink,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phone = value!;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _bloodGroup,
                decoration: const InputDecoration(
                  labelText: 'Blood Group',
                  prefixIcon: Icon(Icons.bloodtype),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your blood group';
                  }
                  return null;
                },
                onSaved: (value) {
                  _bloodGroup = value!;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _address,
                decoration: const InputDecoration(
                  labelText: 'Home Address',
                  prefixIcon: Icon(Icons.home),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _address = value!;
                },
              ),
              const SizedBox(height: 30),
              const Text(
                'Emergency Contacts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _emergencyContact1,
                decoration: const InputDecoration(
                  labelText: 'Primary Emergency Contact Number',
                  prefixIcon: Icon(Icons.contact_phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a primary emergency contact';
                  }
                  return null;
                },
                onSaved: (value) {
                  _emergencyContact1 = value!;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _emergencyContact2,
                decoration: const InputDecoration(
                  labelText: 'Secondary Emergency Contact Number (Optional)',
                  prefixIcon: Icon(Icons.contact_phone),
                ),
                keyboardType: TextInputType.phone,
                onSaved: (value) {
                  _emergencyContact2 = value ?? '';
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _emergencyEmail,
                decoration: const InputDecoration(
                  labelText: 'Emergency Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an emergency email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _emergencyEmail = value!;
                },
              ),
              const SizedBox(height: 30),
              const Text(
                'Authority Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _nearestPoliceStation,
                decoration: const InputDecoration(
                  labelText: 'Nearest Police Station Contact',
                  prefixIcon: Icon(Icons.local_police),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter nearest police station contact';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nearestPoliceStation = value!;
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'SAVE PROFILE',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}