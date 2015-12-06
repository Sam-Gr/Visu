class City {
  
  int postalCode;
  float x;
  float y;
  float windowX;
  float windowY;
  String name;
  float population;
  float surface;
  float altitude;
  float density;
  
  boolean isSelected;
  
  private float ellipseRadius;
  
  public City(int pc, float x, float y, float windowX, float windowY, String name, float population, float surface, float altitude) {
    this.postalCode = pc;
    this.x = x;
    this.y = y;
    this.windowX = windowX;
    this.windowY = windowY;
    this.name = name;
    this.population = population;
    this.surface = surface;
    this.altitude = altitude;
    
    if (surface == 0) {
      this.surface = 0.1;
    }
    
    this.density = this.population / this.surface;
    
    this.isSelected = false;
  }
  
  public boolean contains(int px, int py) {
    return dist(this.windowX, this.windowY, px, py) <= this.ellipseRadius + 1;
  }

// put a drawing function in here and call from main drawing loop
  public void draw(float minPopulation, float maxPopulation, 
                   float minDensity, float maxDensity, 
                   float minAltitude, float maxAltitude ) {
    float ellipseArea, ellipseRadius;
    int saturation, hue;
    float strokeW;
    int rectHeight = 20;
    
    ellipseArea = map(this.population, minPopulation, maxPopulation, 4, 10000);
    this.ellipseRadius = sqrt(ellipseArea / PI);
    
    colorMode(HSB, 255, 255, 255);
    //saturation = (int) map(this.density, minDensity, maxDensity, 0, 255);
    saturation = (int) map(log(this.density), 5, log(maxDensity), 0, 255);
    
    //println(log(this.density) + " " + log(minDensity) + " " + log(maxDensity));
    
    //strokeW = map(this.altitude, minAltitude, maxAltitude, 1, 10);
    //strokeW = 3;
    
    if (isSelected) {
      strokeW = 4;
      fill(70, 96, 255, 192);
      strokeWeight(0);
      rect(this.windowX + this.ellipseRadius + strokeW, this.windowY - rectHeight/2, textWidth(this.name), rectHeight);
      fill(0,0,0);
      textAlign(LEFT, CENTER);
      textSize(16);
      text(this.name, this.windowX + this.ellipseRadius + strokeW, this.windowY);
      strokeWeight(strokeW);
      //stroke(35, 255, 255);
      stroke(0, 0, 0);
    } else {
      strokeW = 1;
      strokeWeight(strokeW);
      stroke(0, 0, 0);
    }
    
    fill(7, saturation, 255, 212);
    
    ellipse(this.windowX, this.windowY, this.ellipseRadius*2, this.ellipseRadius*2);
  }
}