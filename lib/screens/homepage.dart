import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:realtime_employee_app/screens/add_employee.dart';
import 'package:realtime_employee_app/utils.dart';

import '../database/bloc.dart';
import '../database/models.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late EmployeeBloc employeeBloc;

  @override
  void initState() {
    super.initState();
    employeeBloc = BlocProvider.of<EmployeeBloc>(context);
    employeeBloc.add(GetEmployeesData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).colorScheme.primary.withOpacity(0.75),
        title: const Text(
          'Employee List',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            Theme.of(context).colorScheme.primary.withOpacity(0.75),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const AddNewEmployee(),
                fullscreenDialog: true)),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 35,
        ),
      ),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        bloc: employeeBloc,
        builder: (BuildContext context, EmployeeState state) {
          if (state is LoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SuccessState) {
            List<Employee> _current = state.employees
                .where((element) => element.endDate == null)
                .toList();
            List<Employee> _previous = state.employees
                .where((element) => element.endDate != null)
                .toList();

            return BlocListener<EmployeeBloc, EmployeeState>(
              bloc: employeeBloc,
              listener: (BuildContext context, EmployeeState state) {
                if (state is SuccessState) {
                } else if (state is FailureState) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      state.error,
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.redAccent,
                  ));
                }
              },
              child: Container(
                color: Colors.grey.shade300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Current Employees',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                          children: List.generate(
                              _current.length,
                              (index) => Slidable(
                                    endActionPane: ActionPane(
                                      motion: ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (BuildContext context) {
                                            employeeBloc.add(RemoveEmployeeData(employee: _current[index]));
                                          },
                                          backgroundColor: Colors.redAccent,
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          label: 'Delete',
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        _current[index].employeeName ?? '',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 19),
                                      ),
                                      subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _current[index].role ?? '',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              "From ${DateFormat('dd MMM yyyy').format(_current[index].startDate ?? DateTime.now())}",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14),
                                            ),
                                          ]),
                                    ),
                                  ))),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Previous Employees',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                          children: List.generate(
                              _previous.length,
                              (index) => Slidable(
                                    endActionPane: ActionPane(
                                      motion: ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (BuildContext context) {
                                            employeeBloc.add(RemoveEmployeeData(employee: _previous[index]));
                                          },
                                          backgroundColor: Colors.redAccent,
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          label: 'Delete',
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        _previous[index].employeeName ?? '',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 19),
                                      ),
                                      subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _previous[index].role ?? '',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              "${DateFormat('dd MMM yyyy').format(_previous[index].startDate ?? DateTime.now())} - ${DateFormat('dd MMM yyyy').format(_previous[index].endDate ?? DateTime.now())}",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14),
                                            ),
                                          ]),
                                    ),
                                  ))),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is FailureState) {
            return Center(
              child: Image.asset(
                NO_RECORD,
                scale: 3,
              ),
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
