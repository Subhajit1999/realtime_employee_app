class Employee {
    String? employeeName;
    String? role;
    DateTime? startDate;
    DateTime? endDate;

    Employee({
        this.employeeName,
        this.role,
        this.startDate,
        this.endDate,
    });

    factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        employeeName: json["employee_name"],
        role: json["role"],
        startDate: json["start_date"] != null? DateTime.parse(json["start_date"]) : DateTime.now(),
        endDate: json["end_date"] != null? DateTime.parse(json["end_date"]) : DateTime.now(),
    );

    Map<String, dynamic> toJson() => {
        "employee_name": employeeName,
        "role": role,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
    };
}