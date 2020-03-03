//-----------------------------DNA Code Below----------------------------//
  
class DNA {
  
  Cube cube;
  int fitness;
  String genes, ogScramble; //scramble
  int turns, restrictedTurns;
  boolean layerOne, layerTwo;
  
  DNA(int x, int y, int z, int turns, float wallSize, String ogScramble) {
    this.cube = new Cube(x, y, z, wallSize);
    this.turns = turns;
    genes = cube.genScramble(turns);
    cube.scramble(ogScramble); //initial scramble
    cube.scramble(genes.substring(0, turns-restrictedTurns));      //try to solve w genes
    this.ogScramble = ogScramble;
  }
  
  DNA(int x, int y, int z, int turns, float wallSize, String ogScramble, String genes, Cube target) {
    this.cube = new Cube(x, y, z, wallSize);
    this.turns = turns;
    this.genes = genes;
    cube.scramble(ogScramble); //initial scramble
    cube.scramble(genes.substring(0, turns-restrictedTurns));      //try to solve w genes
    this.ogScramble = ogScramble;
    this.fitness(target);
  }
  
  Cube getCube() {
    return this.cube;
  }
  
  String getGenes() {
    return this.genes;
  }
  
  //calc fitness score for DNA object
  void fitness(Cube target) {
    
    int score = 0;
          
    boolean layerOne = true, layerTwo = true;      
    
    for(int i = 0; i < target.x; i++) {
      for(int j = 0; j < target.y; j++) {
        for(int k = 0; k < target.z; k++) {
          
          if(i != 0 && i != target.x-1 && j != 0 && j != target.y-1 && k != 0 && k != target.z-1)
            continue;
          
          boolean equal = true;
                                          
          for(int m = 0; m < cube.cubits[i][j][k].colors.length; m++) {
            if(target.cubits[i][j][k].colors[m] != cube.cubits[i][j][k].colors[m]) {
              equal = false;
              continue;
            //if(target.cubits[i][j][k].colors[m] == cube.cubits[i][j][k].colors[m] && cube.cubits[i][j][k].colors[m] != color(0))
            }
          }
              
          if(i == 0 && equal == false)
            layerOne = false;
          else if(i == 1 && equal == false)
            layerTwo = false;
          
          if(equal && layerOne) score++;
          if(equal && i==0 && !layerOne) score++;
          if(equal && layerOne && layerTwo && i == 1) score++;
          
        }
      }
    }
    
    //put emphasis on building layer by layer
    if(layerOne) {
      score *= 2;
      if(layerTwo)
        score *= 2;
    }
    
    fitness = int(pow(score,3));
    
    this.layerOne = layerOne;
    this.layerTwo = layerTwo;
    //println(layerOne + " fitness " + layerTwo);
  }
  
  //perform crossover of the genes
  DNA crossover(DNA partner) {
    
    DNA child = new DNA(cube.x, cube.y, cube.z, this.turns, cube.wallSize, this.ogScramble);
    
    int midpoint = int(genes.length()/2);
    if(genes.charAt(midpoint) == '\'')
      midpoint++;
    child.genes = this.genes.substring(0, midpoint);
    if(partner.genes.charAt(midpoint) == '\'')
      midpoint--;
    child.genes += partner.genes.substring(midpoint, partner.genes.length());
    
    child.cube = new Cube(cube.x, cube.y, cube.z, cube.wallSize);
    child.cube.scramble(child.ogScramble); //initial scramble
    child.cube.scramble(child.genes.substring(0, turns-restrictedTurns));      //try to solve w genes
    
    return child;
  }
  
  //add in mutations
  void mutate(float mutationRate) {
    
    char[] rotations = {'f', 'b', 'u', 'd', 'l', 'r'};
    char[] genesArr = genes.toCharArray();
    
    int startIndex = 0;
    if(layerOne && layerTwo)
      startIndex = turns-restrictedTurns - 2;
    
    for(int i = startIndex; i < genes.length() - restrictedTurns; i++) {
      if(random(1) < mutationRate) {
        //println(layerOne + " " + layerTwo);
        if(genesArr[i] != '\'' && !layerTwo)
          genesArr[i] = rotations[ floor( random( rotations.length ) ) ];
        else if(layerOne && layerTwo) {
          char[] rotationsAdditional = {'f', 'b', 'u', 'd', 'l', 'r', '\''};
          if(i < genesArr.length -1 && genesArr[1-1] != '\'' && genesArr[i] != '\'' && genesArr[i+1] != '\'')
            genesArr[i] = rotationsAdditional[ floor( random( rotationsAdditional.length ) ) ];
          else if(genesArr[i] != '\'')
            genesArr[i] = rotations[ floor( random( rotations.length ) ) ];
          println(i);
        }
        
      }
    }
    
    this.cube = new Cube(cube.x, cube.y, cube.z, cube.wallSize);
    this.genes = new String(genesArr);
    this.cube.scramble(ogScramble);
    this.cube.scramble(genes.substring(0, turns-restrictedTurns));
    
  }
  
}