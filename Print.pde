class Print {
  ArrayList<PImage> printArray = new ArrayList<PImage>();
  String name = str(floor(random(1000)))+".pdf";
  PGraphics printPage = createGraphics(840, 1188, PDF, name); //A4 * 4
  int cols, rows, originalSize, sizeY, sizeX, numStickers, buffer;
  int spacer = 52; //13mm
  int top = 28, bottom = 12; //7mm 3mm - Difference between print area, and sticker area
  int left = 8; //2mm

  Print(int originalSize_, int cols_, int rows_) {
    originalSize = originalSize_;
    println("Original Size: " + originalSize);
    cols = cols_;
    rows = rows_;
    numStickers = cols * rows;
    sizeY = (printPage.height - top - bottom)/rows;
    println("New size: " + sizeY);
    sizeX = (printPage.width - left)/cols;
    buffer = printPage.width/cols;
  }

  void addToPrintPage(PImage img) {
    if (printArray.size() < numStickers) {
      printArray.add(img);
    } 
    else {
      makePageForPrint();
    }
  }

  void addToPrintPageDebug(PImage img) {
    for (int i=0; i<numStickers; i++) {
      printArray.add(img);
    }
    makePageForPrint();
  }

  void makePageForPrint() {
    printPage.beginDraw(); 
    for (int i=0; i<numStickers; i++) {
      PImage stickerResize = printArray.get(i).get();
      //stickerResize.resize(0, sizeY);
      if (i>=rows*2) {
        printPage.image(stickerResize, (2.5*buffer)-sizeX/2, (sizeY*(i%rows))+top);
      } 
      else if (i>=rows) {
        printPage.image(stickerResize, (1.5*buffer)-sizeX/2, (sizeY*(i%rows))+top);
      } 
      else {
        printPage.image(stickerResize, (0.5*buffer)-sizeX/2, (sizeY*i)+top);
      }
    }
    printPage.dispose();
    printPage.endDraw();
    //printPage.save("PrintPages/"+floor(random(100))+".png");
    printArray.clear();
    println("==========================");
    println("| Saved a page for Print |");
    println("==========================");
  }
}

