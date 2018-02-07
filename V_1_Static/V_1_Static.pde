
// Global variables
int x;
PImage img;

void setup(){
size(640,427);
img = loadImage("leonardo.jpg");

}

// Main draw loop
void draw(){
  background(255);
  // Draw the image to the screen at coordinate (0,0)
  image(img,0,0, width, height);

//ellipse(320,215, 400, 400);
ellipse(width/2,height/2, 400, 400);
strokeWeight(5);
fill(0.0,0.0,0.0, 1.0);
stroke(255, 0, 0.0);

rect(width/2,height-175,325 ,325);
fill(0.0,0.0,0.0, 1.0);
stroke(0, 255, 0.0);
rectMode(CENTER);

triangle(160, 415, 320, 130, 480, 415);
fill(0.0,0.0,0.0, 1.0);
stroke(0, 0, 255);

ellipse(mouseX,mouseY,50,50);
fill(0.0,0.0,1.0, 1.0);
//rectMode(CENTER);

  
  
}