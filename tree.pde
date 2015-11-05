class tree {
  float rootX, rootY;
  float ang, prefAng;
  float branchLength;
  int numberChild;
  float angle = -HALF_PI;
  float maxAng = HALF_PI;


  float resistance;
  float flyBackForce;

  PVector targetForce;
  PVector remainder;

  tree[] children;
  tree  parent;

  tree(float _x, float _y, float _l) {
    rootX = _x;
    rootY = _y;
    parent=null;
    prefAng = angle;
    numberChild = (int) random(2, 4);
    resistance=100;
    flyBackForce=0.1;
    branchLength=_l;
    children = new tree[numberChild];
    for (int i = 0; i < numberChild; i++) {
      children[i] = new tree(this, branchLength/1.7, maxAng*(random(75, 125)/100), random(-maxAng/2, maxAng/2));
    }
    resistance=1000;
    targetForce=new PVector(0, 0, 0);
    remainder=new PVector(0, 0, 0);
  }


  tree(tree _parent, float _l, float maxAng, float ang) {//make a branch from a parent branch
    rootX = _parent.getTopX();
    rootY = _parent.getTopY();
    parent=_parent;
    prefAng = ang;
    numberChild = (int) random(2, 4);
    resistance=100;
    flyBackForce=0.1;
    branchLength=_l;
    if (branchLength>random(2, 40)) {
      children = new tree[numberChild];
      for (int i = 0; i < numberChild; i++) {
        children[i] = new tree(this, branchLength/1.7, maxAng*(random(75, 125)/100), random(-maxAng/2, maxAng/2));
      }
    } else {
      children = null;
    }
    targetForce=new PVector(0, 0, 0);
    remainder=new PVector(0, 0, 0);
  }

  //This code is from https://github.com/nikolajRoager/windyTree
  float getAng() {
    if (parent!=null) {
      return ang+parent.getAng();
    } else {
      return ang;
    }
  }//get the angle of this, when taking in acount, all angles of the parents


  float getBaseX() {
    return cos(getAng())*branchLength;
  }
  float getBaseY() {
    return sin(getAng())*branchLength;
  }

  float getTopX() {
    return rootX+cos(getAng())*branchLength;
  }
  float getTopY() {
    return rootY+sin(getAng())*branchLength;
  }

  void display() {
    strokeWeight(branchLength/10);
    line(rootX, rootY, getTopX(), getTopY());
    if (children != null) {
      for (int i = 0; i < children.length; i++) {
        children[i].display();
      }
    }



    float distance=ang-prefAng;//the angular distance, between the prefered angle, and the angle
    distance*= (distance>0) ? 1 : -1;
    if (ang>prefAng+0.001) {
      ang-=flyBackForce*distance;
    } else if (ang<prefAng-0.001) {
      ang+=flyBackForce*distance;
    } else {
      ang=prefAng;
    }

    if (children != null) {
      for (int i = 0; i < children.length; i++) {
        children[i].update();
      }
    }
  }
  void update() {//update, this branch, and all of it's children
    if (parent != null) {
      rootX = parent.getTopX();
      rootY = parent.getTopY();
    }
    float distance=ang-prefAng;//the angular distance, between the prefered angle, and the angle
    distance*= (distance>0) ? 1 : -1;
    if (ang>prefAng+0.001) {
      ang-=flyBackForce*distance;
    } else if (ang<prefAng-0.001) {
      ang+=flyBackForce*distance;
    } else {
      ang=prefAng;
    }

    if (children != null) {
      for (int i = 0; i < children.length; i++) {
        children[i].update();
      }
    }
  }
  PVector beAtracted(PVector _targetForce) {
    targetForce.set(_targetForce);
    float angToMove=0;//the angle to move
    if (children != null) {
      for (int i = 0; i < children.length; i++) {
        targetForce.add(children[i].beAtracted(_targetForce));
      }
    }
    float angDiff = getAng()+atan2(targetForce.x, targetForce.y);
    angToMove+=cos(angDiff)*targetForce.mag()/(resistance*branchLength);
    ang+=angToMove;
    float remainderStrength=sin(angDiff)*targetForce.mag();
    remainder.set(remainderStrength*cos(getAng()), remainderStrength*sin(getAng()));
    return remainder;
  }
}
