// Week5 Exercise - RGB Paint
// Paint on a shader filter
//
// Arranged from Example by Daniel Rozin
// https://github.com/dannyrozin/shaders-area-effecs

int R, G, B, A;
int radius = 10;
PImage myImage;
PShader myFragShader;

void setup() {
  size(800, 800, P2D);
  frameRate(400);
  myFragShader = loadShader("FragShaderEdgeDetection.glsl");
  myImage = loadImage("liza-azorina.jpg");
  myImage.resize(width, height);
}

void draw() {
  image(myImage, 0, 0);

  stroke(255);
  noFill();
  // brush cursor - showing the size and position
  ellipse(mouseX, mouseY, radius * 2, radius * 2);
  
  shader(myFragShader);
}

// drag to draw
void mouseDragged() {
  myImage.loadPixels();
  for (int x = -radius; x < radius; x++) {
    for (int y = -radius; y < radius; y++) {
      int X = mouseX + x;
      int Y = mouseY + y;
      // limit to circle
      if (x * x + y * y > radius * radius) continue;
      if (Y >= height || Y < 0 || X < 0 || X >= width) continue;
      
      PxPGetPixel(X, Y, myImage.pixels, width);
      
      // calculate pixel's RGB
      int tempR = R < 128 ? R - 2 : R + 2;
      int tempG = G < 128 ? G - 2 : G + 2;
      int tempB = B < 128 ? B - 2 : B + 2;
      
      // constrain the value to a valid range
      tempR = constrain(tempR, 0, 255);
      tempG = constrain(tempG, 0, 255);
      tempB = constrain(tempB, 0, 255);
      
      PxPSetPixel(X, Y, tempR, tempG, tempB, 255, myImage.pixels, width);
    }
  }
  myImage.updatePixels();
}

// scroll to change the brush size
void mouseWheel(MouseEvent event) {
  int nextRadius = radius + event.getCount();
  if (nextRadius < 5 || nextRadius > 200) {
    return;
  }
  radius = nextRadius;
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
