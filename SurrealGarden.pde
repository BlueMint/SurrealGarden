import de.voidplus.leapmotion.*;

tree tree1;
tree tree2;
ArrayList<grass> grasses = new ArrayList<grass>(); //lol at grasses
PVector wind;
insectParticleSystem insectPS;
sky sky = new sky();
LeapMotion leap;


void setup() {
  size(1000, 800);
  tree1 = new tree(width/2+width/4, height, height/4);
  tree2 = new tree(width/4, height, height/4);
  for (int i = 0; i < width; i += random (5, 20)) {
    grasses.add(new grass(i, random(5, 50)));
  }
  wind = new PVector(0, 1, 0);
  insectPS = new insectParticleSystem(wind);
  leap = new LeapMotion(this);
}

void draw() {
  sky.update();
  stroke(255, 0, 255);
  line(width/2, height/2, width/2+wind.x*4, height/2+wind.y*4);
  stroke(0);
  //wind.update();
  treeUpdate(tree1);
  treeUpdate(tree2);
  insectPS.update();
  windUpdate();
  interactionUpdate();

  for (grass grass : grasses) {
    grassUpdate(grass);
  }
}

void treeUpdate(tree currentTree) {
  currentTree.beAtracted(wind);
  currentTree.update();
  currentTree.display();
}

void grassUpdate(grass currentGrass) {
  currentGrass.update(wind.x); 
  currentGrass.display();
}

PVector getRightFingerPos() {
  for (Hand hand : leap.getHands ()) {
    if (hand.isRight()) {
      for (Finger finger : hand.getFingers ()) {
        if (finger.getType() == 1) {
          return finger.getPosition();
        }
      }
    }
  } 
  return null;
}

PVector getLeftFingerPos() {
  for (Hand hand : leap.getHands ()) {
    if (hand.isLeft()) {
      for (Finger finger : hand.getFingers ()) {
        if (finger.getType() == 1) {
          return finger.getPosition();
        }
      }
    }
  } 
  return null;
}

void windUpdate() {
  PVector currentPos = getRightFingerPos();
  if (currentPos != null) {
    wind.x = map(currentPos.x, 0, width, -50, 50);
    wind.y = map(currentPos.y, 0, height, -50, 50);
  }
}

void interactionUpdate() {
  PVector currentPos = getLeftFingerPos();
  if (currentPos != null) {
    stroke(0, 0, 0);
    strokeWeight(3);
    fill(0);
    ellipse(map(currentPos.x, 0, width, width*-0.2, width*1.2), map(currentPos.y, 0, height, height*-0.2, height*1.2), 10, 10);
    println("X: " + map(currentPos.x, 0, width, width*-1.2, width*1.2) + " Y: " + map(currentPos.y, 0, height, height*-1.2, height*1.2));
  }
}

void keyPressed(KeyEvent e) {
  if (key == CODED) {
    if (keyCode == LEFT) {
      wind.rotate(radians(-10));
    }
    if (keyCode == RIGHT) {
      wind.rotate(radians(10));
    }
    if (keyCode == UP && wind.mag()<50) {
      wind.setMag(wind.mag()+1);
    }
    if (keyCode == DOWN && wind.mag()>1) {
      wind.setMag(wind.mag()-1);
    }
  }
}

