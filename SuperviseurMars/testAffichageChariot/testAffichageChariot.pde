
private Table table;

Chariot chariotA = new Chariot(int('A'));

Recu recuA = new Recu('A');

void setup() {
  size(800,600);
  table = loadTable("test.csv", "header");
}

void draw() {
  background(0);
  recuA.simulTrame();
  
  chariotA.update();
  
  chariotA.display();
  
}