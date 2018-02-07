// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com
import processing.video.*;
import boofcv.processing.*;
import boofcv.struct.image.*;
import java.util.*;
import boofcv.alg.filter.binary.*;
import  georegression.struct.point.*;


PImage img, imgContour, imgBlobs, redImg; 
int i = 0, X=0;
float coordX, coordY;
float w, h;
float centerX, centerY;
float p1X, p1Y=0, p2X=0, p2Y=0, p3X=0, p3Y=0;
float r;
int twoPoints = 0;
int xPoint;
int yPoint;
Point center = new Point(0,0);
double threshold;
boolean rectangleReady;
Point A = new Point(100, 100);
Point B = new Point(100,100); 
Point C = new Point(100,100);
void setup() {
    img = loadImage("andrea1.jpg");
    size(800, 800);
  }


void draw() {
  background(0);
  image(img, 0, 0);
  
  // extract contours
  SimpleGray gray = Boof.gray(img,ImageDataType.F32);

  gray = gray.blurMean(2); 
  threshold = gray.mean();

  // find blobs and contour of the particles
  ResultsBlob results = gray.threshold(threshold,true).erode8(1).contour();

  // Visualize the results
  imgContour = results.getContours().visualize();
  List <Contour> list = results.contour;
  
  for(Contour c: list){
    for(Point2D_I32 p : c.external){
      if(p1X>p.x){
        p1X = p.x;
        p1Y = p.y;
        A = new Point(p1X,p1Y);
      } else if(p2X<p.x){
        p2X = p.x;
        p2Y = p.y;
        B = new Point(p2X,p2Y);
      }
      if(p3Y<p.y){
        p3X = p.x;
        p3Y = p.y;
        C = new Point(p3X,p3Y);
      }
    }  
  }
  //ellipse(p1X, p1Y, 10, 10);
  //ellipse(p2X, p2Y, 20, 20);
  //ellipse(p3X, p3Y, 30, 30);

  //  image(imgContour,0,0);
    tint(255, 127);

   drawCircle(B, A, C);
   drawRec(A, B, C);
   drawTriangle(A, B, C);
   drawPentagon();
   p1X = 1000;
   p1Y=0;
   p2X=0;
   p2Y=0;
   p3X=0;
   p3Y=0;
}


void drawRec(Point A, Point B, Point C){
    rectMode(CORNER);
    float w = B.x - A.x;
    float h = C.y - A.y;
    stroke(0, 190, 20);
    rect(A.x, A.y, w, h);
    noFill();
}

void drawTriangle(Point A, Point B, Point C){
    float d_w = abs(A.x - B.x)/2 + A.x;
    float d_h = abs(A.y - C.y) + A.y;
    Point D = new Point(d_w, d_h);
    stroke(50, 0, 200);
    triangle(A.x, A.y, B.x, B.y, D.x, D.y);
    noFill();
}

void drawPentagon(){
    stroke(210, 100, 0);
    beginShape();
    Point v1 = new Point((cos(PI/2)*r)+center.x, center.y-(sin(PI/2)*r));
    Point v2 = new Point((cos(9*PI/10)*r)+center.x, center.y - (sin(9*PI/10)*r));
    Point v3 = new Point((cos(13*PI/10)*r)+center.x, center.y - (sin(13*PI/10)*r));
    Point v4 = new Point((cos(-3*PI/10)*r)+center.x, center.y - (sin(-3*PI/10)*r));
    Point v5 = new Point((cos(PI/10)*r)+center.x, center.y - (sin(PI/10)*r));
    vertex(v1.x, v1.y);
    vertex(v2.x, v2.y);
    vertex(v3.x, v3.y);
    vertex(v4.x, v4.y);
    vertex(v5.x, v5.y);
    endShape(CLOSE);
    noFill();
}

void drawCircle(Point A, Point B, Point C){
    float dy_AB = abs(B.y - A.y);
    float dx_AB = abs(B.x - A.x);
    float dy_BC = abs(C.y - A.y);
    float dx_BC = abs(C.x - A.x);
    strokeWeight(4);
    stroke(125, 0, 200);
    float aSlope = dy_AB/dx_AB;
    float bSlope = dy_BC/dx_BC;  
    center.x = (aSlope*bSlope*(A.y - C.y) + bSlope*(A.x + B.x)
       - aSlope*(B.x+C.x) )/(2* (bSlope-aSlope) );
       if (aSlope != 0){
          center.y = -1*(center.x - (A.x+B.x)/2)/aSlope +  (A.y+B.y)/2;
       } else {
          center.y = -1 * (center.x - (B.x + C.x) / 2) / bSlope +  (B.y + C.y) / 2;
       }
    
    r = sqrt((center.x-C.x)*(center.x-C.x) + (center.y-C.y)*(center.y-C.y));
    ellipse(center.x, center.y, 2*r, 2*r);


  noFill();
}