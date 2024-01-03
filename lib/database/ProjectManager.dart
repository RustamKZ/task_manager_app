import 'package:flutter/foundation.dart';
import 'package:task_manager_app/models/Entry.dart';
import 'package:task_manager_app/models/Human.dart';
import 'package:task_manager_app/models/Project.dart';

class ProjectManager {
  List<Project> _projects = [];

  List<Project> get projects => _projects;


  void addProject(Project project) {
    _projects.add(project);
  }

  void removeProject(String projectId) {
    _projects.removeWhere((project) => project.id == projectId);

    // Update humans in each project
    for (Project project in _projects) {
      project.humans?.forEach((human) {
        if (human.projects != null && human.projects! > 0) {
          human.projects = human.projects! - 1;
        }
      });
    }

    // Remove humans with 0 projects
    _projects.forEach((project) {
      project.humans?.removeWhere((human) => human.projects == 0);
    });
  }

  void editProject(String projectId, Project editedProject) {
    // Изменение типа параметра на String
    int index = _projects.indexWhere((project) => project.id == projectId);
    if (index != -1) {
      _projects[index] = editedProject;
    }
  }

  void updateProject(Project updatedProject) {
    int index =
        _projects.indexWhere((project) => project.id == updatedProject.id);
    if (index != -1) {
      _projects[index] = updatedProject;
    }
  }

  void addHumanToProject(String projectId, Human human) {
    int index = _projects.indexWhere((project) => project.id == projectId);
    if (index != -1) {
      _projects[index].humans ??= [];
      _projects[index].humans!.add(human);
      _projects[index].updateHumans(_projects[index].humans);

      human.projects = (_projects[index].humans?.length) ?? 0;
    }
  }

  List<Human>? getProjectHumans(String projectId) {
    Project? project = _projects.firstWhere((p) => p.id == projectId,
        orElse: () => Project(id: "", name: ""));
    return project?.humans;
  }

  void setProjects(List<Project> updatedProjects) {
    _projects = updatedProjects;
  }

  void calculateProjectCost(String projectId) {
  int index = _projects.indexWhere((project) => project.id == projectId);
  if (index != -1) {
    Project project = _projects[index];
    int totalCost = project.cost ?? 0; // Используем текущее значение cost

    project.humans?.forEach((human) {
      totalCost += (human.salary ?? 0) * (project.duration ?? 0);
    });

    _projects[index] = Project(
      id: project.id,
      name: project.name,
      duration: project.duration,
      description: project.description,
      priority: project.priority,
      status: project.status,
      humans: project.humans,
      cost: project.cost,
      cost_with_humans:totalCost
    );
  }
}


  void removeHumanFromProject(String projectId, Human human) {
    int index = _projects.indexWhere((project) => project.id == projectId);
    if (index != -1) {
      _projects[index].humans?.removeWhere((h) => h.id == human.id);
      calculateProjectCost(projectId);
    }
  }

}
