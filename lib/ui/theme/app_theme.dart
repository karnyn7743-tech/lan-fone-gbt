import 'package:flutter/material.dart';

/// نظام التصميم الموحد لتطبيق LanPhone.
/// لوحة ألوان هادئة: أخضر اتصالات + أسطح محايدة، مع دعم RTL والوضعين.
class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xFF087F72);
  static const Color accentColor = Color(0xFF19B89A);
  static const Color errorColor = Color(0xFFD9485F);
  static const Color warningColor = Color(0xFFE5A23B);
  static const Color successColor = Color(0xFF168A65);

  static const Color lightBackground = Color(0xFFF4F7F8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF17252B);
  static const Color lightTextSecondary = Color(0xFF718087);
  static const Color lightDivider = Color(0xFFE5ECEE);
  static const Color lightIncomingBubble = Color(0xFFFFFFFF);
  static const Color lightOutgoingBubble = Color(0xFFDDF5EC);

  static const Color darkBackground = Color(0xFF0D171B);
  static const Color darkSurface = Color(0xFF17252B);
  static const Color darkElevated = Color(0xFF1D2D33);
  static const Color darkTextPrimary = Color(0xFFEAF2F3);
  static const Color darkTextSecondary = Color(0xFFA1B0B5);
  static const Color darkDivider = Color(0xFF2A3A40);
  static const Color darkIncomingBubble = Color(0xFF203239);
  static const Color darkOutgoingBubble = Color(0xFF075E50);

  static const double radiusSmall = 12;
  static const double radiusMedium = 18;
  static const double radiusLarge = 24;

  static ThemeData get light => _buildTheme(Brightness.light);
  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final background = isDark ? darkBackground : lightBackground;
    final surface = isDark ? darkSurface : lightSurface;
    final foreground = isDark ? darkTextPrimary : lightTextPrimary;
    final secondary = isDark ? darkTextSecondary : lightTextSecondary;
    final divider = isDark ? darkDivider : lightDivider;

    final scheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: brightness,
      primary: isDark ? const Color(0xFF53CDB5) : primaryColor,
      secondary: accentColor,
      error: errorColor,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      primaryColor: primaryColor,
      visualDensity: VisualDensity.standard,
      dividerColor: divider,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: foreground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: foreground,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -.2,
        ),
        iconTheme: IconThemeData(color: foreground),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          side: BorderSide(color: divider.withValues(alpha: .72)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        titleTextStyle: TextStyle(
          color: foreground,
          fontSize: 19,
          fontWeight: FontWeight.w800,
        ),
        contentTextStyle: TextStyle(color: secondary, fontSize: 14),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: surface,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(radiusLarge),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? darkElevated : const Color(0xFF203238),
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: accentColor.withValues(alpha: isDark ? .20 : .14),
        elevation: 0,
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
            color: selected ? scheme.primary : secondary,
          );
        }),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.primary,
        unselectedLabelColor: secondary,
        indicatorColor: scheme.primary,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: const TextStyle(fontWeight: FontWeight.w800),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: divider,
          disabledForegroundColor: secondary,
          elevation: 0,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.primary.withValues(alpha: .45)),
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? darkElevated : const Color(0xFFF9FBFB),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        hintStyle: TextStyle(color: secondary, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: scheme.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: errorColor),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.primary,
        textColor: foreground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
      ),
      dividerTheme: DividerThemeData(color: divider, thickness: 1, space: 1),
      textTheme: TextTheme(
        displaySmall: TextStyle(
          color: foreground,
          fontSize: 30,
          fontWeight: FontWeight.w900,
          height: 1.15,
        ),
        headlineSmall: TextStyle(
          color: foreground,
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
        titleLarge: TextStyle(
          color: foreground,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
        titleMedium: TextStyle(
          color: foreground,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        titleSmall: TextStyle(
          color: foreground,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(color: foreground, fontSize: 16, height: 1.45),
        bodyMedium: TextStyle(color: foreground, fontSize: 14, height: 1.4),
        bodySmall: TextStyle(color: secondary, fontSize: 12, height: 1.35),
        labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        labelMedium: TextStyle(
          color: secondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      iconTheme: IconThemeData(color: foreground),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: divider,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? Colors.white : secondary),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? scheme.primary
                : divider),
      ),
    );
  }
}
