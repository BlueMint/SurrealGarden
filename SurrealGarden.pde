import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

import processing.sound.*;

import de.voidplus.leapmotion.*;

Minim minim;
tree tree1;
tree tree2;
ArrayList<grass> grasses = new ArrayList<grass>(); //lol at grasses
PVector wind;
insectParticleSystem insectPS;
sky sky = new sky();
LeapMotion leap;
processing.sound.WhiteNoise noise;
float timeGrassPlayedLast = -10000;
boolean soundPlayed = false;
float timeLastInteracted;
float timeout = 5000;
float windoff;


void setup() {
  size(1000, 800);
  minim = new Minim(this);
  tree1 = new tree(width/2+width/4, height, height/4);
  tree2 = new tree(width/4, height, height/4);
  playSound("tree");
  for (int i = 0; i < width; i += random (5, 20)) {
    grasses.add(new grass(i, random(5, 50)));
  }
  wind = new PVector(0, 1, 0);
  insectPS = new insectParticleSystem(wind);
  leap = new LeapMotion(this);
  noise = new processing.sound.WhiteNoise(this);
  noise.amp(0.0);
  noise.play();
}

void draw() {
  sky.update();
  stroke(255, 0, 255);
  line(width/2, height/2, width/2+wind.x*4, height/2+wind.y*4);
  stroke(0);
  noise.amp(map(abs(wind.x)+abs(wind.y), 0, 50, 0, 0.15));
  treeUpdate(tree1);
  treeUpdate(tree2);
  insectPS.update();
  windUpdate();
  interactionUpdate();
  sky.soundUpdate();
  sky.midnightReset();

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
    timeLastInteracted = sky.mills;
    wind.x = map(currentPos.x, 0, width, -50, 50);
    wind.y = map(currentPos.y, 0, height, -50, 50);
  }
}

void interactionUpdate() {
  PVector currentPos = getLeftFingerPos();
  if (currentPos != null) {
    timeLastInteracted = sky.mills;
    stroke(0, 0, 0);
    strokeWeight(3);
    fill(0);
    ellipse(map(currentPos.x, 0, width, width*-0.2, width*1.2), map(currentPos.y, 0, height, height*-0.2, height*1.2), 10, 10);
    if (map(currentPos.y, 0, height, height*-1.2, height*1.2) > height-200 && timeGrassPlayedLast < sky.mills - 2000) {
      playSound("grass");
      timeGrassPlayedLast = sky.mills;
    }
  }
  if (timeLastInteracted < sky.mills - timeout){
    windoff = windoff + .01;
       wind.rotate(radians(((noise(windoff)*40)-20)/10));
       if(wind.mag() > 50){
         wind.setMag(wind.mag() - noise(windoff));
       }
       else
       if(wind.mag() < 1){
         wind.setMag(wind.mag() + noise(windoff));
       }
       else{
         wind.setMag(wind.mag() +(noise(windoff) - wind.mag()/100 -0.25)  );
       }
  }
}

void keyPressed(KeyEvent e) {
  timeLastInteracted = sky.mills;
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
  } else if (key == 'r') {
    tree1 = new tree(width/2+width/4, height, height/4);
    tree2 = new tree(width/4, height, height/4);
    playSound("tree");
  }
}

