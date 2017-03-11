import processing.serial.*;
import static javax.swing.JOptionPane.*;

public class LiaisonSerie {

  private Serial myPort;
  private long to = millis();
  private int Tenvoi = 100;
  boolean reception=false;
  boolean connected=false;
  private String etatConnexion = "init";
  private String portName = "";
  
  public LiaisonSerie() { // Constructeur
    this.connexionSerie();
  }

  public void communique() {
    int [] trameEnvoiA = envoiA.getTrame();
    int [] trameEnvoiB = envoiB.getTrame();
    int idTrame = -1;
    long maintenant = millis();
    if (connected) {
      if ((maintenant - to) > Tenvoi) {
        myPort.clear(); 
        envoiTrame(trameEnvoiA);
        to = maintenant;
        reception = false;
      }
      idTrame = receptionTrame();
      if (idTrame == 65) {
        recuA.nouvelleTrame();
        envoiTrame(trameEnvoiB);
        reception = true;
        etatConnexion = "connexion OK";
      }
      if (idTrame == 66) {
        recuB.nouvelleTrame();
        reception = true;
      }
      if ((maintenant-to)>(Tenvoi-5) && reception == false && maintenant >2000) {        idTrame = 0;
        connected = false;
      }
    } else {
      if ((maintenant - to) > 200) {
        if (myPort != null) {
          println("pas de réponse des chariots @ " + nf(maintenant/1000.0,0,1) + " s");
          myPort.clear();
          myPort.stop();
        }
        this.connexionSerie();
        println("Tentative de reconnexion @ " + nf(maintenant/1000.0,0,1) + " s");
        to = maintenant;
        etatConnexion = "pas de réponse d'un chariot";
      }
    }
  }

  private void envoiTrame(int [] trameEnvoi) {
    for (int i = 0; i < trameEnvoi.length; i++) {
      byte octetSansSigne = unsignedByte(trameEnvoi[i]);
      myPort.write(octetSansSigne);
    }
  }

  private int receptionTrame() {
    int retour = -1;
    if ( myPort.available() >= recuA.getTrame().length) { 
      int id = myPort.read();
      if (id == 65) {
        for (int i = 1; i<recuA.getTrame().length; i++) {
          int octetRecu = myPort.read();
          recuA.setTrame(i, octetRecu);
        }
        retour = 65;
      } else if (id == 66) {
        for (int i = 1; i<recuB.getTrame().length; i++) {
          int octetRecu = myPort.read();
          recuB.setTrame(i, octetRecu);
        }
        retour = 66;
      } else {
        println("trame recue non conforme (commence par : " + id +" )");
        etatConnexion = "trame recue non conforme";
        myPort.clear();
        retour = -1;
      }
    }
    return retour;
  }

  private byte unsignedByte( int val ) { 
    return (byte)( val > 127 ? val - 256 : val );
  }

  
  private void connexionSerie() {
    String COMx, COMlist = "";
    try {
      int i = Serial.list().length;
      if (i != 0) {
        if (portName == ""){
          if (i >= 2) {
            for (int j = 0; j < i; ) {
              COMlist += char(j+'a') + " = " + Serial.list()[j];
              if (++j < i) COMlist += ",  ";
            }
            COMx = showInputDialog("Quel port COM ? (a,b,..):\n"+COMlist);
            if (COMx == null) connected=false;
            if (COMx.isEmpty()) connected=false;
            i = int(COMx.toLowerCase().charAt(0) - 'a') + 1;
          }
          portName = Serial.list()[i-1];
          println("Port série utilisé = " + portName);
        }
        PApplet parent = new PApplet();
        myPort = new Serial(parent, portName, 9600);
        myPort.bufferUntil('\n');
        connected = true;
        delay(50);
      } else {
        showMessageDialog(frame, "Pas de port COM détecté");
        connected=false;
      }
    }
    catch (Exception e)
    { //Print the type of error
      showMessageDialog(frame, "port COM n'est pas disponible\n(peut être utilisé par un autre programme)");
      println("Erreur : ", e);
      connected=false;
    }
  }
  
  String getEtatConnexion(){
    return etatConnexion;
  }
}