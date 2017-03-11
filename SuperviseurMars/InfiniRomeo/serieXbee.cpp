/*
Trame Recue
Octet n° 0 : 65 ou 66 ('A' ou 'B' en ASCII) : information sur le chariot concerné A ou B
Octet n°1 : 0 ou 1 : le chariot est mis en marche ou arrêté.
Octet n°2 : 0 à 255 : Vmot = information pour le réglage de la vitesse du moteur
Octet n°3 : 0 à 180 : Pan
Octet n°4 : 0 à 180 : Tilt

Trame envoyée :
Octet n°0 : 65 ou 66 ('A' ou 'B' en ASCII) : information sur le chariot A ou B envoyant l'information
Octet n°1 : Vbat (0 à 255) : Une information sur la tension au niveau de la batterie (255 correspondant à 15V par exemple) 
Octet n°2 : inclinaison  (0 à 255) information issue de l'accélérometre + gyroscope
Octet n°3 : wr (0 à 255) information issue de l'accélérometre + gyroscope
Octet n°4 : choc (0, 1) envoit un 1 en cas de choc
 */
 
#include "Arduino.h"
#define lTrameRecu 5  
#define lTrameEnvoi 5 

class SerieXbee
{
  public:
    int idC = 65;
    
    byte trameRecu [lTrameRecu];
    byte trameEnvoi [lTrameEnvoi] = {idC,111,112,113,114}; // trame bidon pour commencer

    byte nOctet = 0;

    boolean envoi = false;
    
    void init(){
      pinMode(6,OUTPUT);
      Serial1.begin(9600);
      while (!Serial1) ;
    }
    
    void update(){
      if (Serial1.available() > 0){
        digitalWrite(6,HIGH); // LED 6 prend le pouls du Xbee
        byte val = Serial1.read();
        if (nOctet>0){
          trameRecu[nOctet] = val;
          nOctet++;
        }
        if (nOctet>=lTrameRecu){
          nOctet=0;
          for (int i = 0 ; i < lTrameEnvoi ; i++){
            Serial1.write(trameEnvoi[i]);
          }
          envoi = true;
        } 
        if (val == idC && nOctet == 0){
          trameRecu[0] = val;
          nOctet=1;
        }
      }
      else{
        digitalWrite(6,LOW);
      }
    }
    
    void setTrameEnvoi(int index, byte octet){
      trameEnvoi[index] = octet;
    }
    
    byte getConsigne(){
      return trameRecu[2];
    }

    boolean getEnvoi(){// retourne vrai si un envoi a été fait et remet tout de suite la variable envoi à faux
      boolean retour = false;
      if (envoi){
        envoi = false;
        retour = true;
      }
      return retour;
    }

};

