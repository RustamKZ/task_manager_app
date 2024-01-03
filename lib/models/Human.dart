enum Position {projectManager, developer, designer, tester, marketer}

class Human {
  String id;
  String name;
  Position ? position;
  int? _projects;
  int? salary;

  Human({
    required this.id,
    required this.name,
    this.position,
    int? projects,
    this.salary,
  }): _projects = projects;
  int? get projects => _projects;

  set projects(int? value) {
    _projects = value;
  }
}
