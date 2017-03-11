public class Envoi {
  private int id;
  private boolean on = false;
  private int vMot = 100;
  private int pan = 100;
  private int tilt = 100;
  
  public Envoi(int id){
    this.id = id;
  }
  
  public int[] getTrame(){
    int[] retour = new int[5];
    retour[0] = id;
    retour[1] = int(on);
    retour[2] = vMot;
    retour[3] = pan;
    retour[4] = tilt;
    return retour;
  }
  
  public void setOn(boolean on1){
    this.on = on1;
  }
  
  public void setVMot(int vMot){
    this.vMot = vMot;
  }
  
  public void setPan(int pan){
    this.pan = pan;
  }
  
  public void setTilt(int tilt){
    this.tilt = tilt;
  }
  
  public int getVMot(){
    return this.vMot;
  }
  
}