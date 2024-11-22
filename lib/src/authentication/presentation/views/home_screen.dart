import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_tutorial/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:tdd_tutorial/src/authentication/presentation/views/widgets/add_user_dialog.dart';
import 'package:tdd_tutorial/src/authentication/presentation/views/widgets/loading_column.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void getUsers() {
    context.read<AuthenticationCubit>().getUsers();
  }

  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getUsers();
  }

  @override
  void dispose() {
    super.dispose();

    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        } else if (state is UserCreatedState) {
          getUsers();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: state is GettingUsersState
              ? const LoadingColumn(message: 'Getting Users')
              : state is CreatingUserState
                  ? const LoadingColumn(message: 'Creating User')
                  : state is UsersLoadedState
                      ? RefreshIndicator(
                        onRefresh: () async {
                          getUsers();
                        },
                        child: Center(
                          child: ListView.builder(
                            itemCount: state.users.length,
                            itemBuilder: (context, index) {
                              final user = state.users[index];
                        
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(user.avatar),
                                ),
                                title: Text(user.name),
                                subtitle: Text(user.createdAt.toString()),
                              );
                            },
                          )
                        ),
                      )
                      : const SizedBox.shrink(),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              nameController.text = '';
              
              await showDialog(
                context: context,
                builder: (context) => AddUserDialog(
                  nameController: nameController,
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add User'),
          ),
        );
      },
    );
  }
}
