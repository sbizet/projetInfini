import processing.serial.*;
import static javax.swing.JOptionPane.*;
Serial myPort;
long to = 0;
int [] trameEnvoiA = {'A', 1, 100, 0, 0};
int [] trameEnvoiB = {'B', 1, 100, 0, 0};
int [] trameRecuA =  {'A',200,150,100,0};
int [] trameRecuB =  {'B',200,150,50,0}; 
boolean reception=false;

float l = 2; // la longeur des parties linéaires du rail en m
float R = 0.6; // le rayon des cercles en m
float echelle = 200; // en pixel par m

float alpha = atan(2*R/l); // pente en rad de la partie linéaire
float xc = sqrt(R*R+(l/2)*(l/2)); // abscisse du centre du cercle

Chariot chariotA = new Chariot(0, 0, int('A'));
Chariot chariotB = new Chariot(0, 0, int('B'));

int Tenvoi = 100;

void setup() {
  size(800, 600);
  connexionSerie();
}

void draw() {
  background(0);
  long maintenant = millis();
  if ((maintenant - to) > Tenvoi) {
    envoiTrame(trameEnvoiA);
    to = maintenant;
    println("envoi " + millis() + " ms" + " --- frameRate : " + frameRate);
    reception = false;
  }
  int idTrame = receptionTrame();
  if (idTrame == 65) {
    chariotA.update(trameRecuA);
    envoiTrame(trameEnvoiB);
    println("A : " + (maintenant-to) + " ms");
    reception = true;
  }
  if (idTrame == 66) {
    chariotB.update(trameRecuB);
    println("B : " + (maintenant-to) + " ms");
    reception = true;
  }
  if((maintenant-to)>(Tenvoi-5) && reception == false && maintenant >1000){
    println("pas de réponse des chariots");
    //arreter
  }
  chariotA.display();
  chariotB.display();
}