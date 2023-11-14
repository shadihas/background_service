
import 'package:flutter/material.dart';

class HeroAnimations extends StatefulWidget {
  const HeroAnimations({super.key});

  @override
  State<HeroAnimations> createState() => _HeroAnimationsState();
}

class Person {
  String name;
  int age;
  IconData icon;
  Person({
    required this.name,
    required this.age,
    required this.icon,
  });
}

List<Person> people = [
  Person(name: "Shadi", age: 26, icon: Icons.face_6_sharp),
  Person(name: "Bill", age: 26, icon: Icons.girl),
  Person(name: "Ronaldo", age: 26, icon: Icons.person)
];

class _HeroAnimationsState extends State<HeroAnimations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("People"),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: people.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return DetailsScreen(person: people[index]);
                  },
                ));
              },
              title: Text(people[index].name),
              subtitle: Text("${people[index].age} years old"),
              leading: Hero(
                  flightShuttleBuilder: (flightContext, animation,
                      flightDirection, fromHeroContext, toHeroContext) {
                    switch (flightDirection) {
                      case HeroFlightDirection.push:
                        return Material(
                          color: Colors.transparent,
                          child: ScaleTransition(
                              scale: animation.drive(
                                  Tween<double>(begin: 0.0, end: 1.0).chain(
                                      CurveTween(curve: Curves.fastOutSlowIn))),
                              child: toHeroContext.widget),
                        );
                      case HeroFlightDirection.pop:
                        return Material(
                          color: Colors.transparent,
                          child: fromHeroContext.widget,
                        );
                    }
                  },
                  tag: people[index].icon,
                  child: Icon(people[index].icon)),
              trailing: const Icon(Icons.arrow_forward_ios),
            );
          },
        ));
  }
}

class DetailsScreen extends StatelessWidget {
  Person person;
  DetailsScreen({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(tag: person.icon, child: Icon(person.icon)),
        centerTitle: true,
      ),
    );
  }
}
