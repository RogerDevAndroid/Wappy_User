import 'package:flutter/material.dart';

void main() {
  runApp(ConnectingVibes());
}

class ConnectingVibes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        toolbarHeight: 100,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {},
            ),
            Text(
              'Eventos',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filtros de búsqueda
            Wrap(
              spacing: 8.0,
              children: [
                FilterChip(
                  label: Text('Adventure'),
                  selected: true,
                  onSelected: (bool value) {},
                ),
                FilterChip(
                  label: Text('Comedy'),
                  selected: true,
                  onSelected: (bool value) {},
                ),
                FilterChip(
                  label: Text('Movie'),
                  selected: false,
                  onSelected: (bool value) {},
                ),
                FilterChip(
                  label: Text('Tv Series'),
                  selected: true,
                  onSelected: (bool value) {},
                ),
              ],
            ),
            SizedBox(height: 15),
            // Barra de búsqueda
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 15),
            // Título de resultados
            Text(
              'Search Results:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Lista de resultados
            Expanded(
              child: ListView.builder(
                itemCount: 2, // Número de ítems en la lista
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.image, size: 40),
                      ),
                      title: Text('Ipsum'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('2020 1h 10 min'),
                          Text('⭐ 9.2'),
                          Text('3 Seasons'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.favorite_border, color: Colors.red),
                        onPressed: () {},
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}