import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  String? email;
  
  void setUser(String email) {
    this.email = email;
    
    notifyListeners();
  }
}
