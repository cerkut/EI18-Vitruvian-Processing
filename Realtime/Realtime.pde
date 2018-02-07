// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com
import processing.video.*;
import boofcv.processing.*;
import boofcv.struct.image.*;
import java.util.*;
import boofcv.alg.filter.binary.*;
import  georegression.struct.point.*;

// Declaring a variable of type PImage
// PImage is a class available from the Processing core library.
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
Capture cam;

void setup() {
  frameRate(30);
  // setup Camera
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
  println("There are no cameras available for capture.");
  exit();
  } else {
  println("Available cameras:");
  for (int i = 0; i < cameras.length; i++) {
    println(cameras[i]);
  }
    
  // The camera can be initialized directly using an 
  // element from the array returned by list():
  cam = new Capture(this, cameras[0]);
  cam.start(); 
  }
  p1X = 1000;
  size(640, 480);
}

void draw() {
  background(0);
  if (cam.available()) {
    cam.read();
  }
  image(cam, 0, 0);
  
  SimpleGray gray = Boof.gray(cam,ImageDataType.U8);
  // if too much noise, blur the image -> less accurate contour but less noise
  // gray = gray.blurMean(5);
  // find blobs and contour of the particles
  // some image processing that could be applied
  // gray = gray.enhanceSharpen4();
  gray = gray.blurGaussian(20, 8);
  
  // Threshold the image using its mean value
  threshold = gray.mean();
  ResultsBlob results = gray.threshold(threshold,true).erode8(1).contour();
  
  // other thresholding methods
  // ResultsBlob results = gray.thresholdSquare(40, .7,true).erode8(1).contour();
  // ResultsBlob results = gray.thresholdSauvola(10, .3,true).erode8(1).contour();
  // ResultsBlob results = gray.thresholdGaussian(40, .8,true).erode8(1).contour();

  // Visualize the results
  imgContour = results.getContours().visualize();
  
  // The image() function displays the image at a location
  // in this case the point (0,0).
  List <Contour> list = results.contour;
  
  // extract contours and perform maximization and minimization 
  // to extract reference points       
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
  // draw circle around reference points
  ellipse(p1X, p1Y, 10, 10);
  ellipse(p2X, p2Y, 20, 20);
  ellipse(p3X, p3Y, 30, 30);
  // draw geometrical shapes
  drawCircle(B, A, C);
  drawRec(A, B, C);
  drawTriangle(A, B, C);
  drawPentagon(A, B, C);
  if(mousePressed){
    redImg = gray.convert();
    image(redImg, 0, 0);
  } else{
    image(imgContour,0,0);
    tint(255, 127);
  }
   // reinitialize starting values for each frame
   p1X=1000; 
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

void drawPentagon(Point A, Point B, Point C){
    stroke(210, 100, 0);
    beginShape();
    Point v1 = new Point((cos(PI/2)*r)+center.x, center.y-(sin(PI/2)*r));
    Point v2 = new Point((cos(9*PI/10)*r)+center.x, center.y - (sin(9*PI/10)*r));
    Point v3 = new Point((cos(13*PI/10)*r)+center.x, center.y - (sin(13*PI/10)*r));
    Point v4 = new Point((cos(-3*PI/10)*r)+center.x, center.y - (sin(-3*PI/10)*r));
    Point v5 = new Point((cos(PI/10)*r)+center.x, center.y - (sin(PI/10)*r));
    //ellipse(v1.x, v1.y, 25, 25);
    //ellipse(v2.x, v2.y, 25, 25);
    //ellipse(v3.x, v3.y, 25, 25);
    //ellipse(v4.x, v4.y, 25, 25);
    //ellipse(v5.x, v5.y, 25, 25);
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
    
   // float r = sqrt(abs(center.x-A.x)*abs(center.x-A.x) + abs(center.y-A.y)*abs(center.y-A.y));
    r = sqrt((center.x-C.x)*(center.x-C.x) + (center.y-C.y)*(center.y-C.y));
   // print("  r:",r, "  X:", center.x, "   Y:", center.y, "  AB:",dy_AB, "  ABx:", dx_AB, "   Aslope:", aSlope, "  resta:", center.x-A.x);
    ellipse(center.x, center.y, 2*r, 2*r);
    ellipse(center.x, center.y, 20, 20);
    //ellipse(A.x, A.y, 10, 10);
    //ellipse(B.x, B.y, 10, 10);
    //ellipse(C.x, C.y, 10, 10);

  noFill();
}