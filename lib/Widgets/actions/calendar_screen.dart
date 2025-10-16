import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lover/Provider/UserProvider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  late AnimationController _heartsController;
  final Random _random = Random();
  List<_Heart> _hearts = [];

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final supabase = Supabase.instance.client;

  // Map of all user events: { day: [event1, event2, ...] }
  Map<DateTime, List<String>> _events = {};

  final Color pink = const Color(0xFFFF6F91);
  final Color blue = const Color(0xFF4FC3F7);
  final Color navy = const Color(0xFF1C1C2E);

  @override
  void initState() {
    super.initState();
    _heartsController =
    AnimationController(vsync: this, duration: const Duration(seconds: 15))
      ..repeat();
    for (int i = 0; i < 20; i++) {
      _hearts.add(_Heart(
        x: _random.nextDouble(),
        size: 15 + _random.nextDouble() * 25,
        opacity: 0.2 + _random.nextDouble() * 0.6,
      ));
    }

    // Load user events
    _loadUserMemories();
  }

  @override
  void dispose() {
    _heartsController.dispose();
    super.dispose();
  }

  DateTime _normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  // 🎯 Fetch all events for the logged-in user
  Future<void> _loadUserMemories() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId;

    if (userId == null || userId.isEmpty) return;

    try {
      final response = await supabase
          .from('love_memories')
          .select()
          .eq('user_id', userId)
          .order('event_date', ascending: true);

      final Map<DateTime, List<String>> loaded = {};

      for (final item in response) {
        final date = DateTime.parse(item['event_date']);
        final normalized = _normalizeDate(date);
        final desc = item['description'] ?? '';

        loaded.putIfAbsent(normalized, () => []).add(desc);
      }

      setState(() {
        _events = loaded;
      });
    } catch (e) {
      print('Error loading memories: $e');
    }
  }

  List<String> _getEventsForDay(DateTime day) {
    return _events[_normalizeDate(day)] ?? [];
  }

  // 💖 Add event both locally and in Supabase
  void _addEventDialog(DateTime day) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Add Love Memory",
              style: TextStyle(color: pink, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "e.g. Romantic dinner, surprise gift...",
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: pink),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: blue)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: pink,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                final text = controller.text.trim();
                if (text.isEmpty) return;

                final date = _normalizeDate(day);
                final userProvider =
                Provider.of<UserProvider>(context, listen: false);
                final userId = userProvider.userId;

                if (userId == null || userId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('User not logged in'),
                  ));
                  return;
                }

                try {
                  // Insert into Supabase
                  await supabase.from('love_memories').insert({
                    'user_id': userId,
                    'event_date':
                    date.toIso8601String().substring(0, 10), // yyyy-MM-dd
                    'description': text,
                  });

                  // Update local map
                  setState(() {
                    _events.putIfAbsent(date, () => []).add(text);
                  });
                } catch (e) {
                  print('Error adding memory: $e');
                }

                Navigator.pop(context);
              },
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFloatingHeart(_Heart heart) {
    return AnimatedBuilder(
      animation: _heartsController,
      builder: (context, child) {
        final h = MediaQuery.of(context).size.height;
        final w = MediaQuery.of(context).size.width;
        final p = (_heartsController.value + heart.x) % 1.0;
        final top = h * (1 - p);
        final drift = sin(p * 2 * pi) * 30.0;

        return Positioned(
          left: (heart.x * w) + drift,
          top: top,
          child: Opacity(
            opacity: (1 - p) * heart.opacity,
            child: Transform.rotate(
              angle: p * 2 * pi,
              child: Icon(Icons.favorite,
                  color: Colors.pinkAccent.withOpacity(heart.opacity),
                  size: heart.size),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: pink,
        title: const Text("Love Calendar",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          ..._hearts.map(_buildFloatingHeart),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [pink.withOpacity(0.15), blue.withOpacity(0.1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                        color: pink.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4)),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      TableCalendar(
                        focusedDay: _focusedDay,
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        eventLoader: _getEventsForDay,
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        headerStyle: HeaderStyle(
                          titleCentered: true,
                          formatButtonVisible: false,
                          titleTextStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: navy),
                          leftChevronIcon:
                          Icon(Icons.chevron_left, color: pink),
                          rightChevronIcon:
                          Icon(Icons.chevron_right, color: pink),
                        ),
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color: pink.withOpacity(0),
                            shape: BoxShape.circle,
                          ),
                          weekendTextStyle: TextStyle(color: blue),
                          defaultTextStyle: TextStyle(color: navy),
                          outsideDaysVisible: false,
                          markerDecoration: BoxDecoration(
                            color: pink,
                            shape: BoxShape.circle,
                          ),
                        ),
                        calendarBuilders: CalendarBuilders(
                          selectedBuilder: (context, date, _) {
                            final hasEvents = _getEventsForDay(date).isNotEmpty;

                            if (hasEvents) {
                              return Center(
                                child: Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    color: navy,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }

                            return Container(
                              decoration: BoxDecoration(
                                color: pink,
                                shape: BoxShape.circle,
                              ),
                              margin: const EdgeInsets.all(6.0),
                              alignment: Alignment.center,
                              child: Text(
                                '${date.day}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                          markerBuilder: (context, date, events) {
                            if (events.isNotEmpty) {
                              return const Positioned(
                                bottom: 1,
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Icon(
                                    Icons.favorite,
                                    size: 50,
                                    color: Colors.pinkAccent,
                                  ),
                                ),
                              );
                            }
                            return null;
                          },
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekendStyle: TextStyle(color: pink),
                          weekdayStyle:
                          TextStyle(color: navy.withOpacity(0.8)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_selectedDay != null)
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Memories for ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: navy),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: _getEventsForDay(_selectedDay!).isEmpty
                                    ? Center(
                                  child: Text(
                                    "No memories yet \nAdd one below!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: navy.withOpacity(0.7)),
                                  ),
                                )
                                    : ListView(
                                  children: _getEventsForDay(_selectedDay!)
                                      .map((event) => Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            16)),
                                    color:
                                    pink.withOpacity(0.15),
                                    child: ListTile(
                                      leading: const Icon(
                                          Icons.favorite,
                                          color:
                                          Colors.pinkAccent),
                                      title: Text(
                                        event,
                                        style: TextStyle(
                                            color: navy,
                                            fontWeight:
                                            FontWeight.w500),
                                      ),
                                    ),
                                  ))
                                      .toList(),
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton.icon(
                                onPressed: () {
                                  if (_selectedDay != null) {
                                    _addEventDialog(_selectedDay!);
                                  }
                                },
                                label: const Text("Add Memory",
                                    style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: pink,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Heart {
  final double x;
  final double size;
  final double opacity;
  _Heart({required this.x, required this.size, required this.opacity});
}