import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/api_requests.dart';
import 'package:flutter_application_1/user_provider.dart';
import 'package:provider/provider.dart';

class GerenciaUsuarios extends StatefulWidget {
  const GerenciaUsuarios({super.key});

  @override
  State<GerenciaUsuarios> createState() => _GerenciaUsuariosState();
}

class _GerenciaUsuariosState extends State<GerenciaUsuarios> {
  final ApiService apiService = ApiService();
  late Future<List<Map<String, dynamic>>> _futureUsers;
  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _filteredUsers = [];
  bool _isListVisible = true;

  @override
  void initState() {
    super.initState();
    _futureUsers = apiService.getAllUsers();
    _futureUsers.then((users) {
      setState(() {
        _allUsers = users;
        _filteredUsers = users;
      });
    });
  }

  void filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredUsers = _allUsers;
      } else {
        _filteredUsers = _allUsers
            .where((user) =>
                (user['Nome'] ?? '')
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                (user['Email'] ?? '')
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void toggleListVisibility() {
    setState(() {
      _isListVisible = !_isListVisible;
    });
  }

  void deleteUserFromApi(
      String emailUsuarioApagando, String emailUsuarioAApagar) async {
    final result =
        await apiService.deleteUser(emailUsuarioApagando, emailUsuarioAApagar);

    if (result['error'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Erro ao apagar usuário')),
      );
    } else {
      setState(() {
        _allUsers.removeWhere((user) => user['Email'] == emailUsuarioAApagar);
        _filteredUsers
            .removeWhere((user) => user['Email'] == emailUsuarioAApagar);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Usuário $emailUsuarioAApagar apagado com sucesso')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String? email = Provider.of<UserProvider>(context).email;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            Icon(Icons.people, color: Colors.white),
            SizedBox(width: 8),
            Text('Gerência de Usuários'),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              onChanged: filterUsers,
              decoration: InputDecoration(
                labelText: 'Pesquisar',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _isListVisible
                  ? FutureBuilder<List<Map<String, dynamic>>>(
                      future: _futureUsers,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text(
                                  'Erro ao carregar usuários: ${snapshot.error}'));
                        } else if (_filteredUsers.isEmpty) {
                          return const Center(
                              child: Text('Nenhum usuário encontrado.'));
                        }

                        return ListView.builder(
                          itemCount: _filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = _filteredUsers[index];
                            return Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.person,
                                    color: Colors.blue),
                                title: Text(
                                  user['Nome'] ?? 'Sem nome',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user['Email'] ?? 'Sem email'),
                                    Text(user['Cargo'] ?? 'Sem cargo'),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    // Mostra um diálogo de confirmação antes de excluir
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Excluir Usuário'),
                                          content: Text(
                                              'Tem certeza que deseja excluir o usuário "${user['Nome']}"?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                deleteUserFromApi(
                                                  email!, // Substitua pelo email do usuário logado
                                                  user['Email'],
                                                );
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Excluir'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'Pressione "Mostrar" para exibir a lista de usuários',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
