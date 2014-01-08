class Print {
  ArrayList<PImage> printArray = new ArrayList<PImage>();
  String print = "/Users/joshmurr/desktop/print/";
  String name = str(floor(random(1000)));
  String extension = ".pdf";
  PGraphics printPage = createGraphics(860, 1151); //, PDF, print+name+extension); PRINT AREA: MM > PX
  int cols, rows, sizeY, sizeX, numStickers;
  int dividerHori = 290, dividerVert = 294;
  String isPrinting = "";
  PImage savedImg;

  Print(int cols_, int rows_, int sizeX_, int sizeY_) {
    cols = cols_;
    rows = rows_;
    numStickers = cols * rows;
    sizeX = sizeX_;
    sizeY = sizeY_;
  }

  void addToPrintPage(PImage img) {
    if (printArray.size() < numStickers) {
      isPrinting = "";
      printArray.add(img);
    } 
    else {
      isPrinting = "Sheet sent to Print";
      savedImg = img.get();
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
      PImage sticker = printArray.get(i).get();
      //Do no resize anything now, it fucks the print quality.
      if (i>=rows*2) {
        //RIGHT
        printPage.image(sticker, (printPage.width/2)-(sizeX/2)+dividerHori, (dividerVert*(i%rows)));
      } 
      else if (i>=rows) {
        //MIDDLE
        printPage.image(sticker, (printPage.width/2)-sizeX/2, (dividerVert*(i%rows)));
      } 
      else {
        //LEFT
        printPage.image(sticker, (printPage.width/2)-(sizeX/2)-dividerHori, (dividerVert*i));
      }
    }
    //printPage.dispose();
    printPage.endDraw();
    printPage.save(print+str(floor(random(1000)))+".png");
    printArray.clear();
    printArray.add(savedImg);
    
    println("==========================");
    println("| Saved a page for Print |");
    println("==========================");
  }
}

