import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:realtime_employee_app/database/bloc.dart';
import 'package:realtime_employee_app/database/models.dart';
import 'package:realtime_employee_app/utils.dart';

import '../components/choose_role_modal.dart';
import '../components/date_picker_dialog.dart';

class AddNewEmployee extends StatefulWidget {
  const AddNewEmployee({super.key});

  @override
  State<AddNewEmployee> createState() => _AddNewEmployeeState();
}

class _AddNewEmployeeState extends State<AddNewEmployee> {
  String _selectedRole = '';
  DateTime? _selectedStartDate = DateTime.now(), _selectedEndDate;
  TextEditingController _nameController = TextEditingController(text: '');
  bool _loading = true;

  Widget _selectDateField(bool isStart) => InkWell(
        onTap: () async {
          // var role = await showModalBottomSheet(context: context, builder: (context) => ChooseRoleModal());
          // if(role != null) {
          //   setState(() => _selectedRole = role);
          // }
          showDialog(
              context: context,
              builder: (x) => CustomDatePickerDialog(
                    selectedDate:
                        isStart ? _selectedStartDate! : _selectedEndDate,
                    isStartDate: isStart,
                    onSelected: (DateTime date) {
                      if (isStart) {
                        _selectedStartDate = date;
                      } else {
                        if (date != null) {
                          _selectedEndDate = date;
                        }
                      }
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ));
        },
        child: Container(
            height: 45,
            width: screenSize(context).width * 0.4,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1, color: Colors.grey)),
            child: Row(
              children: [
                Icon(
                  Icons.today_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  isStart
                      ? (_selectedStartDate!.difference(DateTime.now()).abs() <
                                  const Duration(hours: 24) &&
                              _selectedStartDate?.day == DateTime.now().day
                          ? 'Today'
                          : DateFormat('dd MMM yyyy')
                              .format(_selectedStartDate ?? DateTime.now()))
                      : (_selectedEndDate == null
                          ? 'No Date'
                          : DateFormat('dd MMM yyyy')
                              .format(_selectedEndDate!)),
                  style: TextStyle(
                      color: isStart
                          ? Colors.black
                          : (_selectedEndDate == null
                              ? Colors.grey.shade400
                              : Colors.black),
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),
                // const Spacer(),
                // Icon(Icons.arrow_drop_down_rounded, color: Theme.of(context).colorScheme.primary, size: 40,),
              ],
            )),
      );

  @override
  Widget build(BuildContext context) {
    EmployeeBloc employeeBloc = BlocProvider.of<EmployeeBloc>(context);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.75),
          title: const Text(
            'Add Employee Details',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        body: BlocListener<EmployeeBloc, EmployeeState>(
          bloc: employeeBloc,
          listener: (BuildContext context, EmployeeState state) {
            if (state is LoadingState) {
              _loading = true;
            } else if (state is SuccessState) {
              _loading = false;
              Navigator.pop(context); // user signed in, now check bills
            } else if (state is FailureState) {
              _loading = false;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  state.error,
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.redAccent,
              ));
            }
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Employee Name
                    SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person_outline_rounded,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            hintText: 'Employee name',
                            hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w400,
                                fontSize: 17),
                            contentPadding: const EdgeInsets.only(top: 5),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: Colors.grey))),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    // Select Role
                    InkWell(
                      onTap: () async {
                        var role = await showModalBottomSheet(
                            context: context,
                            builder: (context) => ChooseRoleModal());
                        if (role != null) {
                          setState(() => _selectedRole = role);
                        }
                      },
                      child: Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.work_outline_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                _selectedRole.isEmpty
                                    ? 'Select Role'
                                    : _selectedRole,
                                style: TextStyle(
                                    color: _selectedRole.isEmpty
                                        ? Colors.grey.shade400
                                        : Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_drop_down_rounded,
                                color: Theme.of(context).colorScheme.primary,
                                size: 40,
                              ),
                            ],
                          )),
                    ),
                    // Date Range Select
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _selectDateField(true),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        _selectDateField(false),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                            alignment: Alignment.center,
                            width: screenSize(context).width * 0.25,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ))),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          if (_nameController.value.text.isNotEmpty &&
                              _selectedRole.isNotEmpty) {
                                Employee _emp = Employee(employeeName: _nameController.value.text, role: _selectedRole);
                                _emp.startDate = _selectedStartDate;
                                if(_selectedEndDate != null) _emp.endDate = _selectedEndDate;
                                employeeBloc.add(AddEmployeeData(employee: _emp));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                'You must add Employee name and role to continue.',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.redAccent,
                            ));
                          }
                        },
                        child: Container(
                            alignment: Alignment.center,
                            width: screenSize(context).width * 0.25,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ))),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
