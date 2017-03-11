static class Structure { 
  public float l = 2; // la longueur des parties linéaires du rail en m
  public float R = 0.6; // le rayon des cercles en m
  public float echelle = 200; // en pixel par m

  public float alpha = atan(2*R/l); // pente en rad de la partie linéaire
  public float xc = sqrt(R*R+(l/2)*(l/2)); // abscisse du centre du cercle
  
}