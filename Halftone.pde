class Halftone {
  PImage img;
  int w, h;
  int p = 10;
  Halftone(PImage img_, int w_, int h_) {
    img = img_;
    w = w_;
    h = h_;
  }

  void make() {
    noStroke();
    fill(0);
    rect(0, 0, w, h);
    fill(255);
    for (int j=0; j<img.width; j+=(p-2)) {
      for (int k=0; k<img.height; k+=(p-2)) {
        int loc = j+k*img.width;
        float r = (brightness(img.pixels[loc])/255.0)*p;
        ellipse(j+p/2, k+p/2, r, r);
      }
    }
  }
}

