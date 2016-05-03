import processing.serial.*;
import static javax.swing.JOptionPane.*;
Serial myPort;
long to = 0;
int [] trameEnvoiA = {'A', 1, 60, 0, 0};
int [] trameEnvoiB = {'B', 1, 255, 0, 0};
int [] trameRecuA =  {'A',200,150,100,0};
int [] trameRecuB =  {'B',200,150,50,0}; 
boolean reception=false;

float l = 2; // la longeur des parties linéaires du rail en m
float R = 0.6; // le rayon des cercles en m
float echelle = 200; // en pixel par m

float alpha = atan(2*R/l); // pente en rad de la partie linéaire
float xc = sqrt(R*R+(l/2)*(l/2)); // abscisse du centre du cercle

Chariot chariotA = new Chariot(0, 0, int('A'),1);
Chariot chariotB = new Chariot(0, 0, int('B'),3);

int Tenvoi = 100;

void setup() {
  size(800, 600);
  connexionSerie();
}

void draw() {
  background(0);
  comSerie();
  verifChoc();
  chariotA.display();
  chariotB.display();
}

boolean verifChoc(){
  float distance = sqrt((chariotA.x-chariotB.x)*(chariotA.x-chariotB.x)+(chariotA.y-chariotB.y)*(chariotA.y-chariotB.y));
  if (distance<0.3 && chariotA.posDetecte && chariotB.posDetecte && !(chariotA.phase == 1 && chariotB.phase == 3) && !(chariotA.phase == 3 && chariotB.phase == 1)){
    //println("CHOC");
    arreter();
    return true;
  }
  else{
    return false;
  }
}

void arreter(){
}

