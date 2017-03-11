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

const int lTrameRecu = 5;
const int lTrameEnvoi = 5;

byte trameRecu [lTrameRecu];
byte trameEnvoi [lTrameEnvoi] = {'A',200,150,100,0};

float angle;
float wr;

void setup() {
  Serial.begin(9600);
  pinMode(13,OUTPUT);
  pinMode(2,INPUT);
  digitalWrite(13,LOW);
}

void loop() {
  if (Serial.available()>=lTrameRecu){
    for (int i = 0 ; i< lTrameRecu ; i++){
      trameRecu[i] = Serial.read();
    }

    if (trameRecu[0] == 'A'){
      float vA = trameRecu[2]*0.5/100;
      simulData(millis(),vA,0.6,2.0);
      trameEnvoi[0] = 65;
      
    }
    if (trameRecu[0] == 'B'){
      float vB = trameRecu[2]*0.5/100;
      simulData(millis()+5000,vB,0.6,2.0);
      trameEnvoi[0] = 66;
    }
    if (trameRecu[0] == 'A' || trameRecu[0] == 'B'){
      trameEnvoi[2] = int((angle+PI)*255/(2*PI));
      trameEnvoi[3] = int((wr+2.5)*255/(2*2.5));
      if(digitalRead(2) == HIGH){
        trameEnvoi[4] = 1;
      }
      else{
        trameEnvoi[4] = 0;
      }
      if (trameRecu[1] == 1){
        digitalWrite(13,HIGH);
      }
      else{
        digitalWrite(13,LOW);
      }
      trameEnvoi[1] = 180 + random(10);
      for (int i = 0;i<lTrameEnvoi;i++){
        Serial.write(trameEnvoi[i]);
      }
    }
    else{
      Serial.flush();
    }
  }
  
}

void simulData(long tMillis,float V, float R, float l){
  float alpha = atan(2*R/l);
  float t0 = l/V;
  float t1 = t0 + (PI+2*alpha)*R/V;
  float t2 = t1+l/V;
  float tRevolution = t2 + (PI+2*alpha)*R/V;
  float t = (tMillis%(long(tRevolution*1000)))/1000.0;
  int cas = 0;
  if (t<t0){
    angle = PI/2 + alpha;
    wr = 0;
  }
  else if (t<t1){
    angle = map(t*1000,t0*1000,t1*1000,(PI/2 + alpha)*1000, (-PI/2 - alpha)*1000)/1000.0;
    wr = -V/R;
  }
  else if (t<t2){
    angle = -PI/2 - alpha;
  }
  else if (t<tRevolution){
    angle = map(t*1000,t2*1000,tRevolution*1000,(-PI/2 - alpha)*1000, (PI/2 + alpha)*1000)/1000.0;
    wr = +V/R;
  }
}
