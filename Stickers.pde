import processing.pdf.*;
import controlP5.*;
import java.io.File;

ControlP5 cp5;
CheckBox checkbox, coloursBoxes;
PFont Andale, stickerFont;
boolean searched, sticked, searching = false;
String currentSearchTerm = "";
String errors = "";
PGraphics pg;
Search currentSearch;
Sticker currentSticker;
Text currentText;
Gallery gallery;
Print print;

int setColour = 0;
int textColour = 0;
int pgSize = 200;
//int pgX = 256, pgY = 136;
int pgX = 273, pgY = 273; //(+19)
color textColourDisplay;

void setup() {
  size(1200, 800);
  frame.setResizable(true);
  Andale = createFont("AndaleMono", 10, false);
  gallery = new Gallery(700, 30, pgX, pgY, 2);
  print = new Print(pgY, 3, 4, pgX, pgY);
  textColourDisplay = color(0, 0, 0);
  cp5 = new ControlP5(this);

  cp5.addTextfield("search")
    .setPosition(20, 50)
      .setSize(200, 13)
        .setFont(Andale)
          .setFocus(true)
            .keepFocus(true)
              .setColor(color(255));

  cp5.addBang("makeSticker")
    .setPosition(20, 550)
      .setSize(200, 13)
        .setTriggerEvent(Bang.RELEASE)
          .setLabel("Make Sticker");

  cp5.addBang("research")
    .setPosition(20, 80)
      .setSize(200, 13)
        .setTriggerEvent(Bang.RELEASE)
          .setLabel("Search Again");

  checkbox = cp5.addCheckBox("checkBox")
    .setPosition(20, 520)
      .setColorForeground(color(120))
        .setColorLabel(color(255))
          .setSize(10, 10)
            .setItemsPerRow(3)
              .setSpacingColumn(30)
                .setSpacingRow(20)
                  .addItem("Colour Image", 1);

  coloursBoxes = cp5.addCheckBox("coloursBoxes")
    .setPosition(120, 520)
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
  background(100);
  textFont(Andale);
  fill(255);
  text("Sticker Generator v0.1a", 20, 20);
  text("by Josh Murr", 20, 37);
  text("— Press Enter", 56, 75);
  fill(255, 0, 0);
  text(errors, 20, 120, 200, 140);
  noStroke();
  fill(textColourDisplay);
  rect(20, 535, 200, 10);
  fill(255);
  text("Text Colour:", 120, 512);
  if (searched) {
    pg = createGraphics(pgX, pgY);
    image(currentSearch.img, 20, 160, currentSearch.neww, currentSearch.newh);
    text(currentText.getFont(), 20, 430);
    currentText.display(20, 460);
  }
  if (sticked) {
    PImage display = currentSticker.sticker.get();
    display.resize(pgX*2, 0);
    image(display, 250, 20);
  }
  gallery.display();
}

public void search(String searchValue_) {
  currentSearchTerm = searchValue_;
  currentSearch = new Search(searchValue_);
  currentText = new Text(searchValue_);
  println("Searching for " + searchValue_);
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

public void makeSticker() {
  if (searched) {
    currentSticker = new Sticker(currentSearch.img, currentSearch.previousSearch, currentSearch.previousSearchNonFormat, setColour, textColour);
  }
  else {
    errors = "Search First";
    return;
  }
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(checkbox)) {
    //println("Event from checkbox");
    setColour = 0;
    //print("got an event from "+checkbox.getName()+"\t\n");
    // checkbox uses arrayValue to store the state of 
    // individual checkbox-items. usage:
    //println(checkbox.getArrayValue());
    int col = 0;
    for (int i=0;i<checkbox.getArrayValue().length;i++) {
      int n = (int)checkbox.getArrayValue()[i];
      //print(n);
      if (n==1) {
        setColour = (int)checkbox.getItem(i).internalValue();
      }
    }
    //println();
  } 
  else {
    //println("Event from text colours");
    textColour = 0;
    //println(coloursBoxes.getArrayValue());
    for (int i=0;i<coloursBoxes.getArrayValue().length;i++) {
      int n = (int)coloursBoxes.getArrayValue()[i];
      //println(n);
      if (n==1) {
        textColour += coloursBoxes.getItem(i).internalValue();
      }
    }
    //println("Text Colour = " + textColour);
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

