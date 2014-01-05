
class Gallery {
  ArrayList<PImage> gallery = new ArrayList<PImage>();
  int x, y, xOver2, yOver2;
  Gallery(int x_, int y_) {
    x = x_;
    y = y_;
    xOver2 = x_/4;
    yOver2 = y_/4;
  }

  void display() {
    for (int i=0; i<gallery.size(); i++) {
      if (i>=5) {
        image(gallery.get(i), x+xOver2, y+(yOver2*(i%5)));
      } 
      else {
        image(gallery.get(i), x, y+(yOver2*i));
      }
    }
  }

  void add(PImage newSticker) {
    if(gallery.size() >= 10){
      gallery.remove(0);
    }
    PImage temp = newSticker.get();
    temp.resize(xOver2, 0);
    gallery.add(temp);
  }
}

