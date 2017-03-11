/*
 * Penser à enlever les cavaliers 6 et 7 sur la Romeo
 * Infini Romeo v2
 * Stéphane Bizet le 19/11/2016
 */
#include "accelGyro.cpp"
#include "moteur.cpp"
#include "serieXbee.cpp"

Moteur moteur;
AccelGyro accelGyro;
SerieXbee serieXbee;
long to;

void setup()
{
  pinMode(13,OUTPUT);
  attachInterrupt(4,compteurPin7,CHANGE); 
  moteur.init();
  moteur.setConsigne(0);
  accelGyro.init();
  serieXbee.init();
  to = millis();
}


void loop()
{
  moteur.update();
  accelGyro.update();
  int vBat = analogRead(1)/4;
  float angle_y = accelGyro.getAngle();
  float gyro_y = accelGyro.getVRot();
  int octetAngle = int(map(angle_y,-180,180,0,255));
  int octetWr = int(map(gyro_y,200,-200,0,255));
  serieXbee.setTrameEnvoi(1,(byte)vBat);
  serieXbee.setTrameEnvoi(2,(byte)octetAngle);
  serieXbee.setTrameEnvoi(3,(byte)octetWr);
  serieXbee.setTrameEnvoi(4,(byte)moteur.getCommande());
  serieXbee.update();
  if (serieXbee.getEnvoi()){// si un envoi a été fait
    accelGyro.razMoyenne();// remettre a 0 les valeurs moyennes des angles et vitesses de rotations mesurées par le MPU6050
  }
  int consigne = serieXbee.getConsigne();
  moteur.setConsigne(consigne);
  
  //clignotement LED 13 = battements de coeur
  if((millis()-to)>100){
    digitalWrite(13,HIGH);
  }
  if((millis()-to)>200){
    to = millis();
    digitalWrite(13,LOW);
  }
  
  /*
  float v = moteur.getV();
  float commande = moteur.getCommande();
  float eInt = moteur.getEInt();
  float angle_y = accelGyro.getAngle();
  float gyro_y = accelGyro.getVRot();
  Serial.print(F("#ANGLE:"));   
  Serial.print(angle_y, 2);
  Serial.print("\t");
  Serial.print(F("#VGYR:"));
  Serial.print(gyro_y, 2);
  Serial.print("\t");
  Serial.print(v);
  Serial.print("\t   ");
  Serial.print(eInt);
  Serial.print("\t   ");
  Serial.println(commande);*/
  
}

void compteurPin7(){
   moteur.compteur();
}

