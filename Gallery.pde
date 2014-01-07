
class Gallery {
  ArrayList<PImage> gallery = new ArrayList<PImage>();
  int x, y, xSize, ySize, scale, xBuffer, yBuffer;
  Gallery(int x_, int y_, int xSize_, int ySize_, int scale_) {
    x = x_;
    y = y_;
    xSize = xSize_;
    ySize = ySize_;
    scale = scale_;
    xBuffer = xSize/scale;
    yBuffer = ySize/scale;
  }

  void display() {
    for (int i=0; i<gallery.size(); i++) {
      if (i>=10) {
        image(gallery.get(i), x+(xBuffer*2), y+(yBuffer*(i%5)));
      }
      else if (i>=5) {
        image(gallery.get(i), x+xBuffer, y+(yBuffer*(i%5)));
      } 
      else {
        image(gallery.get(i), x, y+(yBuffer*i));
      }
    }
  }

  void add(PImage newSticker) {
    if (gallery.size() >= 15) {
      gallery.remove(0);
    }
    PImage temp = newSticker.get();
    temp.resize(xBuffer, 0);
    gallery.add(temp);
  }
}

