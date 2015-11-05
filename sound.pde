void playSound(String noise) {
  if (noise == "rooster") {
    AudioPlayer rooster;
    rooster = minim.loadFile("rooster.mp3");
    rooster.play();
  } else if (noise == "tree") {
    AudioPlayer tree;
    tree = minim.loadFile("tree.mp3");
    tree.play();
  } else if (noise == "grass") {
    AudioPlayer grass;
    grass = minim.loadFile("grassReal.mp3");
    grass.play();
  }
}

