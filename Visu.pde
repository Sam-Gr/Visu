//declare the min and max variables that you need in parseInfo
float minX, maxX;
float minY, maxY;
int totalCount; // total number of places
float minPopulation, maxPopulation;
float minDensity, maxDensity;
float minSurface, maxSurface;
float minAltitude, maxAltitude;
float minPopulationToDisplay = 10000;

//declare the variables corresponding to the column ids for x and y
int X = 1;
int Y = 2;

// and the tables in which the city coordinates will be stored
float x[];
float y[];
City cities[];

City selectedCity = null;
HScrollbar popSlider;

void setup() {
  size(1200,800);
  readData();
  
  popSlider = new HScrollbar(750, 100, 400, 100, 16, 110, 1);
  popSlider.makeHistogram(cities, minPopulation, maxPopulation);
}

void draw() {
  background(255);
  color black = color(0);
  String s = "Afficher les populations supérieures à "+ (int) minPopulationToDisplay;
  
  fill(10,10,10);
  textSize(20);
  textAlign(CENTER,TOP);
  text(s, 400, 5);
  
  for (int i = 0 ; i < cities.length ; i++) {
    //set((int) mapX(x[i]), (int) mapY(y[i]), black);
    if (cities[i].population >= minPopulationToDisplay && cities[i] != selectedCity)
      cities[i].draw(minPopulation, maxPopulation, minDensity, maxDensity, minAltitude, maxAltitude);
  }
  
  if (selectedCity != null)
    selectedCity.draw(minPopulation, maxPopulation, minDensity, maxDensity, minAltitude, maxAltitude);
    
  popSlider.update();
  popSlider.display();
  
  //println(popSlider.getPos());
}

void readData() {
  String[] lines = loadStrings("./villes.tsv");
  parseInfo(lines[0]); // read the header line
  
  x = new float[totalCount];
  y = new float[totalCount];
  cities = new City[totalCount-2];
  
  for (int i = 2 ; i < totalCount ; ++i) {
    String[] columns = split(lines[i], TAB);
    float population;
    /*if (float (columns[5]) < 200000) population = random(maxPopulation - 200000) + 200000;
    else population = float (columns[5]);*/
    x[i-2] = float (columns[1]);
    y[i-2] = float (columns[2]);
    cities[i-2] = new City(int (columns[0]), float (columns[1]), float (columns[2]), mapX(float (columns[1])), mapY(float (columns[2])), columns[4], Math.max(float(columns[5]), 1), float (columns[6]), float (columns[7]));
  }
  
  minDensity = cities[0].density;
  maxDensity = cities[0].density;
  
  for (City c : cities) {
    if (c!= null && c.density < minDensity)
      minDensity = c.density;
    
    if (c!= null && c.density > maxDensity)
      maxDensity = c.density;
  }
  
  
}

void parseInfo(String line) {
  String infoString = line.substring(2); // remove the #
  String[] infoPieces = split(infoString, ',');
  totalCount = int(infoPieces[0]);
  minX = float(infoPieces[1]);
  maxX = float(infoPieces[2]);
  minY = float(infoPieces[3]);
  maxY = float(infoPieces[4]);
  minPopulation = Math.max(float(infoPieces[5]), 1); // Il est raisonnable de penser qu'une ville a au moins 1 habitant.
  maxPopulation = float(infoPieces[6]);
  minSurface = float(infoPieces[7]);
  maxSurface = float(infoPieces[8]);
  minAltitude = float(infoPieces[9]);
  maxAltitude = float(infoPieces[10]);
}

float mapX(float x) {
  return map(x, minX, maxX, 50, 750);
}

float mapY(float y) {
  return map(y, minY, maxY, 750, 50);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP)
      minPopulationToDisplay *= 2;
    else if (keyCode == DOWN && minPopulationToDisplay > 1)
      minPopulationToDisplay /= 2;
      
    redraw();
  }
}

void mouseMoved() {
  City c = pick(mouseX, mouseY);
  
  if (c == null && selectedCity != null) {
    selectedCity.isSelected = false;
    selectedCity = null;
    redraw();
  }
  
  if (c != null && (selectedCity == null || c.name != selectedCity.name)) {
    println(c.name);
    
    if (selectedCity != null)
      selectedCity.isSelected = false;
      
    c.isSelected = true;
    selectedCity = c;
    
    redraw();
  }
  
}

City pick(int px, int py) {
  City pickedCity = null;
  
  for (int i = cities.length-1 ; i >= 0  ; i--) {
    if (cities[i].population >= minPopulationToDisplay && cities[i].contains(px, py)) {
      pickedCity = cities[i];
      break;
    }
  }
  
  return pickedCity;
}