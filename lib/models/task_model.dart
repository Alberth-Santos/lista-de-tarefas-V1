class Task {
  Task({required this.title});

  Task.fromJson(Map<String, dynamic> json) : title = json["title"];

  String title;

  Map<String, dynamic> toJson() {
    return {
      "title": title,
    };
  }
}
