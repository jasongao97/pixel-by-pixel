// Scratch Painting by Jason Gao
//
// Noise part arranged from Noise2D by Daniel Shiffman
// https://processing.org/examples/noise2d.html

int[] colorBackground = new int[1000 * 800];
int[] mask = new int[1000 * 800];
int radius = 10;

float increment = 0.002;

void setup() {
  size(1000, 800);
  stroke(200);
  noFill();
  colorMode(HSB, 100);
  
  float xoff = 0.0;
  noiseDetail(8, 0.2);

  // generate random background with perlin noise
  for (int x = 0; x < width; x++) {
    xoff += increment;
    float yoff = 0.0;
    for (int y = 0; y < height; y++) {
      yoff += increment;
      
      float hue = map(noise(xoff + 10, yoff + 10), 0.2, 0.8, 0, 100);
      float saturation = noise(xoff + 20, yoff + 20) * 50 + 50;
      float brightness = noise(xoff, yoff) * 30 + 70;

      colorBackground[x + y * width]= color(hue, saturation, brightness);
      mask[x + y * width] = 0;
    }
  }

  background(0);
}

void draw() {
  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int index = x + y * width;
      if (mask[index] == 0) {
        pixels[index] = color(0);
      } else {
        pixels[index] = colorBackground[index];
      }
    }
  }
  updatePixels();

  // brush cursor - showing the size and position
  ellipse(mouseX, mouseY, radius * 2, radius * 2);
}

// drag to draw
void mouseDragged() {
  for (int x = -radius; x < radius; x++) {
    for (int y = -radius; y < radius; y++) {
      int X = mouseX + x;
      int Y = mouseY + y;
      // limit to circle
      if (x * x + y * y > radius * radius) continue;

      int pixelToDraw = (X + Y * width);
      if (pixelToDraw < height * width && pixelToDraw > 0) {
        mask[pixelToDraw] = 1;
      }
    }
  }
}

// scroll to change the brush size
void mouseWheel(MouseEvent event) {
  int offset = event.getCount();
  if (radius + offset < 5) {
    return;
  }
  radius += offset;
}
