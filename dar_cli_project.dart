// ---------------- Abstract class ----------------
abstract class Person {
  String name;
  DateTime dob;

  Person(this.name, this.dob);

  int getAge() {
    try {
      if (dob.isAfter(DateTime.now())) {
        throw Exception('Date of birth cannot be in the future.');
      }
      return DateTime.now().year - dob.year;
    } catch (e) {
      print('Error: ${e.toString()}');
      return 0;
    }
    
  }

  void showInfo();
}

// ---------------- Inheritance: Employee extends Person ----------------
class Employee extends Person {
  int id;
  String cardNum;
  DateTime joiningDate;

  Employee(this.id, String name, this.cardNum, DateTime dob, this.joiningDate)
      : super(name, dob);

  int getServiceYears() {
    return DateTime.now().year - joiningDate.year;
  }

  @override
  void showInfo() {
    print('ID: $id, Name: $name, Card: $cardNum, '
        'Age: ${getAge()}, Service: ${getServiceYears()} yrs');
  }
}

// ---------------- Inheritance: Manager extends Employee ----------------
class Manager extends Employee {
  String department;

  Manager(int id, String name, String cardNum, DateTime dob,
      DateTime joiningDate, this.department)
      : super(id, name, cardNum, dob, joiningDate);

  @override
  void showInfo() {
    super.showInfo(); // first run Employee's showInfo
    print('   -> Manager of $department department');
  }
}

// ---------------- Abstract class for records ----------------
abstract class BaseRecord {
  DateTime date;

  BaseRecord(this.date);

  String getDateText() {
    return date.toString().substring(0, 10); // "2026-11-01"
  }

  void showInfo();
}

// ---------------- Attendance extends BaseRecord ----------------
class Attendance extends BaseRecord {
  int empId;
  String status; // P = Present, A = Absent, L = Late

  Attendance(DateTime date, this.empId, this.status) : super(date);

  @override
  void showInfo() {
    print('Date: ${getDateText()}, EmpId: $empId, Status: $status');
  }
}

// ---------------- Lists ----------------
List<Employee> employees = []; 
List<Attendance> attendances = [];

// ---------------- Async methods ----------------

// Add employee (waits 1 second, like saving to a database)
Future<void> addEmployee(Employee emp) async {
  await Future.delayed(Duration(seconds: 1));
  employees.add(emp);
  print('Employee added: ${emp.name}');
}

// Mark attendance
Future<void> markAttendance(Attendance att) async {
  await Future.delayed(Duration(milliseconds: 500));
  attendances.add(att);
  print('Attendance saved for EmpId ${att.empId}: ${att.status}');
}

// Get all employees
Future<List<Employee>> getEmployees() async {
  await Future.delayed(Duration(seconds: 1));
  return employees;
}

// Get attendance of one employee
Future<List<Attendance>> getAttendanceByEmp(int empId) async {
  await Future.delayed(Duration(milliseconds: 500));
  return attendances.where((a) => a.empId == empId).toList();
}

// Count present days
Future<int> countPresent(int empId) async {
  List<Attendance> list = await getAttendanceByEmp(empId);
  int count = 0;
  for (var a in list) {
    if (a.status == 'P') {
      count++;
    }
  }
  return count;
}

// ---------------- main ----------------
Future<void> main() async {
  print('=== Add Employees ===');
  await addEmployee(Employee(1, 'Rahim', 'C001', DateTime(1989, 1, 4), DateTime(2018, 10, 1)));
  await addEmployee(Employee(2, 'Karim', 'C002', DateTime(1998, 8, 20), DateTime(2022, 3, 15)));
  await addEmployee(Manager(3, 'Salma', 'M001', DateTime(1988, 2, 5), DateTime(2015, 6, 1), 'Production'));

  // Person p = Person('Test', DateTime(2000)); // ERROR: abstract class can't be created

  print('\n=== Mark Attendance ===');
  await markAttendance(Attendance(DateTime(2026, 11, 1), 1, 'P'));
  await markAttendance(Attendance(DateTime(2026, 11, 2), 1, 'P'));
  await markAttendance(Attendance(DateTime(2026, 11, 3), 1, 'A'));
  await markAttendance(Attendance(DateTime(2026, 11, 1), 2, 'L'));
  await markAttendance(Attendance(DateTime(2026, 11, 2), 2, 'P'));
  await markAttendance(Attendance(DateTime(2026, 11, 1), 3, 'P'));

  print('\n=== Employee List ===');
  List<Employee> list = await getEmployees();
  for (var emp in list) {
    emp.showInfo();
  }

  print('\n=== Attendance of Rahim (EmpId 1) ===');
  List<Attendance> rahimAtt = await getAttendanceByEmp(1);
  for (var a in rahimAtt) {
    a.showInfo();
  }

  print('\n=== Present Days ===');
  for (var emp in list) {
    int present = await countPresent(emp.id);
    print('${emp.name}: $present day(s) present');
  }

  print('\n=== Check type ===');
  for (var emp in list) {
    if (emp is Manager) {
      print('${emp.name} is a Manager (${emp.department})');
    } else {
      print('${emp.name} is an Employee');
    }
  }

  print('\nDone!');
}