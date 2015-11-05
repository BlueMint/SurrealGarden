class insectParticleSystem {
  ArrayList<insect> insects;
  PVector wind;
  float cooldown = 0;

  insectParticleSystem(PVector _w) {
    insects = new ArrayList<insect>();
    wind = _w;
  }

  void addInsect() {
    if (cooldown < 1) {
      insects.add(new insect(wind)); 
      cooldown = random(3, 8);
    } else cooldown--;
  }

  void update() {
    addInsect();
    for (int i = insects.size ()-1; i >= 0; i--) {
      insect p = insects.get(i);
      p.run();
      if (p.isDead()) {
        insects.remove(i);
      }
    }
  }
}

class insect
{
  PVector location, velocity;
  float opacity;
  boolean decay = false;
  float offsetY;
  float offsetX;
  PVector wind;

  insect(PVector _w)
  {
    wind = _w;
    float origin = 0.0;
    origin = random(0, width);
    location = new PVector(origin, random(0, height-15));
    velocity = new PVector(random(-200, 200), random(-200, 200));
    opacity = 0.0;
  }

  void run()
  {
    update();
    display();
  }

  void update() {
    if (random(1) > .5) offsetX -= 0.1;
    else offsetX += 0.1;
    if (random(1) > .5) offsetY -= 0.1;
    else offsetY += 0.1;

    velocity.set(wind.x/10+(offsetX), wind.y/10+(offsetY));
    location.add(velocity);
    if (opacity < 150 && !decay) {
      opacity += 5;
    } else {
      decay = true;
      opacity -= 1;
    }
  }

  void display()
  {
    stroke(opacity, opacity, 0, opacity);
    strokeWeight(3);
    fill(0, opacity);
    ellipse(location.x, location.y, 10, 10);
  }

  boolean isDead()
  {
    if ( opacity<5 ) return true;
    else return false;
  }
}

