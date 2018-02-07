// HAND IN I - EMBODIED INTERACTION
// Emil R. Høeg - 201253 15
//---------------------------------
// PURPOSE: draw the "human dimensions", made famous by Leonardo Da Vinci, around
// an image/video of yourself.

// TOOLS: I have used, and modified BLOB detection code by Mario Klingemann (<http://incubator.quasimondo.com)
// - Using the BlobDetection Library for Processing

import blobDetection.*;

BlobDetection theBlobDetection;
PImage img;

static boolean noEdge = true;
static boolean noBorder = true;

// ==================================================
// setup()
// ==================================================
void setup()
{
  // Works with Processing 1.5
   //img = createGraphics(640, 480,P2D);

  // Works with Processing 2.0b3
  //img = loadImage("emilLeo.jpg");
  img = loadImage("leonardo.png");


  theBlobDetection = new BlobDetection(img.width, img.height);
  theBlobDetection.setPosDiscrimination(false);
  theBlobDetection.setThreshold(2.80f);
  theBlobDetection.computeBlobs(img.pixels);

  // Size of applet
  size(640, 480);
}

// ==================================================
// draw()
// ==================================================
void draw()
{
  image(img, 0, 0, width, height);
  drawBlobsAndEdges(noBorder, noEdge);
}

// ==================================================
// drawBlobsAndEdges()
// ==================================================
void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges)
{
  noFill();
  Blob b;
  EdgeVertex eA, eB;
  for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++)
  {
    b=theBlobDetection.getBlob(n);
    if (b!=null)
    {
      // Edges
      if (drawEdges)
      {
        strokeWeight(1);
        stroke(0, 255, 0);
        for (int m=0;m<b.getEdgeNb();m++)
        {
          eA = b.getEdgeVertexA(m);
          eB = b.getEdgeVertexB(m);
          if (eA !=null && eB !=null)
            line(
            eA.x*width, eA.y*height, 
            eB.x*width, eB.y*height
              );
        }
      }

      // DRAW SQUARE
      if (drawBlobs)
      {
        strokeWeight(2);
        stroke(255, 0, 0);
        rect(
        b.xMin*width, b.yMin*height, 
        b.w*width, b.h*height
          );
      }
      
      // DRAW CIRCLE 
      if (drawBlobs)
      {
        strokeWeight(2);
        stroke(0, 0, 255);
        ellipse(
        (b.xMin*width)+(b.w*width/2), b.yMin*height+(b.h*height/2.5), // ellipsemode(CENTER) does not work, hence add 
        b.w*width+(b.yMin*height/1.5), b.h*height+(b.yMin*height/1.5)                                      // half of width/height to the x/y location to adjust.
          );
      }
      
      //DRAW TRIANGLE
      if (drawBlobs)
      {
        strokeWeight(2);
        stroke(255, 255, 0);
        triangle(        // upper point       // right point          // left point
        b.x*width, b.yMin*height+(height/6), b.xMax*width, b.yMax*height, b.xMin*width, b.yMax*height                                      
          );
      }
    }
  }
}