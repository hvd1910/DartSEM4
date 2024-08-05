import 'dart:async';
import 'dart:io';
import 'package:mysql1/mysql1.dart';

class Student {
  int id;
  String name;
  String phone;

  Student(this.id, this.name, this.phone);

  @override
  String toString() {
    return "ID: $id, Name: $name, Phone: $phone";
  }
}

class StudentManager {
  List<Student> students = [];
  MySqlConnection? conn;

  Future<void> connect() async {
    final settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      // password: '',
      db: 'school',
    );
    conn = await MySqlConnection.connect(settings);
  }

  Future<void> fetchStudents() async {
    if (conn == null) {
      await connect();
    }
    var results = await conn!.query('SELECT id, name, phone FROM students');
    students = results.map((row) {
      return Student(row[0], row[1], row[2]);
    }).toList();
  }

  Future<void> addStudent(Student student) async {
    if (conn == null) {
      await connect();
    }
    var result = await conn!.query(
      'INSERT INTO students (name, phone) VALUES (?, ?)',
      [student.name, student.phone],
    );
    student.id = result.insertId!;
    students.add(student);
  }

  Future<void> updateStudent(Student student) async {
    if (conn == null) {
      await connect();
    }
    await conn!.query(
      'UPDATE students SET name = ?, phone = ? WHERE id = ?',
      [student.name, student.phone, student.id],
    );
    var index = students.indexWhere((s) => s.id == student.id);
    if (index != -1) {
      students[index] = student;
    }
  }

  Future<void> deleteStudent(int id) async {
    if (conn == null) {
      await connect();
    }
    await conn!.query('DELETE FROM students WHERE id = ?', [id]);
    students.removeWhere((s) => s.id == id);
  }
}

void main() async {
  var manager = StudentManager();
  await manager.connect();
  await manager.fetchStudents();

  while (true) {
    print('Menu:');
    print('1. Xem danh sách sinh viên');
    print('2. Thêm sinh viên');
    print('3. Sửa sinh viên');
    print('4. Xóa sinh viên');
    print('5. Thoát');
    stdout.write('Chọn một tùy chọn: ');

    var choice = stdin.readLineSync();
    switch (choice) {
      case '1':
        await manager.fetchStudents();
        print('Danh sách sinh viên:');
        manager.students.forEach(print);
        break;
      case '2':
        stdout.write('Nhập tên sinh viên: ');
        var name = stdin.readLineSync();
        stdout.write('Nhập số điện thoại sinh viên: ');
        var phone = stdin.readLineSync();
        if (name != null && phone != null) {
          var newStudent = Student(0, name, phone);
          await manager.addStudent(newStudent);
          print('Đã thêm sinh viên: $newStudent');
        }
        break;
      case '3':
        stdout.write('Nhập ID sinh viên cần sửa: ');
        var idInput = stdin.readLineSync();
        var id = int.tryParse(idInput ?? '');
        if (id != null) {
          var student = manager.students.firstWhere(
                (s) => s.id == id,
            orElse: () => Student(0, '', ''),
          );
          if (student.id != 0) {
            stdout.write('Nhập tên mới cho sinh viên: ');
            var name = stdin.readLineSync();
            stdout.write('Nhập số điện thoại mới cho sinh viên: ');
            var phone = stdin.readLineSync();
            if (name != null && phone != null) {
              student.name = name;
              student.phone = phone;
              await manager.updateStudent(student);
              print('Đã cập nhật sinh viên: $student');
            }
          } else {
            print('Không tìm thấy sinh viên với ID: $id');
          }
        }
        break;
      case '4':
        stdout.write('Nhập ID sinh viên cần xóa: ');
        var idInput = stdin.readLineSync();
        var id = int.tryParse(idInput ?? '');
        if (id != null) {
          await manager.deleteStudent(id);
          print('Đã xóa sinh viên với ID: $id');
        }
        break;
      case '5':
        print('Thoát chương trình');
        exit(0);
      default:
        print('Lựa chọn không hợp lệ. Vui lòng chọn lại.');
    }
  }
}
