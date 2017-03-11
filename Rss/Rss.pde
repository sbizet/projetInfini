import org.jsoup.*;
int nRss;
String[] motsALaUne;
long to;

void setup() {
  size(1200, 800);
  PFont police;
  police = loadFont("Elephant-Regular-96.vlw");
  textFont(police, 96);
  String [] urlsRss = loadStrings("urlsRss.txt");
  majRss(urlsRss);
  String [][] rss = getTitlesDescriptions(urlsRss);
  println ("nombre de titres : " + nRss);
  /*
  for (int i = 0; i<nRss ; i++){
   println("TITRE n° : " + i + "---" + rss[0][i] + "  " + rss[1][i]);
   println();
   }*/
  motsALaUne = motsClasse(rss, 50);
  println(motsALaUne);
  to = millis()-10000;
}

void draw() {
  if ((millis()-to)>3000) {
    background(0);
    int nMotsALaUne = motsALaUne.length;
    for (int i = 0; i< nMotsALaUne; i++) {
      fill(255, map(i, 0, nMotsALaUne, 255, 0));
      int size = int(map(i, 0, nMotsALaUne, 96, 12));
      textSize(size);
      text(motsALaUne[i], random(0, width), random(0, height));
    }
    to = millis();
  }
}

void majRss(String[] urlsRss) {
  for (int iRss = 0; iRss<urlsRss.length; iRss++) {
    String [] xmlTemp = loadStrings(urlsRss[iRss]);
    String [] xmlNull = new String[1];
    xmlNull[0]="";
    if (xmlTemp != null) {
      saveStrings("data/rssXML/rss"+nf(iRss, 2, 0)+".xml", xmlTemp);
    } else {
      saveStrings("data/rss/XML/rss"+nf(iRss, 2, 0)+".xml", xmlNull);
    }
  }
}

String [][] getTitlesDescriptions(String[] urlsRss) {
  nRss = 0;
  String [][] tab = new String [3][5000];
  for (int iRss = 0; iRss<urlsRss.length; iRss++) {
    XML rss = loadXML("rssXML/rss"+nf(iRss, 2, 0)+".xml");
    XML [] itemXML = rss.getChildren("channel/item");
    for (int j = 0; j < itemXML.length; j++) {
      String [] children = itemXML[j].listChildren();
      for (int c = 0; c < children.length; c++) {
        if (children[c].equals("title")) {
          tab[0][nRss] = html2text(itemXML[j].getChildren("title")[0].getContent());
        }
        if (children[c].equals("description")) {
          tab[1][nRss] = html2text(itemXML[j].getChildren("description")[0].getContent());
          int lMax = 280;
          if (tab[1][nRss].length()>lMax) {
            tab[1][nRss] = tab[1][nRss].substring(0, lMax) + " ... ";
          }
        }
      }
      XML channelTitleXML = rss.getChild("channel/title");
      tab[2][nRss] = html2text(channelTitleXML.getContent());
      nRss++;
    }
  }
  String [][] retour = new String [3][nRss];
  for (int n=0; n<nRss; n++) {
    retour[0][n] = tab[0][n];
    retour[1][n] = tab[1][n];
    retour[2][n] = tab[2][n];
  }
  return retour;
}

String html2text(String html) {
  return Jsoup.parse(html).text();
}

String [] motsClasse (String [][]rss, int l) {

  String tout = "";
  tout = join(rss[0], "\n\n") + join(rss[1], "\n\n");

  String [] mots = splitTokens(tout, " -.,;:?!\n\r\f\"()%\'");
  for (int i = 0; i<mots.length; i++) {
    String mot = mots[i].toLowerCase();
    mots[i] = mot;
  }
  mots = sort(mots);

  int [] nMot = new int [mots.length];
  String [] motCompte = new String [mots.length];
  int n = 0;
  for (int i = 1; i<mots.length; i++) {
    if (mots[i-1].equals(mots[i]) && mots[i].length()>2) {
      nMot[n]++;
    } else {
      n++;
      motCompte[n] = mots[i];
    }
  }

  String lesMots = "";
  for (int i = 0; i<n; i++) {
    if (nMot[i]>3) {
      if (motInteressant(motCompte[i])) {
        lesMots = lesMots + nf(nMot[i], 4, 0) + motCompte[i] + " ";
      }
    }
  }

  String [] lesMotsCoupe = splitTokens(lesMots, " ");
  lesMotsCoupe = reverse(sort(lesMotsCoupe));
  if (l>lesMotsCoupe.length) l=lesMotsCoupe.length;
  String [] retour = new String[l];
  for (int i = 0; i<l; i++) {
    retour[i] = lesMotsCoupe[i].substring(4);
  }
  return retour;
}

boolean motInteressant(String mot) {
  boolean retour = true;
  String [] motsBannis = {"vous","premier","point","pays","plusieurs","personnes","selon","figaro", "alors", "vers", "cette", "ils", "lors", "quatre", "vue", "vient", "vie", "très", "trois", "près", "devant", "mois", "20minutes", "nous", "avait", "\"", "c", "comme", "depuis", "elle", "encore", "mais", "sans", "sont", "avant", "avoir", "mis", "tout", "tous", "si", "ont", "nouveau", "va", "qu", "être", "je", "leur", "n", "entre", "face", "aussi", "toujours", "ne", "000", "al", "bas", "c'est", "deux", "doit", "faire", "été", "ans", "avec", "ce", "comment", "fait", "homme", "il", "on", "pas", "plus", "que", "sa", "se", "ses", "sous", "veut", "après", "le", "a", "la", "les", "son", "à", "l", "par", "en", "est", "qui", "pour", "au", "aux", "contre", "d", "dans", "de", "des", "du", "et", "s", "sur", "un", "une", "vu"};
  for (int i = 0; i< motsBannis.length; i++) { 
    if (mot.equals(motsBannis[i])) {
      retour = false;
    }
  }
  return retour;
}