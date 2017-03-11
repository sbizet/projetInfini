public class Chariot { 
  private float inclinaison = 100;
  private float wr = 100;
  private int id;
  private float v;
  private float x, y;
  private int phase;
  private long t1, t3;
  private ArrayList<PVector> points;
  private boolean posDetecte;
  private Structure st = new Structure();

  public Chariot (int id) {  
    this.id = id;
    phase = 0;
    v = 0;
    points = new ArrayList<PVector>();
    posDetecte = false;
  }

  public void update() {
    int inclinaisonRecu = 0;
    int wrRecu = 0;
    if (this.id == 65) {
      inclinaisonRecu = recuA.getInclinaison();
      wrRecu = recuA.getWr();
    }
    if (this.id == 66) {
      inclinaisonRecu = recuB.getInclinaison();
      wrRecu = recuB.getWr();
    }
    inclinaison = 2*PI*inclinaisonRecu/255.0 - PI; 
    wr = 2*2.5*wrRecu/255.0 - 2.5;
    calcCoord();
    //ajoute le dernier point a la liste
    points.add(new PVector(x, y));
    // enlève le premier point a la liste si la liste fait plus de 500 points
    if (points.size()>500) {
      points.remove(0);
    }
  }

  public void arreter() {
  }

  public void display() {
    if (posDetecte) {
      pushMatrix();
      translate(width/2, 2*height/3);
      strokeWeight(1);
      stroke(0, 0, 255);
      for (int i = 0; i<points.size (); i++) {
        point (points.get(i).x*st.echelle, points.get(i).y*st.echelle);
        point (points.get(i).x*st.echelle, points.get(i).y*st.echelle);
      }
      translate(x*st.echelle, y*st.echelle);
      rotate(PI/2-inclinaison);
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
    } else {
      textAlign(CENTER, CENTER);
      text("pas de mouvement de chariot détecté ...", width/2, height/2);
    }
  }
  
  private void calcCoord() {
    float seuilVitesse = 0.1;
    if (inclinaison >0 && wr >(-seuilVitesse) && wr<seuilVitesse ) {
      if (phase != 1) {
        t1 = millis();
      }
      phase = 1;
      x=map(millis()-t1, 0, (st.l/v)*1000, -(st.l/2)*cos(st.alpha), (st.l/2)*cos(st.alpha));
      y=map(millis()-t1, 0, (st.l/v)*1000, (st.l/2)*sin(st.alpha), -(st.l/2)*sin(st.alpha));
    } else if (inclinaison <0 && wr >(-seuilVitesse) && wr<seuilVitesse ) {
      if (phase != 3) {
        t3 = millis();
      }
      phase = 3;
      x=map(millis()-t3, 0, (st.l/v)*1000, (st.l/2)*cos(st.alpha), -(st.l/2)*cos(st.alpha));
      y=map(millis()-t3, 0, (st.l/v)*1000, (st.l/2)*sin(st.alpha), -(st.l/2)*sin(st.alpha));
    } else if (wr<=-seuilVitesse) {
      phase = 2;
      posDetecte = true;
      x = st.xc + st.R*cos(inclinaison);
      y = -st.R*sin(inclinaison);
      v = -wr*st.R; // estime la valeur de la vitesse
    } else if (wr>=seuilVitesse) {
      posDetecte = true;
      phase = 4;
      x = -st.xc-st.R*cos(inclinaison);
      y = st.R*sin(inclinaison);
      v = wr*st.R; // estime la valeur de la vitesse
    }
  }
  

  public PVector getCoord() {
    return new PVector(x, y);
  }

  public float getDistance() {
    float d = 0;
    if (phase == 1) {
      if (x>0) {
        d = sqrt(x*x + y*y);
      } else {
        d = 2*st.R*(PI+2*st.alpha)+2*st.l-sqrt(x*x + y*y);
      }
    }
    if (phase == 2) {
      float angle = atan2(-y,x-st.xc);
      d = st.l/2 + st.R*(PI/2 + st.alpha - angle);
    }
    if (phase == 3){
      d = st.l/2 + st.R*(PI + 2*st.alpha) + sqrt(pow(x-(st.l/2)*cos(st.alpha),2)+pow(y-(st.l/2)*sin(st.alpha),2));
    }
    if (phase == 4) {
      float angle = atan2(-y,x+st.xc);
      if (angle<0) angle = angle + 2*PI;
      d = st.l/2 + st.R*(PI + 2*st.alpha)+ st.l + st.R*(angle - PI/2 + st.alpha);
    }
    return d;
  }
} 