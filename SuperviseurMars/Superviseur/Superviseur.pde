import g4p_controls.*;

LiaisonSerie ls = new LiaisonSerie();

Chariot chariotA = new Chariot(int('A'));
Chariot chariotB = new Chariot(int('B'));

Envoi envoiA = new Envoi('A');
Envoi envoiB = new Envoi('B');

Recu recuA = new Recu('A');
Recu recuB = new Recu('B');

Scenario scenario = new Scenario();

void setup() {
  size(800,600);
  createGUI();
}

void draw() {
  background(0);
  ls.communique();
  GUIConnected.setText(ls.getEtatConnexion());
  LabelEnvoiA.setText("EnvoiA = " + nf(envoiA.getTrame()[0],3,0) + " " + nf(envoiA.getTrame()[1],3,0) + " " + nf(envoiA.getTrame()[2],3,0) + " " + nf(envoiA.getTrame()[3],3,0) + " " + nf(envoiA.getTrame()[4],3,0));
  LabelEnvoiB.setText("EnvoiB = " + nf(envoiB.getTrame()[0],3,0) + " " + nf(envoiB.getTrame()[1],3,0) + " " + nf(envoiB.getTrame()[2],3,0) + " " + nf(envoiB.getTrame()[3],3,0) + " " + nf(envoiB.getTrame()[4],3,0));
  LabelRecuA.setText("RecuA = " + nf(recuA.getTrame()[0],3,0) + " " + nf(recuA.getTrame()[1],3,0) + " " + nf(recuA.getTrame()[2],3,0) + " " + nf(recuA.getTrame()[3],3,0) + " " + nf(recuA.getTrame()[4],3,0));
  LabelRecuB.setText("RecuB = " + nf(recuB.getTrame()[0],3,0) + " " + nf(recuB.getTrame()[1],3,0) + " " + nf(recuB.getTrame()[2],3,0) + " " + nf(recuB.getTrame()[3],3,0) + " " + nf(recuB.getTrame()[4],3,0));
  
  GUIvBatA.setText("VBatA = " + nf(recuA.getVBat(),0,0));
  GUIvBatB.setText("VBatB = " + nf(recuB.getVBat(),0,0));
  
  chariotA.display();
  chariotB.display();
  
  scenario.update();
}