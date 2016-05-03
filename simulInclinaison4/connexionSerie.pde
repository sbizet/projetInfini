void connexionSerie(){
  String COMx, COMlist = "";
  try {
    printArray(Serial.list());
    int i = Serial.list().length;
    if (i != 0) {
      if (i >= 2) {
        // need to check which port the inst uses -
        // for now we'll just let the user decide
        for (int j = 0; j < i;) {
          COMlist += char(j+'a') + " = " + Serial.list()[j];
          if (++j < i) COMlist += ",  ";
        }
        COMx = showInputDialog("Which COM port is correct? (a,b,..):\n"+COMlist);
        if (COMx == null) exit();
        if (COMx.isEmpty()) exit();
        i = int(COMx.toLowerCase().charAt(0) - 'a') + 1;
      }
      String portName = Serial.list()[i-1];
      myPort = new Serial(this, portName, 9600); // change baud rate to your liking
      myPort.bufferUntil('\n'); // buffer until CR/LF appears, but not required..
    }
    else {
      showMessageDialog(frame,"Device is not connected to the PC");
      exit();
    }
  }
  catch (Exception e)
  { //Print the type of error
    showMessageDialog(frame,"COM port is not available (may\nbe in use by another program)");
    println("Error:", e);
    exit();
  }
}

void envoiTrame(int [] trameEnvoi) {
  for (int i = 0; i < trameEnvoi.length; i++) {
    byte octetSansSigne = unsignedByte(trameEnvoi[i]);
    myPort.write(octetSansSigne);
  }
}

int receptionTrame(){
  int retour = -1;
  if ( myPort.available() >= trameRecuA.length) { 
    int id = myPort.read();
    if (id == 65) {
      for (int i = 1; i<trameRecuA.length; i++) {
        int octetRecu = myPort.read();
        trameRecuA[i] = octetRecu;
      }
      retour = 65;
    }
    else if (id == 66) {
      for (int i = 1; i<trameRecuB.length; i++) {
        int octetRecu = myPort.read();
        trameRecuB[i] = octetRecu;
      }
      retour = 66;
    }
    else{
      println("trame recue non conforme");
      delay(3);
      myPort.clear();
      retour = -1;
    }
  }
  return retour;
}

byte unsignedByte( int val ) { 
  return (byte)( val > 127 ? val - 256 : val );
}