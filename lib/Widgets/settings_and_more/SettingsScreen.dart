import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _darkMode = false;
  bool _showMemories = true;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final pink = Color(0xFFFF6F91);
    final blue = Color(0xFF4FC3F7);
    final navy = Color(0xFF1C1C2E);
    final purple = Color(0xFFBA68C8);

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pink.shade50.withOpacity(0.3),
              Colors.blue.shade50.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [pink, Colors.pink.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: pink.withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Settings",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.settings_rounded, color: Colors.white, size: 28),
                  ],
                ),
              ),

              // Settings Content
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(20),
                  physics: BouncingScrollPhysics(),
                  children: [
                    // Account Section
                    _sectionHeader("Account", Icons.person_rounded, pink),
                    SizedBox(height: 12),
                    _settingsCard(
                      child: Column(
                        children: [
                          _settingsTile(
                            Icons.account_circle_rounded,
                            "Profile",
                            "Edit your profile information",
                            pink,
                            onTap: () {},
                          ),
                          Divider(height: 1),
                          _settingsTile(
                            Icons.favorite_rounded,
                            "Relationship Status",
                            "Update your relationship details",
                            pink,
                            onTap: () {},
                          ),
                          Divider(height: 1),
                          _settingsTile(
                            Icons.lock_rounded,
                            "Privacy",
                            "Manage your privacy settings",
                            pink,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Notifications Section
                    _sectionHeader("Notifications", Icons.notifications_rounded, purple),
                    SizedBox(height: 12),
                    _settingsCard(
                      child: Column(
                        children: [
                          _switchTile(
                            Icons.notifications_active_rounded,
                            "Push Notifications",
                            "Receive notifications from your partner",
                            _notificationsEnabled,
                            purple,
                                (value) {
                              setState(() {
                                _notificationsEnabled = value;
                              });
                            },
                          ),
                          Divider(height: 1),
                          _switchTile(
                            Icons.volume_up_rounded,
                            "Sound",
                            "Play sounds for notifications",
                            _soundEnabled,
                            purple,
                                (value) {
                              setState(() {
                                _soundEnabled = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Appearance Section
                    _sectionHeader("Appearance", Icons.palette_rounded, blue),
                    SizedBox(height: 12),
                    _settingsCard(
                      child: Column(
                        children: [
                          _switchTile(
                            Icons.dark_mode_rounded,
                            "Dark Mode",
                            "Switch to dark theme",
                            _darkMode,
                            blue,
                                (value) {
                              setState(() {
                                _darkMode = value;
                              });
                            },
                          ),
                          Divider(height: 1),
                          _settingsTile(
                            Icons.language_rounded,
                            "Language",
                            _selectedLanguage,
                            blue,
                            onTap: () {
                              _showLanguageDialog();
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Content Section
                    _sectionHeader("Content", Icons.photo_library_rounded, Color(0xFFFFA726)),
                    SizedBox(height: 12),
                    _settingsCard(
                      child: Column(
                        children: [
                          _switchTile(
                            Icons.auto_awesome_rounded,
                            "Show Memories",
                            "Display shared memories on home",
                            _showMemories,
                            Color(0xFFFFA726),
                                (value) {
                              setState(() {
                                _showMemories = value;
                              });
                            },
                          ),
                          Divider(height: 1),
                          _settingsTile(
                            Icons.storage_rounded,
                            "Storage",
                            "Manage app storage",
                            Color(0xFFFFA726),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Support Section
                    _sectionHeader("Support", Icons.help_rounded, navy),
                    SizedBox(height: 12),
                    _settingsCard(
                      child: Column(
                        children: [
                          _settingsTile(
                            Icons.mail_rounded,
                            "Contact Us",
                            "Get in touch with support",
                            navy,
                            onTap: () {},
                          ),
                          Divider(height: 1),
                          _settingsTile(
                            Icons.rate_review_rounded,
                            "Rate App",
                            "Share your feedback",
                            navy,
                            onTap: () {},
                          ),
                          Divider(height: 1),
                          _settingsTile(
                            Icons.share_rounded,
                            "Share App",
                            "Tell your friends about us",
                            navy,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Danger Zone
                    _settingsCard(
                      child: _settingsTile(
                        Icons.logout_rounded,
                        "Log Out",
                        "Sign out from your account",
                        Colors.red,
                        onTap: () {
                          _showLogoutDialog();
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                    Center(
                      child: Text(
                        "Version 1.0.0",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1C1C2E),
          ),
        ),
      ],
    );
  }

  Widget _settingsCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _settingsTile(
      IconData icon,
      String title,
      String subtitle,
      Color color, {
        required VoidCallback onTap,
      }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Color(0xFF1C1C2E),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 13,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[400], size: 16),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Widget _switchTile(
      IconData icon,
      String title,
      String subtitle,
      bool value,
      Color color,
      Function(bool) onChanged,
      ) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Color(0xFF1C1C2E),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 13,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: color,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Select Language"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _languageOption("English"),
            _languageOption("Spanish"),
            _languageOption("French"),
            _languageOption("German"),
            _languageOption("Arabic"),
          ],
        ),
      ),
    );
  }

  Widget _languageOption(String language) {
    return RadioListTile<String>(
      title: Text(language),
      value: language,
      groupValue: _selectedLanguage,
      onChanged: (value) {
        setState(() {
          _selectedLanguage = value!;
        });
        Navigator.pop(context);
      },
      activeColor: Color(0xFFFF6F91),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Log Out"),
        content: Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Add logout logic
            },
            child: Text("Log Out", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}