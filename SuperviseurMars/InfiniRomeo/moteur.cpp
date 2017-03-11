#include "Arduino.h"

#define pwmPin 5  
#define dirPin 4 
#define encoderPin 7

class Moteur
{
  public:
    volatile int nC = 0;
    volatile float v = 0;
    long to;
    int consigne = 120;
    float eInt = 0;
    int commande = 0;
    float K = 2.0;
    float Ki = 0.1;
    
    void init(){
      pinMode(encoderPin,INPUT_PULLUP);
      pinMode(pwmPin,OUTPUT);
      pinMode(dirPin,OUTPUT);
      to = micros();
    }
    
    void update(){
      float e = (consigne - v);
      eInt += e;
      eInt = constrain(eInt,-255/Ki,255/Ki);
      commande = int(constrain(K*e + Ki*eInt,-255,255));
      commandeMoteur(commande,true);
    }
    
    float getV(){
      return v;
    }
    
    int getCommande(){
      return commande;
    }
    
    float getEInt(){
      return eInt;
    }
    
    void setConsigne(int nouvelleConsigne){
      consigne = nouvelleConsigne;
    }
      
    void commandeMoteur(int pwm, boolean sens){
      if (pwm>=0){
        digitalWrite(dirPin, sens);   
        analogWrite(pwmPin, pwm);
      }
      else{//freinage
        digitalWrite(dirPin, !sens);   
        analogWrite(pwmPin, -pwm);
      }
    }

    void compteur(){
      nC+=2; // parce qu'il n'y a qu'une seule interruption par tour au lieu de 2.
      int nMax = 4;
      if (nC>(nMax+1)){
        v = 60000000.0*nC/(360*(micros()-to));
        to=micros();
        nC=0;
      }
      if ((micros()-to)>8000){
        to=micros();
        nC=0;
      }
    }
};

