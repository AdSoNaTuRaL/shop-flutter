class FirebaseException implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'Esse e-mail já está em uso',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida',
    'TOO_MANY_ATTEMPTS_TRY_LATER': 'Muitas tentativas, tente novamente mais tarde',
    'EMAIL_NOT_FOUND': 'E-mail e/ou senha inválidos',
    'INVALID_PASSWORD': 'E-mail e/ou senha inválidos',
    'USER_DISABLED': 'Usuário desativado',
  };

  final String key;

  const FirebaseException(this.key);

  @override
  String toString() {
    if (errors.containsKey(key)) {
      return errors[key];
    } else {
      return 'Ocorreu um erro na autenticação';
    }
  }
}