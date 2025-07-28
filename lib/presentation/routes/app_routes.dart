import 'package:flutter/material.dart';
import 'package:burki_book/presentation/auth/pages/signup_page.dart';
import 'package:burki_book/presentation/auth/pages/signin_page.dart';
import 'package:burki_book/onboarding/onboarding_page.dart';
import 'package:burki_book/presentation/auth/pages/otp/otp_verification_page.dart';
import 'package:burki_book/presentation/common/loading_data_page.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String signup = '/signup';
  static const String signin = '/signin';
  static const String otpVerification = '/otp_verification';
  static const String loadingData = '/loading_data';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case signin:
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case otpVerification:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => OtpVerificationPage(
            phoneNumber: args?['phoneNumber'] ?? '',
            generatedOtp: args?['generatedOtp'] ?? '',
          ),
        );
      case loadingData:
        return MaterialPageRoute(builder: (_) => const LoadingDataPage());
      default:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
    }
  }
}
