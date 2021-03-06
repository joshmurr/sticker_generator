import processing.pdf.*;
import controlP5.*;
import java.io.File;

ControlP5 cp5;
CheckBox checkbox, coloursBoxes;
PFont Andale, stickerFont;
boolean searched, sticked, random, automated = false;
String currentSearchTerm = "";
String errors = "";
String[] randomWords;
PGraphics pg;
Search currentSearch;
Sticker currentSticker;
Text currentText;
Gallery gallery;
Print print;

int automateCount = 13;

int infoFill = 0;
String info = "The software is reasonably stable, but not perfect. It requires an internet connection, so if there a long periods where nothing seems to happen, it may because the internet connection has been lost.\nThe source code is available here: https://github.com/joshmurr/sticker_generator\nIf it does freeze, close (ESC) and re-run (press the PLAY button in Processing).";

int setColour = 0;
int textColour = 0;
int pgSize = 200;
//int pgX = 256, pgY = 136;
int pgX = 273, pgY = 273;
color textColourDisplay;

void setup() {
  size(displayWidth, displayHeight);
  //size(1200,800);
  Andale = createFont("AndaleMono", 10, false);
  gallery = new Gallery(700, 50, pgX, pgY, 2);
  print = new Print(3, 4, pgX, pgY);
  textColourDisplay = color(0, 0, 0);
  randomWords = loadStrings("bin/words.txt");
  cp5 = new ControlP5(this);

  cp5.addTextfield("search")
    .setPosition(20, 50)
      .setSize(200, 13)
        .setFont(Andale)
          .setFocus(true)
            .keepFocus(true)
              .setColor(color(255));

  cp5.addBang("research")
    .setPosition(20, 80)
      .setSize(200, 13)
        .setTriggerEvent(Bang.RELEASE)
          .setLabel("Search Again");

  cp5.addBang("randomSearch")
    .setPosition(20, 110)
      .setSize(200, 13)
        .setTriggerEvent(Bang.RELEASE)
          .setLabel("Random");

  cp5.addBang("makeSticker")
    .setPosition(20, 185)
      .setSize(200, 13)
        .setTriggerEvent(Bang.RELEASE)
          .setLabel("Make Sticker");

  cp5.addBang("automate")
    .setPosition(20, 550)
      .setSize(200, 13)
        .setTriggerEvent(Bang.RELEASE)
          .setLabel("Automate");

  cp5.addBang("info")
    .setPosition(20, 580)
      .setSize(13, 13)
        .setTriggerEvent(Bang.RELEASE)
          .setLabel("Info");

  checkbox = cp5.addCheckBox("checkBox")
    .setPosition(20, 155)
      .setColorForeground(color(120))
        .setColorLabel(color(255))
          .setSize(10, 10)
            .setItemsPerRow(3)
              .setSpacingColumn(30)
                .setSpacingRow(20)
                  .addItem("Colour Image", 1);

  coloursBoxes = cp5.addCheckBox("coloursBoxes")
    .setPosition(120, 155)
      .setColorForeground(color(120))
        .setColorLabel(color(255))
          .setSize(10, 10)
            .setItemsPerRow(3)
              .setSpacingColumn(30)
                .setSpacingRow(20)
                  .addItem("R", 11)
                    .addItem("G", 17)
                      .addItem("B", 24);
}

void draw() {
  background(0);
  textFont(Andale);
  fill(255);
  text("Sticker Generator v0.1a\nby Josh Murr", 20, 20);
  text("— Press Enter", 56, 75);
  fill(255, 0, 0);
  text(errors, 20, 530, 200, 140);
  noStroke();
  fill(textColourDisplay);
  rect(20, 170, 200, 10);
  fill(255);
  text("Text Colour:", 120, 150);
  fill(255, 0, 0);
  text(print.isPrinting, 300, 560);
  fill(infoFill);
  text(info, 20, 615, 700, 680);
  fill(255);
  if (searched) {
    pg = createGraphics(pgX, pgY);
    //Sticker Pre-Preview
    image(currentSearch.img, 20, 225, currentSearch.neww, currentSearch.newh);
    text(currentText.getFont(), 20, 450);
    currentText.display(20, 470);
    if (automated) {
      makeSticker();
    }
  }
  if (sticked) {
    PImage display = currentSticker.sticker.get();
    display.resize(pgX, 0);
    textFont(Andale);
    text("Current Sticker:", 300, 20);
    text("Previous Stickers:", 700, 20);
    //Main Sticker Preview
    image(display, 300, 50);
  }
  gallery.display();
  if (automated) {
    automateCount--;
    if (automateCount > 0) {
      automate();
    } 
    else {
      //Now 12 becuase there is a sticker already in the printArray
      automateCount = 12;
      automated = false;
    }
  }
}

public void search(String searchValue_) {
  currentSearchTerm = searchValue_;
  currentSearch = new Search(searchValue_);
  currentText = new Text(searchValue_);
  println("Searching for " + searchValue_);
}

public void randomSearch() {
  random = true;
  currentSearchTerm = randomWords[floor(random(randomWords.length))];
  coloursBoxes.toggle(round(random(2)));
  checkbox.toggle(round(random(1)));
  currentSearch = new Search(currentSearchTerm);
  currentText = new Text(currentSearchTerm);
  println("Searching for " + currentSearchTerm);
}

public void research() {
  try {
    currentSearch = new Search(currentSearchTerm);
    currentText = new Text(currentSearchTerm);
    println("Searching for " + currentSearchTerm);
  } 
  catch (Exception e) {
    errors = "Enter a Search Term";
    return;
  }
}

public void automate() {
  currentSearchTerm = randomWords[floor(random(randomWords.length))];
  coloursBoxes.toggle(round(random(2)));
  checkbox.toggle(round(random(1)));
  currentSearch = new Search(currentSearchTerm);
  currentText = new Text(currentSearchTerm);
  automated = true;
  println("Searching for " + currentSearchTerm);
}

public void makeSticker() {
  if (searched) {
    currentSticker = new Sticker(currentSearch.img, currentSearch.previousSearch, currentSearch.previousSearchNonFormat, setColour, textColour);
  }
  else {
    errors = "Search First";
    return;
  }
}

public void info() {
  if (infoFill == 255) infoFill = 0;
  else infoFill = 255;
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(checkbox)) {
    setColour = 0;
    int col = 0;
    for (int i=0;i<checkbox.getArrayValue().length;i++) {
      int n = (int)checkbox.getArrayValue()[i];
      if (n==1) {
        setColour = (int)checkbox.getItem(i).internalValue();
      }
    }
  } 
  else {
    textColour = 0;
    for (int i=0;i<coloursBoxes.getArrayValue().length;i++) {
      int n = (int)coloursBoxes.getArrayValue()[i];
      if (n==1) {
        textColour += coloursBoxes.getItem(i).internalValue();
      }
    }
    updateTextColourDisplay(textColour);
  }
}

void updateTextColourDisplay(int num) {
  switch(num) {
  case 0:
    //Black
    textColourDisplay = color(0);
    break;
  case 52:
    //White
    textColourDisplay = color(0);
    break;
  case 11:
    //Red
    textColourDisplay = color(255, 0, 0);
    break;
  case 17:
    //Green
    textColourDisplay = color(0, 255, 0);
    break;
  case 24:
    //Blue
    textColourDisplay = color(0, 0, 255);
    break;
  case 28:
    //Yellow
    textColourDisplay = color(255, 255, 0);
    break;
  case 41:
    //Cyan
    textColourDisplay = color(0, 255, 255);
    break;
  case 35:
    //Magenta
    textColourDisplay = color(255, 0, 255);
    break;
  default:
    textColourDisplay = color(0);
    break;
  }
}

void coloursBoxes(float[] a) {
  //println(a);
}

