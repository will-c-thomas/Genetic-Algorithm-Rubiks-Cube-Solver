//Rubicks sube solver using genitic algorithm

Cube cube1, cube2;

Cube target;
int popMax;
float mutationRate;
GeneticAlgo genAlg;
int turns, restrictedTurns;
float wallSize = 75;
int totalGens = 0;

void setup() {
  
  size(900,900,P3D);
  frameRate(120);
  smooth(4);
  
  target = new Cube(3,3,3, wallSize);
  popMax = 1000;
  mutationRate = 0.2;
  turns = 50;
  restrictedTurns = 40;
  genAlg = new GeneticAlgo(target.x, target.y, target.x, turns, wallSize, target, mutationRate, popMax);
  genAlg.adjustRestrictedTurns(restrictedTurns);
  
  /*cube1 = new Cube(3,3,3, 30);
  cube2 = new Cube(3,3,3, 30);
  cube2.scramble("fulrfbd");
  
  //println(fitness(cube1,cube2));
  
  cube1.scramble(cube1.genScramble(20));
  cube2.scramble(cube2.genScramble(20));*/
  
}


Cube currBestCube, prevBestCube;
int frameNum = 0, highestFit = 0, gensOfStagnation = 0;

void draw() {
  
  frameNum++;
  
  background(50);
  textSize(35);
  textAlign(CENTER);
  
  boolean rotationTesting = true;
  float radY = float(mouseX)/float(width) * 2*PI + 2*PI;
  float radX = float(mouseY)/float(height) * 2*PI + 2*PI;
  
  DNA best = genAlg.getBest();
  prevBestCube = currBestCube;
  currBestCube = best.cube;
  
  if(highestFit < best.fitness)
    highestFit = best.fitness;
  
  text("Best Curr Fitness: " + best.fitness + "\nNum of Turns: " + (turns-restrictedTurns) + "\nGoal Fitness: " + genAlg.perfectScore + "\nGeneration: " + totalGens, width/2, height/15);
  textSize(20);
  text("Best Solve:\n" + best.getGenes().substring(0,turns-restrictedTurns), width/2, height-height/9);
  
  best.cube.drawCube(width/2,height/1.8,0, (rotationTesting)?radX:0, (rotationTesting)?radY:0);
  
  if(frameNum >= 0 && !genAlg.finished()) {
    genAlg.naturalSelection();
    genAlg.generate();
    genAlg.calcFitness();
    
    totalGens++;
     
    if(currBestCube == prevBestCube) {
      gensOfStagnation++;
    
      if(gensOfStagnation >= 500) {
        
        if(restrictedTurns == 0) {
          turns = 25;
          restrictedTurns = 10;
          genAlg = new GeneticAlgo(target.x, target.y, target.x, turns, wallSize, target, mutationRate, popMax);
          genAlg.adjustRestrictedTurns(restrictedTurns);
        }
        
        gensOfStagnation = 0;
        genAlg.adjustRestrictedTurns(--restrictedTurns);
      }
    } else
      gensOfStagnation = 0;
      
    frameNum = 0;  
  }
  
  
  /*cube1.drawCube(300,450,0, (rotationTesting)?radX:0, (rotationTesting)?radY:0);
  cube2.drawCube(600,450,0, (rotationTesting)?radX:0, (rotationTesting)?radY:0);*/
  
}

void keyReleased() {
  
  /*if(key == ' ' && !genAlg.finished()) {
    genAlg.naturalSelection();
    genAlg.generate();
    genAlg.calcFitness();
  }*/
    
  
  /*if(key == 'l')
    cube1.rotateSide("l");
  else if(key == 'f')
    cube1.rotateSide("f");
  else if(key == 'b')
    cube1.rotateSide("b");
  else if(key == 'r')
    cube1.rotateSide("r");
  else if(key == 'd')
    cube1.rotateSide("d");
  else if(key == 'u')
    cube1.rotateSide("u");
    
  if(key == 'l')
    cube2.rotateSide("l");
  else if(key == 'f')
    cube2.rotateSide("f");
  else if(key == 'b')
    cube2.rotateSide("b");
  else if(key == 'r')
    cube2.rotateSide("r");
  else if(key == 'd')
    cube2.rotateSide("d");
  else if(key == 'u')
    cube2.rotateSide("u");*/
  
}