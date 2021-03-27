// Muscle Man image from
// https://www.searchpng.com/2019/10/06/bodybuilder-without-face-png-free-download/

import processing.video.*;
import gab.opencv.*;
import java.awt.*;

Capture video;
OpenCV opencv;

PImage img;

void setup() {
  size(640, 480);

  video = new Capture(this, width, height, "FaceTime HD Camera (Built-in)");
  opencv = new OpenCV(this, width, height);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  video.start();

  img = loadImage("muscle-man.png");
  img.resize(width, height);
}

void draw() {
  if (video.available())  video.read();
  opencv.loadImage(video);
  image(video, 0, 0);

  Rectangle[] faces = opencv.detect();

  if (faces.length > 0) {
    for (int i = 0; i < faces.length; i++) {
      float scale = float(faces[i].width) / 180;
      int x = faces[i].x - int(240 * scale);
      int y = faces[i].y + faces[i].height - int(150 * scale);
      image(img, x, y, int(width * scale), int(height * scale));
    }
  }
}
