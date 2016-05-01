import processing.serial.*;
import static javax.swing.JOptionPane.*;
Serial myPort;
long to = millis();
int [] trameEnvoi = {'A', 0, 100, 0, 0};
int [] trameRecuA = new int[5];
int [] trameRecuB = new int[5];

float l = 2; // la longeur des parties linéaires du rail en m
float R = 0.6; // le rayon des cercles en m
float echelle = 200; // en pixel par m

float alpha = atan(2*R/l); // pente en rad de la partie linéaire
float xc = sqrt(R*R+(l/2)*(l/2)); // abscisse du centre du cercle


Chariot chariotA = new Chariot(0, 0, "A");
Chariot chariotB = new Chariot(0, 0, "B");

void setup() {
  size(800, 600);
  connexionSerie();
}

void draw() {
  if ((millis() - to) > 50) {
    background(0);
    envoiTrame(trameEnvoi);
    chariotA.update(trameRecuA);
    chariotA.display();
    chariotB.update(trameRecuB);
    chariotB.display();

    to = millis();
  }
  if ( myPort.available() > trameRecuA.length) { 
    //print("recu : ");
    int id = myPort.read();
    if (id == 65) {
      for (int i = 1; i<trameRecuA.length; i++) {
        int octetRecu = myPort.read();
        trameRecuA[i] = octetRecu;
        //print (int(octetRecu) + "  ");
      }
      //println();
    }
    else if (id == 66) {
      for (int i = 1; i<trameRecuB.length; i++) {
        int octetRecu = myPort.read();
        trameRecuB[i] = octetRecu;
        //print (int(octetRecu) + "  ");
      }
      //println();
    }
    else{
      println("trame recu non conforme");
    }
  }
}