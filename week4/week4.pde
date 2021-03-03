// Week4 Exercise - Wave
// !!! Dizzness Warning !!!
//
// Arranged from Example by Daniel Rozin
// https://github.com/dannyrozin/PxP-week-4

int R, G, B, A;
float offset = 0.0;
boolean mousePress = false;
PImage ourImage;

void setup() {
  size(640, 480);
  frameRate(120);
  ourImage = loadImage("alexander-ant-gnCmc_QHVTc-unsplash.jpg");
  ourImage.resize(width, height);
  ourImage.loadPixels();
}

float graph(float input) {
  return 1 + sin(input) / 3;
}

void draw() {
  loadPixels();

  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      // get original pixel data
      PxPGetPixel(x, y, ourImage.pixels, width);

      float distance = dist(x, y, mouseX, mouseY) / 8;
      // float angle = mouseX != x ? atan(float(y - mouseY) / float(x - mouseX)) : 0;

      // calculate pixel's RGB
      int tempR = int(R * graph(distance + offset));
      int tempG = int(G * graph((distance + offset) * 1.1));
      int tempB = int(B * graph((distance + offset) * 1.2));

      // constrain the value to a valid range
      tempR = constrain(tempR, 0, 255);
      tempG = constrain(tempG, 0, 255);
      tempB = constrain(tempB, 0, 255);
      // set new pixel
      PxPSetPixel(x, y, tempR, tempG, tempB, 255, pixels, width);
    }
  }

  updatePixels();
  if (mousePress) {
    offset += 1;
  }
}

void mousePressed() {
  mousePress = true;
}

void mouseReleased() {
  mousePress = false;
}

// our function for getting color components , it requires that you have global variables
// R,G,B   (not elegant but the simples way to go, see the example PxP methods in object for 
// a more elegant solution

void PxPGetPixel(int x, int y, int[] pixelArray, int pixelsWidth) {
  int thisPixel=pixelArray[x+y*pixelsWidth];     // getting the colors as an int from the pixels[]
  A = (thisPixel >> 24) & 0xFF;                  // we need to shift and mask to get each component alone
  R = (thisPixel >> 16) & 0xFF;                  // this is faster than calling red(), green() , blue()
  G = (thisPixel >> 8) & 0xFF;   
  B = thisPixel & 0xFF;
}

//our function for setting color components RGB into the pixels[] , we need to efine the XY of where
// to set the pixel, the RGB values we want and the pixels[] array we want to use and it's width

void PxPSetPixel(int x, int y, int r, int g, int b, int a, int[] pixelArray, int pixelsWidth) {
  a =(a << 24);                       
  r = r << 16;                       // We are packing all 4 composents into one int
  g = g << 8;                        // so we need to shift them to their places
  color argb = a | r | g | b;        // binary "or" operation adds them all into one int
  pixelArray[x+y*pixelsWidth]= argb;    // finaly we set the int with te colors into the pixels[]
}
