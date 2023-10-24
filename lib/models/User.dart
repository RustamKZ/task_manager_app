class User
{
  int id;
  String username;
  String email;
  String password;

  // Конструктор класса User
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  // Создаем фабричный конструктор для удобного создания объекта User из JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
    );
  }

  // Метод для преобразования объекта User в JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'password': password,
      };
}