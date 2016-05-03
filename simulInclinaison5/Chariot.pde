class Chariot { 
  float angle;
  float wr;
  int id;
  float v;
  float x, y;
  int phase;
  long t1, t2, t3;
  ArrayList<PVector> points;
  boolean posDetecte;

  Chariot (float aangle, float wwr, int iid, int pphase) {  
    angle = aangle; 
    wr = wwr;
    id = iid;
    v = 0;
    phase = pphase;
    points = new ArrayList<PVector>();
    posDetecte = false;
  }

  void update(int [] trameRecu) { 
    angle = 2*PI*trameRecu[2]/255.0 - PI; 
    wr = 2*2.5*trameRecu[3]/255.0 - 2.5;
    calcCoord();
    //ajoute le dernier point a la liste
    points.add(new PVector(x, y));
    // enlève le premier point a la liste si la liste fait plus de 200 points
    if (points.size()>500) {
      points.remove(0);
    }
  }

  void display() {
    if (posDetecte) {
      pushMatrix();
      translate(width/2, height/2);
      strokeWeight(1);
      stroke(0, 0, 255);
      for (int i = 0; i<points.size (); i++) {
        point (points.get(i).x*echelle, points.get(i).y*echelle);
        point (points.get(i).x*echelle, points.get(i).y*echelle);
      }
      translate(x*echelle, y*echelle);
      rotate(PI/2-angle);
      noStroke();
      fill(100);
      rect(-15, -30, 30, 30);
      stroke(100);
      strokeWeight(2);
      line(0, -15, 0, -50);
      line(0, -15, 35, -15);
      textAlign(LEFT, BOTTOM);
      textSize(12);
      text("x", 35, -17);
      text("z", 2, -50);
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(20);
      text(char(id), 0, -15);
      popMatrix();
    }
    else{
      textAlign(CENTER,CENTER);
      text("Détection en cours ...",width/2,height/2);
    }
  }

  void calcCoord() {
    if (angle >((PI/2+alpha)-PI/60)) {
      if (phase != 1) {
        t1 = millis();
      }
      phase = 1;
      x=map(millis()-t1, 0, (l/v)*1000, -(l/2)*cos(alpha), (l/2)*cos(alpha));
      y=map(millis()-t1, 0, (l/v)*1000, (l/2)*sin(alpha), -(l/2)*sin(alpha));
    } else if (angle<((-PI/2-alpha)+PI/60)) {
      if (phase != 3) {
        t3 = millis();
      }
      phase = 3;
      x=map(millis()-t3, 0, (l/v)*1000, (l/2)*cos(alpha), -(l/2)*cos(alpha));
      y=map(millis()-t3, 0, (l/v)*1000, (l/2)*sin(alpha), -(l/2)*sin(alpha));
    } else if (wr<0) {
      phase = 2;
      posDetecte = true;
      x = xc + R*cos(angle);
      y = -R*sin(angle);
      v = -wr*R; // estime la valeur de la vitesse
    } else if (wr>0) {
      posDetecte = true;
      phase = 4;
      x = -xc-R*cos(angle);
      y = R*sin(angle);
      v = wr*R; // estime la valeur de la vitesse
    }
  }
} 

