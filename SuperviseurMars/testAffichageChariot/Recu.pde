public class Recu {
  private int id;
  private int vBat = 200;
  private int inclinaison = 150;
  private int wr = 100;
  private int choc = 0;
  private int lTrame = 5;
  
  private long to = millis();
  private int nRow = 0;
  
  public Recu(int id){
    this.id = id;
    
  }
  
  public void simulTrame(){
    if ((millis()-to)>100){
      id = table.getInt(nRow,"id");
      vBat = table.getInt(nRow,"vBat");
      inclinaison = table.getInt(nRow,"inclinaison");
      wr = table.getInt(nRow,"wr");
      choc = table.getInt(nRow,"choc");
      nRow++;
      if (nRow == table.getRowCount()) nRow = 0;
      to=millis();
    }
  }
  
  public int[] getTrame(){
    int[] retour = new int[lTrame];
    retour[0] = id;
    retour[1] = vBat;
    retour[2] = inclinaison;
    retour[3] = wr;
    retour[4] = choc;
    return retour;
  }

  public void setTrame(int i, int valeur){
    if (i == 0) this.id = valeur;
    if (i == 1) this.vBat = valeur;
    if (i == 2) this.inclinaison = valeur;
    if (i == 3) this.wr = valeur;
    if (i == 4) this.choc = valeur;
  }
  
  public void setVBat(int vBat){
    this.vBat = vBat;
  }
  
  public void setInclinaison(int inclinaison){
    this.inclinaison = inclinaison;
  }
  
  public void setWr(int wr){
    this.wr = wr;
  }
  
  public void setChoc(int choc){
    this.choc = choc;
  }
  
  public int getVBat(){
    return this.vBat;
  }
  public int getInclinaison(){
    return this.inclinaison;
  }
  public int getWr(){
    return this.wr;
  }
  
  public int getChoc(){
    return this.choc;
  }
  
  public int getlTrame(){
    return this.lTrame;
  }
  
  
}