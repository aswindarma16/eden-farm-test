import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../globals.dart';
import '../pages/login_page.dart';
import '../pages/main_menu.dart';

// Authentication Event ========================================================= START
class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
  
  @override
  List<Object?> get props => [];
}

class LogIn extends AuthenticationEvent {
  final bool mounted;
  final BuildContext pageContext;
  final String emailAddress, password;
  
  const LogIn({
    required this.mounted,
    required this.pageContext,
    required this.emailAddress,
    required this.password
  });
}

class SetObscurePassword extends AuthenticationEvent {}

class LogOut extends AuthenticationEvent {
  final bool mounted;
  final BuildContext pageContext;

  const LogOut({
    required this.mounted,
    required this.pageContext,
  });
}

class ResetErrorStateToInitial extends AuthenticationEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}
// Authentication Event ========================================================= END

// Authentication State ========================================================= START
abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationAuthenticated extends AuthenticationState {}

class AuthenticationUnauthenticated extends AuthenticationState {
  final bool isObscurePassword;

  AuthenticationUnauthenticated({
    required this.isObscurePassword
  });
}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {
  final String errorMessage;

  AuthenticationError({
    required this.errorMessage
  });
}
// Authentication State ========================================================= END

// Authentication Bloc ========================================================= START
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationUnauthenticated(isObscurePassword: true)) {
    on<SetObscurePassword>(_mapSetObscurePasswordToState);
    on<LogIn>(_mapLoginToState);
    on<LogOut>(_mapLogOutToState);
    on<ResetErrorStateToInitial>(_mapResetErrorStateToInitialToState);
  }

  void _mapSetObscurePasswordToState(SetObscurePassword event, Emitter emit) {
    final currentState = state;
    bool isObscurePassword = false;

    if(currentState is AuthenticationUnauthenticated) {
      isObscurePassword = !currentState.isObscurePassword;
    }

    emit(AuthenticationLoading());
    emit(
      AuthenticationUnauthenticated(
        isObscurePassword: isObscurePassword
      )
    );
  }

  void _mapLoginToState(LogIn event, Emitter emit) async {
    emit(AuthenticationLoading());
    try {
      await auth.signInWithEmailAndPassword(
        email: event.emailAddress,
        password: event.password
      );

      if(!event.mounted) return;
      Navigator.pushAndRemoveUntil(
        event.pageContext,
        MaterialPageRoute(
          builder: (context) => const MainMenu(
            activePage: "home",
          ),
        ),
        (_) => false
      );
    } catch(error) {
      emit(
        AuthenticationError(
          errorMessage: "Oops, something went wrong, please try again!",
        )
      );
    }
  }

  void _mapLogOutToState(LogOut event, Emitter emit) {
    if(state is AuthenticationAuthenticated) {
      Navigator.pushAndRemoveUntil(
        event.pageContext,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (_) => false
      );

      emit(
        AuthenticationUnauthenticated(
          isObscurePassword: true
        )
      );
    }
  }

  void _mapResetErrorStateToInitialToState(ResetErrorStateToInitial event, Emitter emit) {
    emit(AuthenticationLoading());
    emit(
      AuthenticationUnauthenticated(
      isObscurePassword: true
    ));
  }
}
// Authentication Bloc ========================================================= END