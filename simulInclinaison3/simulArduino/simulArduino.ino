const int lTrameRecu = 5;
const int lTrameEnvoi = 5;

byte trameRecu [lTrameRecu];
byte trameEnvoi [lTrameEnvoi] = {'A',200,150,100,0};
char idChariot = 'A';

float angle;
float wr;

void setup() {
  Serial.begin(57600);
  pinMode(13,OUTPUT);
  pinMode(2,INPUT);
}

void loop() {
  if (Serial.available()>lTrameRecu){
    for (int i = 0 ; i< lTrameRecu ; i++){
      trameRecu[i] = Serial.read();
    }
    if (testTrame(trameRecu) == true){
      simulData(millis(),0.5,0.6,2.0);
      trameEnvoi[0] = 65;
      trameEnvoi[1] = int((angle+PI)*255/(2*PI));
      trameEnvoi[2] = int((wr+2.5)*255/(2*2.5));
      if(digitalRead(2) == HIGH){
        trameEnvoi[4] = 1;
      }
      else{
        trameEnvoi[4] = 0;
      }
      for (int i = 0;i<lTrameEnvoi;i++){
        Serial.write(trameEnvoi[i]);
      }
      
      if (trameRecu[1] == 1){
        digitalWrite(13,HIGH);
      }
      else{
        digitalWrite(13,LOW);
      }

      delay(10);
      simulData(millis()+3000,0.7,0.6,2.0);
      trameEnvoi[0] = 66;
      trameEnvoi[1] = int((angle+PI)*255/(2*PI));
      trameEnvoi[2] = int((wr+2.5)*255/(2*2.5));
      for (int i = 0;i<lTrameEnvoi;i++){
        Serial.write(trameEnvoi[i]);
      }
      
    }
  }
  else{
    Serial.flush();
  }
}

boolean testTrame(byte inByte []){
  boolean retour = true;
  if (inByte[0] != idChariot){retour = false;}
  if (inByte[1]>2){retour = false;}
  return retour;
}

void simulData(long tMillis,float V, float R, float l){
  float alpha = atan(2*R/l);
  float t0 = l/V;
  float t1 = t0 + (PI+2*alpha)*R/V;
  float t2 = t1+l/V;
  float tRevolution = t2 + (PI+2*alpha)*R/V;
  float t = (tMillis%(int(tRevolution*1000)))/1000.0;
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
