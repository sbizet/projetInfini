public class Recu {
  private int id;
  private int vBat = 200;
  private int inclinaison = 150;
  private int wr = 100;
  private int choc = 0;
  private int lTrame = 5;
  private Table table;
  
  public Recu(int id){
    this.id = id;
    table = new Table();
    table.addColumn("n");
    table.addColumn("id");
    table.addColumn("vBat");
    table.addColumn("inclinaison");
    table.addColumn("wr");
    table.addColumn("choc");
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
  
  public void nouvelleTrame(){
    if (id == 65){
      chariotA.update();
    }
    if (id == 66){
      chariotB.update();
    }
    TableRow newRow = table.addRow();
    newRow.setInt("n", table.getRowCount() - 1);
    newRow.setInt("id", id);
    newRow.setInt("vBat", vBat);
    newRow.setInt("inclinaison", inclinaison);
    newRow.setInt("wr", wr);
    newRow.setInt("choc", choc);
    if (table.getRowCount()>200){
      saveTable(table,"logEnvoiA"+millis()/1000+".csv");
      table.clearRows();
    }
  }
}