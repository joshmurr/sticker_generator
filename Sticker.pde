class Sticker {

  String previousSearch, previousSearchNonFormat;
  PImage img, sticker, mask;
  int colours, textColour;
  Halftone halftone;
  Dither dither;

  Sticker(PImage img_, String prevSrch_, String prevSrchNFrmt_, int colours_, int textColour_) {
    previousSearch = prevSrch_;
    previousSearchNonFormat = prevSrchNFrmt_;
    colours = colours_;
    textColour = textColour_;
    println("Making Sticker for " + previousSearch);
    img = img_;
    mask = loadImage("bin/finalRoundDither.png");
    img.loadPixels();
    pg.beginDraw();
    
    dither = new Dither(img, currentText.makeImage(textColour), 1, colours, textColour);

    pg.image(dither.make(), 0, 0);
    int count = 0;
    for (int i=0; i<previousSearch.length(); i++) {
      if (previousSearch.charAt(i) == '+') count++;
    }
    previousSearch = remakeSearch(previousSearch, count);
    pg.endDraw();
    //pg.save("New/"+previousSearch+".png");
    sticker = pg.get();
    sticker.mask(mask);
    gallery.add(sticker);
    searched = false;
    sticked = true;
    saveSticker();
  }

  String remakeSearch(String search, int rounds) {
    String current = search;
    String remadeSearch = "";
    if (rounds == 0) {
      remadeSearch += str(current.charAt(0)).toUpperCase();
      remadeSearch += current.substring(1);
    } 
    else {
      for (int i=0; i<rounds; i++) {
        remadeSearch += str(current.charAt(0)).toUpperCase();
        remadeSearch += current.substring(1, current.indexOf('+'));
        remadeSearch += " ";
        remadeSearch += str(current.charAt(current.indexOf('+')+1)).toUpperCase();
        remadeSearch += current.substring(current.indexOf('+')+2, current.length());
      }
    }
    return remadeSearch;
  }

  void saveSticker() {
    // - /Users/joshmurr/desktop/print
    
    /* ?????????? DEBUGUGUGUGUGUGUGUGUGUGUGUGUUGUG ?????????? */
    print.addToPrintPage(sticker);
    /* ?????????? DEBUGUGUGUGUGUGUGUGUGUGUGUGUUGUG ?????????? */
    
    //println("Print Page has: " + print.printPage.size() + " stickers.");
    sticker.save("StickersSmall/"+previousSearch+".png");
  }
}

