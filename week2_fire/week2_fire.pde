// Fire Photo by Guido Jansen on Unsplash
// https://unsplash.com/photos/Nz-zAt4qiuU

PImage img;

int pixelSize = 16;

void setup() {
  size(900, 600);
  background(0);
  noStroke();
  
  // Chinese support
  PFont font = createFont("SFPro-Black", pixelSize);
  textFont(font);

  img = loadImage("fire.jpg");
  img.loadPixels();
  
  int xstep = img.width / (width / pixelSize);
  int ystep = img.height / (height / pixelSize);
  
  for (int x = 0; x < img.width; x+= xstep) {
    for (int y = 0; y < img.height; y+= ystep) {
      color c = img.pixels[y * img.width + x];
      fill(c);
      
      float l = brightness(c);
      char t = '火';
      if (l > 200) t = '炎';
      if (l > 230) t = '焱';
      if (l > 254) t = '燚';
      
      //text(t, (x / xstep) * pixelSize, (y / ystep) * pixelSize);
      rect((x / xstep) * pixelSize, (y / ystep) * pixelSize, pixelSize, pixelSize);
    }
  }
  
  save("rect.png");
  //save("chinese.png");
}
