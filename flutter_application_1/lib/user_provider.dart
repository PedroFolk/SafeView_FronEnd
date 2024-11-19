import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  String? email;
  String? senha;

  void setUser(String email, String senha) {
    this.email = email;
    this.senha = senha;
    notifyListeners();
  }
}
