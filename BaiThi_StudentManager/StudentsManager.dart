
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;



class Subject {
  String name;
  List<int> score;

  Subject({required this.name, required this.score});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json['name'],
      score: List<int>.from(json['score']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'score': score,
    };
  }

  @override
  String toString() {
    return 'Subject{name: $name, score: $score}';
  }
}


class Student {
  int id;
  String name;
  List<Subject> subjects;

  Student({required this.id, required this.name, required this.subjects});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      subjects: (json['subjects'] as List)
          .map((subjectJson) => Subject.fromJson(subjectJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subjects': subjects.map((subject) => subject.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Student{id: $id, name: $name, subjects: $subjects}';
  }
}

void main() async {
  // Định nghĩa thông tin file json
  const String fileName = 'students.json';
  final String directoryPath = p.join(Directory.current.path, 'dataStudents');
  final Directory directory = Directory(directoryPath);

  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }
  final String filePath = p.join(directoryPath, fileName);
  List<Student> studentList = await loadStudents(filePath);

  while (true) {
    print('''
        Menu:
        1. Thêm sinh viên 
        2. Hiển thị thông tin sinh viên 
        3. Sửa thông tin sinh viên
        4. Tìm kiếm sinh viên theo tên hoặc ID
        5. Hiển thị sinh viên có điểm thi môn cao nhất
        6. Thoát 
        Mời bạn chọn:
        ''');
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        await addStudent(filePath, studentList);
        break;
      case '2':
        displayStudent(studentList);
        break;
      case '3':
        await editStudent(filePath, studentList);
        break;
      case '4':
        await searchStudent(filePath, studentList);
        break;
      case '5':
        await displayTopScorers(filePath, studentList);
        break;
      case '6':
        print('Thoát chương trình');
        exit(0);
      default:
        print('Vui lòng chọn lại!');
    }
  }
}


Future<List<Student>> loadStudents(String filePath) async {
  File file = File(filePath);
  if (!file.existsSync()) {
    await file.create();
    await file.writeAsString(jsonEncode([]));
    return [];
  }

  // Đọc nội dung tệp
  String content = await file.readAsString();
  if (content.isEmpty) {
    return [];
  }

  try {
    List<dynamic> jsonData = jsonDecode(content);
    return jsonData.map((json) => Student.fromJson(json)).toList();
  } catch (e) {
    print("Lỗi khi giải mã JSON: $e");
    return [];
  }
}


Future<void> addStudent(String filePath, List<Student> studentList) async {
  print('Nhập tên sinh viên: ');
  String? name = stdin.readLineSync();
  if (name == null || name.isEmpty) {
    print('Tên không hợp lệ');
    return;
  }

  List<Subject> subjects = [];

  while (true) {
    print('Nhập tên môn học: ');
    String? subjectName = stdin.readLineSync();
    if (subjectName == null || subjectName.isEmpty) {
      print('Tên môn học không hợp lệ');
      return;
    }

    print('Nhập điểm môn học (cách nhau bằng dấu phẩy, ví dụ: 0,2,5): ');
    String? scoreInput = stdin.readLineSync();
    if (scoreInput == null || scoreInput.isEmpty) {
      print('Điểm không hợp lệ');
      return;
    }

    List<int> scores = scoreInput.split(',').map((s) => int.tryParse(s) ?? 0).toList();
    Subject subject = Subject(name: subjectName, score: scores);
    subjects.add(subject);

    print('Bạn có muốn thêm môn học khác không? (y/n): ');
    String? continueInput = stdin.readLineSync();
    if (continueInput == null || continueInput.toLowerCase() != 'y') {
      break;
    }
  }

  int newId = studentList.isEmpty ? 1 : studentList.last.id + 1;
  Student newStudent = Student(id: newId, name: name, subjects: subjects);

  // Thêm đối tượng Student vào danh sách
  studentList.add(newStudent);

  // Ghi danh sách Student trở lại vào file
  String jsonContent = jsonEncode(studentList.map((student) => student.toJson()).toList());
  await File(filePath).writeAsString(jsonContent);

  print('Sinh viên đã được thêm thành công.');
}



Future<void> editStudent(String filePath, List<Student> studentList) async {

  // Nhập ID sinh viên
  print('Nhập ID sinh viên cần chỉnh sửa:');
  String? idInput = stdin.readLineSync();
  int? studentId = int.tryParse(idInput ?? '');


  // Tìm sinh viên với ID tương ứng
  Student? student;
  for (var s in studentList) {
    if (s.id == studentId) {
      student = s;
      break;
    }
  }

  if (student == null) {
    print('Không tìm thấy sinh viên với ID: $studentId');
    return;
  }

  // Cho phép người dùng chỉnh sửa tên sinh viên
  print('Tên hiện tại: ${student.name}');
  print('Nhập tên mới (nhấn Enter để giữ nguyên):');
  String? newName = stdin.readLineSync();
  if (newName != null && newName.isNotEmpty) {
    student.name = newName;
  }

  // Menu quản lý môn học
  while (true) {
    print('Quản lý môn học cho sinh viên ${student.name}:');
    print('1. Thêm môn học');
    print('2. Sửa môn học');
    print('3. Xóa môn học');
    print('4. Thoát');
    print('Chọn thao tác:');
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1': // Thêm môn học
        print('Nhập tên môn học:');
        String? subjectName = stdin.readLineSync();
        if (subjectName != null && subjectName.isNotEmpty) {
          print('Nhập điểm môn học (cách nhau bằng dấu phẩy, ví dụ: 0,2,5):');
          String? scoreInput = stdin.readLineSync();
          if (scoreInput != null && scoreInput.isNotEmpty) {
            List<int> scores = scoreInput.split(',').map((s) => int.tryParse(s) ?? 0).toList();
            student.subjects.add(Subject(name: subjectName, score: scores));
            print('Đã thêm môn học.');
          }
        }
        break;
      case '2': // Sửa môn học
        print('Nhập tên môn học cần sửa:');
        String? subjectNameToEdit = stdin.readLineSync();
        Subject? subjectToEdit;
        for (var subject in student.subjects) {
          if (subject.name == subjectNameToEdit) {
            subjectToEdit = subject;
            break;
          }
        }
        if (subjectToEdit != null) {
          print('Tên môn hiện tại: ${subjectToEdit.name}');
          print('Nhập tên mới (nhấn Enter để giữ nguyên):');
          String? newSubjectName = stdin.readLineSync();
          if (newSubjectName != null && newSubjectName.isNotEmpty) {
            subjectToEdit.name = newSubjectName;
          }
          print('Điểm hiện tại: ${subjectToEdit.score.join(', ')}');
          print('Nhập điểm mới (nhấn Enter để giữ nguyên):');
          String? newScoreInput = stdin.readLineSync();
          if (newScoreInput != null && newScoreInput.isNotEmpty) {
            subjectToEdit.score = newScoreInput.split(',').map((s) => int.tryParse(s) ?? 0).toList();
          }
          print('Đã cập nhật môn học.');
        } else {
          print('Không tìm thấy môn học với tên: $subjectNameToEdit');
        }
        break;
      case '3': // Xóa môn học
        print('Nhập tên môn học cần xóa:');
        String? subjectNameToDelete = stdin.readLineSync();
        student.subjects.removeWhere((subject) => subject.name == subjectNameToDelete);
        print('Đã xóa môn học.');
        break;
      case '4': // Thoát
        print('Hoàn tất chỉnh sửa.');
        break;
      default:
        print('Lựa chọn không hợp lệ.');
    }

    // Thoát nếu người dùng chọn "Thoát"
    if (choice == '4') {
      break;
    }
  }

  // Cập nhật danh sách sinh viên vào tệp
  String jsonContent = jsonEncode(studentList.map((student) => student.toJson()).toList());
  await File(filePath).writeAsString(jsonContent);
  print('Đã lưu thay đổi vào tệp.');
}



Future<void> searchStudent(String filePath, List<Student> studentList ) async {

  // Nhập tiêu chí tìm kiếm
  print('Nhập tên hoặc ID sinh viên cần tìm:');
  String? input = stdin.readLineSync();

  if (input == null || input.isEmpty) {
    print('Tiêu chí tìm kiếm không hợp lệ.');
    return;
  }

  // Tìm kiếm theo ID (nếu là số) hoặc tên
  Student? student;
  int? id = int.tryParse(input);

  if (id != null) {
    // Tìm theo ID
    for (var s in studentList) {
      if (s.id == id) {
        student = s;
        break;
      }
    }
  } else {
    // Tìm theo tên
    for (var s in studentList) {
      if (s.name.toLowerCase() == input.toLowerCase()) {
        student = s;
        break;
      }
    }
  }

  // Hiển thị kết quả tìm kiếm
  if (student != null) {
    print('Thông tin sinh viên:');
    print('ID: ${student.id}');
    print('Tên: ${student.name}');
    print('Môn học:');
    for (var subject in student.subjects) {
      print('  - Tên môn học: ${subject.name}');
      print('    Điểm: ${subject.score.join(', ')}');
    }
  } else {
    print('Không tìm thấy sinh viên với tiêu chí: $input');
  }
}



Future<void> displayTopScorers(String filePath,  List<Student> studentList) async {
  print('Nhập tên môn thi cần tìm điểm cao nhất:');
  String? subjectName = stdin.readLineSync();

  if (subjectName == null || subjectName.isEmpty) {
    print('Tên môn thi không hợp lệ.');
    return;
  }

  // Xác định điểm cao nhất cho môn thi
  int highestScore = -1;
  for (var student in studentList) {
    for (var subject in student.subjects) {
      if (subject.name.toLowerCase() == subjectName.toLowerCase()) {
        int maxScore = subject.score.isEmpty ? -1 : subject.score.reduce((a, b) => a > b ? a : b);
        if (maxScore > highestScore) {
          highestScore = maxScore;
        }
      }
    }
  }
  if (highestScore == -1) {
    print('Không tìm thấy môn thi hoặc chưa có điểm cho môn thi này.');
    return;
  }

  print('Danh sách sinh viên có điểm cao nhất ($highestScore) trong môn $subjectName:');
  bool found = false;
  for (var student in studentList) {
    for (var subject in student.subjects) {
      if (subject.name.toLowerCase() == subjectName.toLowerCase() && subject.score.contains(highestScore)) {
        print('ID: ${student.id}');
        print('Tên: ${student.name}');
        print('Điểm môn học: ${highestScore}');
        print('----------------------------');
        found = true;
        break;
      }
    }
  }

  if (!found) {
    print('Không có sinh viên nào có điểm cao nhất trong môn học $subjectName.');
  }
}



void displayStudent(List<Student> studentList) {
  if (studentList.isEmpty) {
    print('Danh sách sinh viên trống');
  } else {
    print('Danh sách sinh viên:');
    for (var student in studentList) {
      print('ID: ${student.id}');
      print('Tên: ${student.name}');
      print('Môn học và điểm:');

      for (var subject in student.subjects) {
        print(' - Môn: ${subject.name}, Điểm: ${subject.score.join(', ')}');
      }
      print('----------------------------');
    }
  }
}

