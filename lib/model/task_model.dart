class TaskModel {
  final int? id;
  final String? taskName;
  final String? uuid;
  final String? description;
  final int? isCompleted;
  final String? priority;
  final int? dueDate;
  final int? createdAt;

  TaskModel({
    this.id,
    this.taskName,
    this.uuid,
    this.isCompleted,
    this.description,
    this.priority,
    this.dueDate,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) "id": id,
      "uuid": uuid,
      "taskName": taskName,
      "description": description,
      "isCompleted": isCompleted ?? 0,
      "priority": priority,
      "dueDate": dueDate,
      "createdAt": createdAt ?? DateTime.now().millisecondsSinceEpoch,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      uuid: map['uuid'],
      taskName: map["taskName"],
      isCompleted: map["isCompleted"],
      description: map["description"],
      priority: map["priority"],
      dueDate: map["dueDate"],
      createdAt: map["createdAt"],
    );
  }
}
