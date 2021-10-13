

/*
  James Luberisse
 CAP3027
 Project 2: Random Walk Variant
 */

import java.util.*;
import controlP5.*;
ControlP5 cp5;

Button START;
DropdownList SHAPES;
Slider MAX_STEPS;
Slider STEP_RATE;
Slider STEP_SIZE;
Slider STEP_SCALE;
CheckBox TOGGLE;
Textfield SEED_VALUE;
int orginX = (1200+200)/2;

int  n = 0;
boolean startBool = false;




public abstract class RandomWalkBaseClass {
  int max;
  int rate;
  int size;
  int step;
  double scale;
  int seedValue;
  boolean stroke = false;
  boolean seed;
  boolean constraint;
  boolean terrainColor;
  int Color;
  int iteration = 0;
  int x;
  int y;
  int count = 0;
  int markerCount;

  final color DIRT = color(160, 126, 84);
  final color GRASS = color(143, 170, 64);
  final color ROCK = color(135, 135, 135);

  HashMap<PVector, Integer> colorMap = new HashMap();
  RandomWalkBaseClass() {
    x = (1200+200)/2;
    y = 800/2;
  }

  void Update() {
  }

  void Draw() {
  }

  int boundForX;
  int randomDirection() {
    return (int)random(4);
  }




  void gridColoring() {

    PVector Vector = new PVector(x, y);


    if (colorMap.get(Vector) == null) {
      colorMap.put(Vector, 1);
    } else {
      markerCount = colorMap.get(Vector);
      markerCount++;
      colorMap.put(Vector, markerCount);
    }




    if (markerCount < 4) {
      fill(DIRT);
    } else if (4<markerCount && markerCount< 7) {
      fill(GRASS);
    } else if (7<markerCount && markerCount< 10) {
      fill(ROCK);
    } else {
      if (markerCount * 20 > 255) {
         markerCount = 255;
      } else {
        markerCount *= 20;
      }
      fill(markerCount, markerCount, markerCount );
    }
  }
}

public class SquareClass extends RandomWalkBaseClass {

  void Update() {
    int step = (int) (scale * size);

    int rand = randomDirection();
    if (this.constraint) {
      boundForX = 200;
    } else {
      boundForX = 0;
    }
    switch(rand) {
    case 0:

      if (x<1200) {
        x+=step;
      } else {
        x-=step;
      }
      break;
    case 1:

      if (x>boundForX) {
        x-=step;
      } else {
        x+=step;
      }
      break;
    case 2:
      if (y>800) {
        y-=step;
      } else {
        y+=step ;
      }

      break;
    case 3:
      if (y<0) {
        y+=step;
      } else {
        y-=step;
      }
      break;

    default:
    }
  }

  void Draw() {

    if (stroke) {
      stroke(1);
    } else {
      noStroke();
    }

    if (terrainColor) {
      gridColoring();
    } else {
      fill(168, 100, 199);
    }
    square(x, y, size);
  }
}

public class HexagonClass extends RandomWalkBaseClass {

  float x;
  float y;

  HexagonClass() {
    x = (1200+200)/2;
    y = 800/2;
  }

  float _xOrigin = (1200+200)/2;
  float _yOrigin = 800/2;

  int randomDirection() {
    return (int)random(6);
  }
  //from hexTest file;
  PVector CartesianToHex(float xPos, float yPos, float hexRadius, float stepScale)
  {
    float startX = xPos - _xOrigin;
    float startY = yPos - _yOrigin;

    float col = (2.0/3.0f * startX) / (hexRadius * stepScale);
    float row = (-1.0f/3.0f * startX + 1/sqrt(3.0f) * startY) / (hexRadius * stepScale);

    float x = col;
    float z = row;
    float y = -x - z;
    float roundX = round(x);
    float roundY = round(y);
    float roundZ = round(z);

    float xDiff = abs(roundX - x);
    float yDiff = abs(roundY - y);
    float zDiff = abs(roundZ - z);

    if (xDiff > yDiff && xDiff > zDiff)
      roundX = -roundY - roundZ;
    else if (yDiff > zDiff)
      roundY = -roundX - roundZ;
    else
      roundZ = -roundX - roundY;

    PVector result = new PVector(roundX, roundZ);

    return result;
  }


  void gridColoring() {

    PVector Vector = CartesianToHex((float) x, (float) y, (float) size, (float) scale);


    if (colorMap.get(Vector) == null) {
      colorMap.put(Vector, 1);
    } else {
      markerCount = colorMap.get(Vector);
      markerCount++;
      colorMap.put(Vector, markerCount);
    }




    if (markerCount < 4) {
      fill(DIRT);
    } else if (4<markerCount && markerCount< 7) {
      fill(GRASS);
    } else if (7<markerCount && markerCount< 10) {
      fill(ROCK);
    } else {
      fill(markerCount * 20, markerCount * 20, markerCount * 20 );
    }
  }

  void hexStep(int rand) {
    switch(rand) {
    case 0:
      if (y < 10) {

        x +=  cos(radians(90)) * sqrt(3) * (float)(scale*size*1.7);
        y +=  sin(radians(90)) * sqrt(3) * (float)(scale*size*1.7);
      } else {
        x -=  cos(radians(90)) * sqrt(3) * (float)(scale*size*1.7);
        y -=  sin(radians(90)) * sqrt(3) * (float)(scale*size*1.7);
      }
      break;
    case 1:
      if (x < boundForX ) {

        x +=  cos(radians(30)) * sqrt(3) * (float)(scale*size*1.7);
        y +=  sin(radians(30)) * sqrt(3) * (float)(scale*size*1.7);
      } else {
        x -=  cos(radians(30)) * sqrt(3) * (float)(scale*size*1.7);
        y -=  sin(radians(30)) * sqrt(3) * (float)(scale*size*1.7);
      }
      break;
    case 2:
      if (x < boundForX ) {

        x +=  cos(radians(-30)) * sqrt(3) * (float)(scale*size*1.7);
        y +=  sin(radians(-30)) * sqrt(3) * (float)(scale*size*1.7);
      } else {
        x -=  cos(radians(-30)) * sqrt(3) * (float)(scale*size*1.7);
        y -=  sin(radians(-30)) * sqrt(3) * (float)(scale*size*1.7);
      }
      break;
    case 3:
      if (y > 800) {

        x +=  cos(radians(-90)) * sqrt(3) * (float)(scale*size*1.7);
        y +=  sin(radians(-90)) * sqrt(3) * (float)(scale*size*1.7);
      } else {
        x -=  cos(radians(-90)) * sqrt(3) * (float)(scale*size*1.7);
        y -=  sin(radians(-90)) * sqrt(3) * (float)(scale*size*1.7);
      }
      break;

    case 4:
      if (x > 1200) {

        x +=  cos(radians(-150)) * sqrt(3) * (float)(scale*size*1.7);
        y +=  sin(radians(-150)) * sqrt(3) * (float)(scale*size*1.7);
      } else {
        x -=  cos(radians(-150)) * sqrt(3) * (float)(scale*size*1.7);
        y -=  sin(radians(-150)) * sqrt(3) * (float)(scale*size*1.7);
      }
      break;

    case 5:
      if (x > 1200) {

        x +=  cos(radians(150)) * sqrt(3) * (float)(scale*size*1.7);
        y +=  sin(radians(150)) * sqrt(3) * (float)(scale*size*1.7);
      } else {
        x -=  cos(radians(150)) * sqrt(3) * (float)(scale*size*1.7);
        y -=  sin(radians(150)) * sqrt(3) * (float)(scale*size*1.7);
      }
      break;
    }
  }



  void Update() {


    float stepx =  cos(radians(-150)) * sqrt(3) * (float)(scale*size*1.7);
    float stepy =  sin(radians(-150)) * sqrt(3) * (float)(scale*size*1.7);

    int rand = randomDirection();
    if (this.constraint) {
      boundForX = 230;
    } else {
      boundForX = 0;
    }
    hexStep(rand);
  }


  void drawHex() {
    beginShape();
    for (int i = 0; i <= 360; i+= 60)
    {
      float xPos = x + cos(radians(i)) * (int) (sqrt(3) * size);
      float yPos = y + sin(radians(i)) * (int) (sqrt(3) * size );

      vertex(xPos, yPos);
    }
    endShape();
  }
  void Draw() {


    if (stroke) {
      stroke(1);
    } else {
      noStroke();
    }

    if (terrainColor) {
      gridColoring();
    } else {
      fill(168, 100, 199);
    }
    drawHex();
    fill(100, 255, 33);
  }
}

void setup() {
  cp5 = new ControlP5(this);
  size(1200, 800);
  stroke(2);

  fill(100, 100, 100);
  rect(0, 0, 200, 800);

  START = cp5.addButton("START")
    .setPosition(10, 20)
    .setColorBackground(color(0, 155, 0))
    .setSize(100, 30);

  SHAPES = cp5.addDropdownList("SQUARES")
    .setPosition(10, 65)
    .setItemHeight(40)
    .setBarHeight(35)
    .addItem("SQUARES", 0)
    .addItem("Hexagons", 1)
    .setSize(150, 300)
    .setOpen(false);

  MAX_STEPS = cp5.addSlider("MAX_STEPS")
    .setPosition(10, 240)
    .setRange(100, 50000)
    .setSize(180, 25)
    .setValue(100)
    .setCaptionLabel("Maximum Steps");
  MAX_STEPS.getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE);

  //Step Rate
  STEP_RATE = cp5.addSlider("STEP_RATE")
    .setPosition(10, 290)
    .setRange(1, 1000)
    .setValue(1)
    .setCaptionLabel("Step Rate")
    .setSize(180, 25);
  STEP_RATE.getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE);


  STEP_SIZE = cp5.addSlider("STEP_SIZE")
    .setPosition(10, 365)
    .setRange(10, 30)
    .setCaptionLabel("Step Size")
    .setSize(90, 25)
    .setValue(10);
  STEP_SIZE.getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE);


  //Step SCALE
  STEP_SCALE = cp5.addSlider("STEP_SCALE")
    .setPosition(10, 415)
    .setRange(1.0, 1.5)
    .setCaptionLabel("Step Scale")
    .setSize(90, 25)
    .setValue(1.0);
  STEP_SCALE.getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE);


  //Checkbox
  TOGGLE =cp5.addCheckBox("TOGGLE")
    .setPosition(10, 470)
    .addItem("CONSTRAIN STEPS", 0)
    .addItem("SIMULATE TERRAIN", 1)
    .addItem("USE STROKE", 2)
    .addItem("USE RANDOM SEED", 3)
    .setSize(25, 25)
    .setSpacingRow(20);

  for (int i = 0; i < 4; i++) {
    TOGGLE.getItem(i).getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-2).setPaddingY(5);
  }


  //Seed input
  SEED_VALUE = cp5.addTextfield("SEED_VALUE")
    .setPosition(110, 605)
    .setInputFilter(ControlP5.INTEGER)
    .setValue("0")
    .setSize(50, 25);
}

RandomWalkBaseClass someObject = null;




void draw() {


  if (startBool) {

    int rate = (int) STEP_RATE.getValue();

    if (n < someObject.max) {
      //Step rate per frame
      for (int i=0; i<rate; i++) {

        someObject.Update();
        someObject.Draw();
        someObject.count++;
        if (n==someObject.max) {
          startBool=false;
        }
        n++;
      }
    }
  }
}



void START() {
  clear();



  startBool = true;
  n = 0;
  someObject = null;

  if (SHAPES.getValue() == 0) {
    someObject = new SquareClass();
  } else {
    someObject = new HexagonClass();
  }

  someObject.max = 0;

  if (SHAPES.getValue() == 1) {
    background(color(50, 140, 210) ) ;
    fill(100, 100, 100);
    rect(0, 0, 200, 800);
    stroke(2);
  } else {
    background(color(200, 200, 200) ) ;
    fill(100, 100, 100);
    rect(0, 0, 200, 800);
    stroke(2);
  }


  someObject.size = (int) STEP_SIZE.getValue();
  someObject.scale =  STEP_SCALE.getValue();
  someObject.max = (int) MAX_STEPS.getValue();
  someObject.rate = (int) STEP_RATE.getValue();
  someObject.stroke =  TOGGLE.getItem(2).getBooleanValue();
  someObject.constraint = TOGGLE.getItem(0).getBooleanValue();
  someObject.seed = TOGGLE.getItem(3).getBooleanValue();
  someObject.seedValue = (int) Integer.parseInt(SEED_VALUE.getText());
  someObject.terrainColor =  TOGGLE.getItem(1).getBooleanValue();

  if (someObject.seed) {
    randomSeed(someObject.seedValue);
  }


  draw();
}
