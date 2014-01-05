class Text {
  String text = "";
  String[] fontList;
  PFont font;
  String thisFont = "";
  PImage toReturn;
  ArrayList<String> wordArray = new ArrayList<String>();

  Text(String text_) {
    text = text_;
    ammendSearch(text);
    fontList = loadStrings("font/fontList.txt");
    thisFont = fontList[floor(random(fontList.length))];
    font = createFont(thisFont, floor(random(32, 72)));
  }

  void ammendSearch(String searchTerm) {
    int index = 0;
    //Make array with Cap words
    for (int k=0; k<searchTerm.length(); k++) {
      if (searchTerm.charAt(k) == ' ') {
        wordArray.add(searchTerm.substring(index, k));
        index = k+1;
      }
    }
    wordArray.add(searchTerm.substring(index, searchTerm.length()));
  }

  void display(int x, int y) {
    textFont(font);
    textSize(20);
    fill(255);
    text(text, x, y);
  }

  PImage makeImage(int colourSelect) {
    PGraphics textImg = createGraphics(pgX, pgY);
    textImg.beginDraw();
    //    textImg.fill(255);
    //    textImg.noStroke();
    //    textImg.rect(0,0,pgSize,pgSize);
    switch(colourSelect){
      case 0:
        //Black
        textImg.fill(255);
        break;
      case 52:
        //White
        textImg.fill(255);
        break;
      case 11:
        //Red
        textImg.fill(255,0,0);
        break;
      case 17:
        //Green
        textImg.fill(0,255,0);
        break;
      case 24:
        //Blue
        textImg.fill(0,0,255);
        break;
      case 28:
        //Yellow
        textImg.fill(255,255,0);
        break;
      case 41:
        //Cyan
        textImg.fill(0,255,255);
        break;
      case 35:
        //Magenta
        textImg.fill(255,0,255);
        break;
      default:
        textImg.fill(255);
        break;
    }
    textImg.textAlign(CENTER, CENTER);
    textImg.textFont(currentText.font);
    for(int i=0; i<wordArray.size(); i++){
      textImg.text(wordArray.get(i), pgX/2, (i+1)*(pgY/(wordArray.size()+1)));
    }
    textImg.endDraw();
    toReturn = textImg.get();
    return toReturn;
  }

  String getFont() {
    return thisFont;
  }
}

