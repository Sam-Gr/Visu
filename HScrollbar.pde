class HScrollbar {
  int swidth, sheight;    // width and height of bar
  int cWidth, cHeight;    // width and height of the cursor
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;
  int borderStroke = 3;
  int [] popHistogram;
  int [] histHues;
  float histIntervalSize;
  int maxHistVal;
  int [] popGrads = {10, 100, 1000, 10000, 100000, 1000000};
  int [] nbVilleGrads = {100, 200, 300, 400};

  HScrollbar (float xp, float yp, int sw, int sh, int cw, int ch, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    xpos = xp;
    ypos = yp-sheight/2;
    sposMin = xpos + borderStroke / 2 + 1;
    sposMax = xpos + swidth - borderStroke / 2;
    spos = sposMin + (sposMax - sposMin) / 2;
    newspos = spos;
    cWidth = cw;
    cHeight = ch;
    loose = l;
  }

  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 0) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    int strokeCursorLine = 20;
    
    colorMode(HSB, 360, 100, 100);
    strokeWeight(borderStroke);
    stroke(50, 25, 50);
    fill(50, 25, 100);
    rect(xpos, ypos, swidth, sheight);
    
    float x=sposMin;
    int histHeight = this.sheight - this.borderStroke;
    strokeWeight(1);
    if (this.popHistogram != null) {
      for (int i=0 ; i<this.popHistogram.length ; i++, x++) {
        if (this.popHistogram[i] == 0) {
          continue;
        }
        
        float histValRatio = ((float) this.popHistogram[i]) / this.maxHistVal;
        //histValRatio = 1.0;
        stroke(this.histHues[i], 100, 95);
        
        line(x, ypos + sheight - this.borderStroke/2 - 1, x, ypos + this.borderStroke/2 + 1 + (histHeight * (1.0 - histValRatio)));
      }
    }
    
    // Axes
    colorMode(RGB, 255, 255, 255);
    fill(10,10,10);
    stroke(10,10,10);
    textSize(12);
    textAlign(CENTER,TOP);
    float yPopGrads = this.ypos + this.sheight + this.borderStroke / 2;
    line(sposMin, yPopGrads, sposMin, yPopGrads + 10);
    text("0", sposMin, yPopGrads+12);
    
    for (int i=0 ; i < this.popGrads.length ; i++) {
      float xPopGrad = sposMin + log(this.popGrads[i]) / this.histIntervalSize;
      line(xPopGrad, yPopGrads, xPopGrad, yPopGrads + 10);
      text(this.popGrads[i], xPopGrad, yPopGrads+12);
    }
    
    float xNbVilleGrads = this.xpos - this.borderStroke/2;
    float ynbVilleGrad = ypos +this.borderStroke/2 + 1 + histHeight;
    textAlign(RIGHT, CENTER);
    text("0", xNbVilleGrads-12, ynbVilleGrad);
    line(xNbVilleGrads-10, ynbVilleGrad, xNbVilleGrads, ynbVilleGrad);
    
    for (int i=0 ; i<this.nbVilleGrads.length ; i++) {
      float histValRatio = ((float) this.nbVilleGrads[i]) / this.maxHistVal;
      ynbVilleGrad = ypos +this.borderStroke/2 + 1 + histHeight*(1.0 - histValRatio);
      text(this.nbVilleGrads[i], xNbVilleGrads-12, ynbVilleGrad);
      line(xNbVilleGrads-10, ynbVilleGrad, xNbVilleGrads, ynbVilleGrad);
    }
    
    textSize(18);
    textAlign(CENTER,TOP);
    text("Nombre d'habitants", xpos + swidth / 2, ypos + sheight + 30);
    textAlign(CENTER,CENTER);
    pushMatrix();
    translate(xpos - 55, ypos + sheight / 2);
    rotate(-HALF_PI);
    text("Nombre de villes", 0,0);
    popMatrix();
    
    // Curseur
    colorMode(RGB, 255, 255, 255);
    if (over || locked) {
      stroke(255, 64, 64);
      strokeWeight(2);
    } else {
      stroke(128);
      strokeWeight(1);
    }
    
    fill(102, 102, 102, 32);
    rectMode(CENTER);
    rect(spos, ypos + sheight/2, cWidth, cHeight);
    rectMode(CORNER);
    stroke(strokeCursorLine);
    strokeWeight(1);
    line(spos, ypos - (cHeight - sheight)/2, spos, ypos - (cHeight - sheight)/2 + cHeight);
    
    
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos - sposMin;
  }
  
  float getVal() {
    float pos = this.getPos();    
    float threshold = exp(pos * histIntervalSize);
    
    return threshold;
  }
  
  /*void setVal(float newVal) {
    this.spos = log(newVal)/this.getPos();
    this.spos = constrain(this.spos, this.sposMin, this.sposMax);
  }*/
  
  void makeHistogram(City[] cities, float minPopulation, float maxPopulation) {
    int nbBins = this.swidth - this.borderStroke;
    this.histIntervalSize = log(maxPopulation - minPopulation) / nbBins;
    println(maxPopulation);
    println(log(minPopulation));
    this.popHistogram = new int[nbBins];
    this.histHues = new int[nbBins];
    
    for (int i = 0 ; i < cities.length ; i++) {
      int idx = (int) Math.floor(log(cities[i].population) / histIntervalSize);
      idx = Math.min(idx, nbBins - 1);
      
      this.popHistogram[idx]++;
    }
    
    float hueStep = 120.0 / nbBins;
    
    this.maxHistVal = -1;
    for (int i=0 ; i < nbBins ; i++) {
      this.histHues[i] = 120 - Math.round(i*hueStep);
      if (this.popHistogram[i] > this.maxHistVal)
        this.maxHistVal = this.popHistogram[i] ;
    }
  }
  
}