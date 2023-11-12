import oscP5.*;
import netP5.*;
import processing.core.*;
import processing.serial.*;
import java.util.Iterator;


OscP5 oscP5;
Serial arduinoPort;
String portName = "/dev/cu.usbmodem11201"; 

PVector objectPosition = new PVector(0, 0, 0);
ArrayList<DisplayObject> displayObjects = new ArrayList<DisplayObject>();
boolean personDetected = false;

int imageSize = 100;
int imageSpacing = 50;
int windowMargin = 100;
int numRows = 4;
int numCols = 4;

color[] colArray = {
  color(255, 255, 255),
  color(111, 255, 81),
  color(73, 159, 107),
  color(122, 213, 64),
  color(25, 57, 97),
  color(133, 203, 238),
  color(96, 248, 255),
};

int grid = 100;
int margin = 150;
int currentRow = 0;
int currentCol = 0;
int lastActionTime = 0;
int graphicDisplayDuration = 3000;

void setup() {
  size(750, 750);
  oscP5 = new OscP5(this, 12345);
  arduinoPort = new Serial(this, portName, 9600);
}

void draw() {
  background(0);

  if (personDetected) {
    generateGraphicsAndImages();
  } else {
    fill(255);
    textSize(32);
   // text("No person detected", width / 2 - 150, height / 2);
    arduinoPort.write('E');
  }

  for (DisplayObject obj : displayObjects) {
    obj.display();
  }
}

/* It's responsible for creating visual elements on the screen. 
It alternates between displaying geometric graphics and loading images from an array of filenames.
When the current time is less than the graphicDisplayDuration since the last action, it displays a graphic.
After the duration passes, it removes the graphic and displays an image instead.
It also handles the progression through a grid layout, determining where the next image or graphic will be placed.*/
void generateGraphicsAndImages() {
  noFill();
  //stroke(255);
  
  float d = grid * 0.6; // Calculates the diameter for the graphics based on the grid size.
  int x = margin + currentCol * (grid + 50); // Calculates the x position for the current column.
  int y = margin + currentRow * (grid + 50);  // Calculates the y position for the current row.

  if (millis() - lastActionTime < graphicDisplayDuration) { // Checks if the current graphic display duration has not passed.
    // Displays a graphic.
    int colArrayNum = (int) random(7); // Chooses a random index for the color array.
    stroke(colArray[colArrayNum]); // Sets the stroke color for the graphic.
    DisplayObject newObject = new DisplayObject(x, y, d, colArray[colArrayNum], true); // Creates a new DisplayObject for a graphic.
    displayObjects.add(newObject); // Adds the new DisplayObject to the ArrayList.
  } else {
   // Removes graphics before generating images.
    Iterator<DisplayObject> iterator = displayObjects.iterator(); // Creates an iterator for the ArrayList.
    while (iterator.hasNext()) {  // Loops while there are elements in the ArrayList.
      DisplayObject obj = iterator.next();
      if (obj.isGraphic) {
        iterator.remove();
      }
    }


    String[] imageFiles = {"1.jpeg", "2.jpeg", "3.JPG", "4.jpeg", "5.png", "6.JPG", "7.JPG", "8.JPG", "9.JPG", "10.JPG", "11.JPG", "12.JPG", "13.JPG", "14.JPG", "15.JPG", "16.JPG", "17.JPG" };
    String randomImage = imageFiles[int(random(imageFiles.length))];
    DisplayObject newObject = new DisplayObject(x - imageSize / 2, y - imageSize / 2, randomImage, imageSize, false);
    displayObjects.add(newObject);

    arduinoPort.write('S');
    moveNextPosition();
  }
}

void moveNextPosition() {
  currentCol++;
  if (currentCol > 3) {
    currentCol = 0;
    currentRow++;
  }
  if (currentRow > 3) {
    currentRow = 0;
    currentCol = 0;
    
    resetAll();
  }
  lastActionTime = millis();
}

void resetAll() {
  displayObjects.clear();
  personDetected = false; 
}

void oscEvent(OscMessage msg) {
  println("Received OSC Message: " + msg.addrPattern());

  if (msg.addrPattern().equals("/pose/landmark")) {
    objectPosition.x = msg.get(0).floatValue();
    objectPosition.y = msg.get(1).floatValue();
    objectPosition.z = msg.get(2).floatValue();
  } else if (msg.addrPattern().equals("/person/detected")) {
    personDetected = msg.get(0).intValue() == 1;
  }
}

class DisplayObject {
  float x, y, d;
  PImage image;
  boolean isGraphic;
  color col;

  DisplayObject(float x, float y, float d, color col, boolean isGraphic) {
    this.x = x;
    this.y = y;
    this.d = d;
    this.isGraphic = isGraphic;
    this.col = col;
  }

  DisplayObject(float x, float y, String imageName, int size, boolean isGraphic) {
    this.x = x;
    this.y = y;
    this.image = loadImage(imageName);
    this.image.resize(size, size);
    this.isGraphic = isGraphic;
  }

  void display() {
    if (isGraphic) {
      stroke(col);
      strokeWeight(1);
      for (int num = 0; num < 7; num++) {
        float x1 = -random(d);
        float y1 = -random(d);
        float x2 = random(d);
        float y2 = -random(d);
        float x3 = random(d);
        float y3 = random(d);
        float x4 = -random(d);
        float y4 = random(d);

        pushMatrix();
        translate(x, y);
        quad(x1, y1, x2, y2, x3, y3, x4, y4);
        popMatrix();
      }
    } else {
      image(image, x, y);
     // fill(0, 255, 0, 100);
      rect(x, y, image.width, image.height);
    }
  }
}
