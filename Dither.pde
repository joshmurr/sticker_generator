class Dither {
  color[] colorPalette = new color[] {
    color(0, 0, 0), 
    color(0, 0, 255), 
    color(0, 255, 0), 
    color(0, 255, 255), 
    color(255, 0, 0), 
    color(255, 0, 255), 
    color(255, 255, 0), 
    color(255, 255, 255)
  };

  color[] greyPalette = new color[] {
    color(0), 
    color(64), 
    color(128), 
    color(182), 
    color(255)
  };

  color[] bwPalette = new color[] {
    color(0, 0, 0), 
    color(255, 255, 255)
  };

  color[] rbPalette = new color[] {
    color(255, 0, 0), 
    color(0, 0, 255)
  };

  color[] gpPalette = new color[] {
    color(0, 255, 189), 
    color(255, 0, 162)
  };

  color[] rPalette = new color[] {
    color(round(random(255)), round(random(255)), round(random(255))), 
    color(round(random(255)), round(random(255)), round(random(255))), 
    color(round(random(255)), round(random(255)), round(random(255))), 
    color(round(random(255)), round(random(255)), round(random(255))), 
    color(round(random(255)), round(random(255)), round(random(255))), 
    color(round(random(255)), round(random(255)), round(random(255)))
  };

  PImage img, textImg;

  int w, h;
  float scale;
  int colours, textColour;

  Dither(PImage img_, PImage textImg_, float scale_, int colours_, int textColour_) {
    img = img_;
    textImg = textImg_;
    textColour = textColour_;
    scale = scale_;
    colours = colours_;
    if (img.width < img.height) {
      img.resize(pgX, 0);
    } 
    else {
      try {
        img.resize(0, pgY);
      } 
      catch (Exception e) {
        errors = "Image error";
        PImage newImg = createImage(pgX, pgY, RGB);
        newImg.loadPixels();
        int rr = (random(1) < 0.5) ? 0 : 255;
        int rg = (random(1) < 0.5) ? 0 : 255;
        int rb = (random(1) < 0.5) ? 0 : 255;
        for (int p=0; p<newImg.pixels.length; p++) {
          newImg.pixels[p] = color(rr, rg, rb);
        }
        newImg.updatePixels();
        img = newImg.get();
      }
    }

    //img.resize(pgX, 0);
    //ADD TEXT IMAGE:
    if (textColour > 0 && textColour < 52) {
      img.blend(textImg, 0, 0, pgX, pgY, 0, 0, pgX, pgY, BLEND);
    } 
    else {
      img.blend(textImg, 0, 0, pgX, pgY, 0, 0, pgX, pgY, DIFFERENCE);
    }
    img.loadPixels();
    w = img.width;
    h = img.height;
  }

  PImage make() {
    color[][] p = new color[h][w];
    float s = 7.0/16;
    float t = 3.0/16;
    float f = 5.0/16;
    float o = 1.0/16;

    for (int y=0; y<h; y++) {
      for (int x=0; x<w; x++) {
        p[y][x] = img.pixels[y*w+x];
      }
    }


    for (int y=0; y<h; y++) {
      for (int x=0; x<w; x++) {
        color oldP = p[y][x];
        color newP;
        if (colours == 1) {
          newP = find_new_color(oldP, colorPalette);
        } 
        else {
          newP = find_new_color(oldP, bwPalette);
        }
        p[y][x] = newP;

        img.pixels[y*w+x] = p[y][x];

        float qr = red(oldP) - red(newP);
        float qg = green(oldP) - green(newP);
        float qb = blue(oldP) - blue(newP);

        if (x+1 < w) {
          float nr = (p[y][x+1] >> 16 & 0xFF) + s * qr;
          float ng = (p[y][x+1] >> 8 & 0xFF) + s * qg;
          float nb = (p[y][x+1] & 0xFF) + s * qb;
          p[y][x+1] = color(nr, ng, nb);
        }

        if (x-1>=0 && y+1<h) {
          float nr = (p[y+1][x-1] >> 16 & 0xFF) + t * qr;
          float ng = (p[y+1][x-1] >> 8 & 0xFF) + t * qg;
          float nb = (p[y+1][x-1] & 0xFF) + t * qb;
          p[y+1][x-1] = color(nr, ng, nb);
        }
        if (y+1 < h) {
          float nr = (p[y+1][x] >> 16 & 0xFF) + f * qr;
          float ng = (p[y+1][x] >> 8 & 0xFF) + f * qg;
          float nb = (p[y+1][x] & 0xFF) + f * qb;
          p[y+1][x] = color(nr, ng, nb);
        }
        if (x+1<w && y+1<h) {
          float nr = (p[y+1][x+1] >> 16 & 0xFF) + o * qr;
          float ng = (p[y+1][x+1] >> 8 & 0xFF) + o * qg;
          float nb = (p[y+1][x+1] & 0xFF) + o * qb;
          p[y+1][x+1] = color(nr, ng, nb);
        }
      }
    }

    img.updatePixels();
    if (colours == 0 && textColour > 0 && textColour < 52) {
      img.blend(textImg, 0, 0, pgX, pgY, 0, 0, pgX, pgY, BLEND);
    }
    return img;
  }

  color find_new_color(color c, color[] palette) {
    int bestIndex = 0;

    PVector[] vpalette = new PVector[palette.length];
    PVector vcolor = new PVector((c >> 16 & 0xFF), (c >> 8 & 0xFF), (c & 0xFF));
    float distance = vcolor.dist(new PVector(0, 0, 0));

    for (int i=0; i<palette.length; i++) {
      vpalette[i] = new PVector((palette[i] >> 16 & 0xFF), (palette[i] >> 8 & 0xFF), (palette[i] & 0xFF));
      float d = vcolor.dist(vpalette[i]);
      if (d < distance) {
        distance = d;
        bestIndex = i;
      }
    }
    return palette[bestIndex];
  }
}

