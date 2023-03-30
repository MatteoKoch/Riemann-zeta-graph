float xa = -20;
float xe = 20;
float ya = -100;
float ye = 100;
float stepx, stepy;

void setup() {
  size(1900, 1000);
  colorMode(HSB);
  stepx = (xe - xa) / (width/2);
  stepy = (ye - ya) / (height/2);
}

void draw() {
  background(0);
  drawzeta();
  drawgrid();
  println("done");
  noLoop();
}

void drawzeta() {
  float sav;
  for(float x = xa; x < xe; x+=stepx) {
    for(float y = ya; y < ye; y+=stepy) {
      if((sav = (x>1?zeta2(x, y):zeta(x, y))) < 100000) {
        fill((int)map(sav, 0, 1, 0, 360), 360, 360);
        ellipse(translateX(x), translateY(y), 3, 3);
      }
    }
  }
}

void drawgrid() {
  String yvalue, xvalue;
  fill(255);
  for(float y = 0; y < 20; ++y) {
    stroke(100);
    line(y*width/20, 0, y*width/20, height);
    yvalue = String.format("%.2f", (y*(ye-ya)/20)+ya);
    text(yvalue+'i', width/2, y*width/20);
  }
  for(float x = 0; x < 20; ++x) {
    stroke(100);
    line(0, x*height/20, width, x*height/20);
    xvalue = String.format("%.2f", (x*(xe-xa)/20)+xa);
    text(xvalue, x*width/20, height/2);
  }
  stroke(255);
  line(width/2, 0, width/2, height);
  line(0, height/2, width, height/2);
}

int translateX(float a) {
  return (int)map(a, xa, xe, 0, width);
}

int translateY(float b) {
  return (int)map(b, ya, ye, height, 0);
}

float fak(float n) {
  float prod = 1;
  for(float i = 2; i <= n; ++i) prod *= i;
  return prod;
}

float rinv(float a, float b) {
  return (a / ((a*a)+(b*b)));
}

float iinv(float a, float b) {
  return -(b / ((a*a)+(b*b)));
}

float rpow(float r, float a, float b) {
  return pow(r, a) * cos(log(r)*b);
}

float ipow(float r, float a, float b) {
  return pow(r, a) * sin(log(r)*b);
}

float zeta(float a, float b) {
  float sum = 0;
  
  float real = rinv(1-rpow(2, 1-a, b), ipow(2, 1-a, b));
  float im = iinv(1-rpow(2, 1-a, b), ipow(2, 1-a, b));
  
  float sumreal = 0;
  float sumim = 0;
  float sumreal2;
  float sumim2;
  
  for(float n = 0; n < 20; ++n) {
    sumreal2 = 0;
    sumim2 = 0;
    for(float k = 0; k <= n; ++k) {
      float elem = pow(-1, k) * (fak(n) / (fak(k) * fak(n-k)));
      sumreal2 += elem * rinv(rpow(k+1, a, b), ipow(k+1, a, b));
      sumim2 += elem * iinv(rpow(k+1, a, b), ipow(k+1, a, b));
    }
    sumreal += (1 / pow(2, n+1)) * sumreal2;
    sumim += (1 / pow(2, n+1)) * sumim2;
  }
  real *= sumreal;
  im *= sumim;
  sum = abs(real) + abs(im);
  return sum;
}

float zeta2(float a, float b) {
  float sumr = 0;
  float sumi = 0;
  float shortr, shorti;
  for(float n = 1; n < 20; ++n) {
    shortr = pow(n, a) * cos(log(n)*b);
    shorti = pow(n, a) * sin(log(n)*b);
    sumr = shortr / (shortr*shortr - shorti*shorti);
    sumi = shorti / (shortr*shortr - shorti*shorti);
  }
  return abs(sumr)+abs(sumi);
}
