import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_employee_app/database/database.dart';
import 'package:realtime_employee_app/utils.dart';

import 'models.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeDataRepository? repository;

  EmployeeBloc({required this.repository}) : super(InitialState());

  @override
  void onTransition(Transition<EmployeeEvent, EmployeeState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  @override
  Stream<EmployeeState> mapEventToState(EmployeeEvent event) async*{
    dynamic result;

    if(event is GetEmployeesData) {
      yield LoadingState();
      result = await repository!.retrieveEmployeesData();
      if(result != null) {
        employees = List.from(result);
        if(employees.isNotEmpty) {
          yield SuccessState(employees);
        }else {
          yield FailureState("No data found.");
        }
      }else {
        yield FailureState("No data found.");
      }
    } else if(event is AddEmployeeData) {
      yield LoadingState();
      employees.add(event.employee);
      yield SuccessState(employees);
      
    }else if(event is EditEmployeeData) {  //Sign In with Google
      yield LoadingState();
      try{
        int index = employees.indexWhere((element) => element.employeeName!.toLowerCase() == event.oldData.employeeName!.toLowerCase());
        employees[index] = event.newData;
        await repository?.saveEmployeeData(employees);
        yield SuccessState(employees);
      }catch(error) {
        print('Error: $error');
        yield FailureState("Error updating employee details.");
      }

    }else if(event is RemoveEmployeeData) {  // Logout user account
      try{
        employees.removeWhere((element) => element.employeeName!.toLowerCase() == event.employee.employeeName!.toLowerCase());
        await repository?.saveEmployeeData(employees);
        yield SuccessState(employees);
      }catch(error) {
        yield FailureState('Error removing employee details.');
    }
    }
  }
}

////////////////// BLOC EVENTS ////////////////

abstract class EmployeeEvent {
  EmployeeEvent([List props = const []]);
}

class GetEmployeesData extends EmployeeEvent {

  @override
  List<Object> get props => [];

  @override
  String toString() => 'GetEmployeesData';
}

class AddEmployeeData extends EmployeeEvent {
  final Employee employee;
  AddEmployeeData({required this.employee});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'AddEmployeeData';
}

class EditEmployeeData extends EmployeeEvent {
  final Employee oldData, newData;
  EditEmployeeData({required this.oldData, required this.newData});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'EditEmployeeData';
}

class RemoveEmployeeData extends EmployeeEvent {
  final Employee employee;
  RemoveEmployeeData({required this.employee});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'RemoveEmployeeData';
}

////////////////// BLOC STATES ////////////////

abstract class EmployeeState {
  EmployeeState([List props = const []]);
}

class InitialState extends EmployeeState {

  @override
  String toString() => 'InitialState';

  @override
  List<Object> get props => [];
}

class LoadingState extends EmployeeState {

  @override
  String toString() => 'LoadingState';

  @override
  List<Object> get props => [];
}

class SuccessState extends EmployeeState {
  final List<Employee> employees;
  SuccessState(this.employees);

  @override
  String toString() => 'SuccessState';

  @override
  List<Object> get props => [employees];
}

class FailureState extends EmployeeState {
  final String error;
  FailureState(this.error);

  @override
  String toString() => 'FailureState';

  @override
  List<Object> get props => [error];
}