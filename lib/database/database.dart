import 'dart:convert';

import 'package:realtime_employee_app/main.dart';

import '../utils.dart';
import 'models.dart';

class EmployeeDataRepository {

  Future<List<Employee>> retrieveEmployeesData() async {
    List<Employee> employees = [];
    String? data = preferences.getString(EMPLOYEE_DATA);
    if(data!=null) {
      if(data.isNotEmpty) employees = List<Employee>.from(json.decode(data).map((x) => Employee.fromJson(x)));
    }
    return employees;
  }

  Future<dynamic> saveEmployeeData(List<Employee> employees) async {
    String prefJson = json.encode(List<dynamic>.from(employees.map((x) => x.toJson())));
    bool saved = await preferences.setString(EMPLOYEE_DATA, prefJson);
    print("Prefs Data Saved: $saved");
    return saved;
  }
}