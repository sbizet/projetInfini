public class Scenario {
  private int id = 0;
  private int vMotA = 60;
  private int vMotB = 50;

  public void setId(int id) {
    init();
    this.id = id;
  }

  public int getId() {
    return this.id;
  }

  public void init() {
    if (id == 1) {
      vMotA = 60;
      vMotB = 50;
    }
  }

  public void update() {
    if (id == 1) {
      setVMot('A', vMotA);
      setVMot('B', vMotB);
      if (getDistanceAB() > 0 && getDistanceAB() < 0.2) {
        vMotA = 60;
        vMotB = 50;
      }
      if (getDistanceAB() < 0 && getDistanceAB() > -0.2) {
        vMotA = 50;
        vMotB = 60;     
      }
    }
  }

  private void setVMot(int idChariot, int vMot) {
    if (idChariot == 65) {
      envoiA.setVMot(vMot);
      GUIvMotA.setValue(vMot);
    }
    if (idChariot == 66) {
      envoiB.setVMot(vMot);
      GUIvMotB.setValue(vMot);
    }
  }
  private float getDistanceAB() {
    return (chariotA.getDistance()-chariotB.getDistance());
  }
}