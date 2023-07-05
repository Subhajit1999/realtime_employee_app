import 'package:flutter/material.dart';

import 'database/models.dart';

const String NO_RECORD = "assets/images/no_record.png";

Size screenSize(context) => MediaQuery.of(context).size;

const String EMPLOYEE_DATA = "EMPLOYEE_DATA";

List<Employee> employees = [];