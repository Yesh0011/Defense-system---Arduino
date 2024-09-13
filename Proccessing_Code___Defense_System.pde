//import libiaries
import processing.serial.*; //for serial comunication
import java.awt.event.KeyEvent; 
import java.io.IOException;


Serial myPort; //declare variable to manage serial communication with arduino board 

//variables for distance, angle and other data
String angle="";
String distance="";
String data="";

//for error handling
String noObject;

//variables for processed data
float pixsDistance;
int iAngle, iDistance;
int index1=0;
int index2=0;

void setup() {
  
 size (1280,720); //set display screen size to device resolution
 smooth();
 myPort = new Serial(this,"COM7", 9600); //get COM7 port for serial comunication at boud rate og 9600
 myPort.bufferUntil('.'); //get and store data until period occurs and call SerialEvent function to proccess buffer data

}

//when new data is available, this function will automatically called
void serialEvent (Serial myPort) { 

  data = myPort.readStringUntil('.'); //read data until period occurs
  data = data.substring(0,data.length()-1); //remove last character to ensure to remove period from proccessing
  
  //we get data like aqngle , distance. "," seperate both parties
  
  index1 = data.indexOf(","); //assign "," as index 1
  angle= data.substring(0, index1); //get angle from the data before ","
  distance= data.substring(index1+1, data.length()); //get distance like before by accessing the data after "," until the end of data
  
  
  iAngle = int(angle); //save angle as the numarical value from read data
  iDistance = int(distance); //save distance as the numarical value from read data
}

//main logic for sketch

void draw() {
  
  fill(98,245,31); //set default drawing color as green

  noStroke(); //remove outlines
  fill(0,4); //background color
  rect(0, 0, width, height-height*0.065); //to sketch fading lines set color
  
  //calling functions
  drawRadar(); 
  drawLine();
  drawObject();
  drawText();
}


void drawRadar() {
  pushMatrix();                             //save the current transformation matrix
  translate(width/2,height-height*0.074);   //centering the origin to the center of the canvas
  noFill();                                 //thsi will only have outline, but not filled lines
  strokeWeight(2);                          //set outline weight
  stroke(98,245,31);                        //set trocke color
  
  
  // draws the arc lines. (center of arc by first 0,0 , next set width and height, start and end angles of arc
  arc(0,0,(width-width*0.0625),(width-width*0.0625),PI,TWO_PI);
  arc(0,0,(width-width*0.27),(width-width*0.27),PI,TWO_PI);
  arc(0,0,(width-width*0.479),(width-width*0.479),PI,TWO_PI);
  arc(0,0,(width-width*0.687),(width-width*0.687),PI,TWO_PI);
  
  // Draw the angle lines at 10-degree intervals
  //stating point by 0,0  , use half od the canvus width as radius. minus because it starts from the bottom , then cos() point out the horizontal end point   and the get vertical end point by sin()
  for (int i = 0; i <= 180; i += 10) {
    float angleRad = radians(i);
    line(0, 0, (-width/2) * cos(angleRad), (-width/2) * sin(angleRad));
  }

  popMatrix();
}


//draw target object od ratadar graph
void drawObject() {
  pushMatrix();//save current transformation
  translate(width/2,height-height*0.074); //posistion the object center at the horizontal center.  this is common practice. 
  strokeWeight(9);
  stroke(255,10,10); // red color
  pixsDistance = iDistance*((height-height*0.1666)*0.025); //calculate the legth of the line to display 
  if(iDistance<40){
  line(pixsDistance*cos(radians(iAngle)),-pixsDistance*sin(radians(iAngle)),(width-width*0.505)*cos(radians(iAngle)),-(width-width*0.505)*sin(radians(iAngle)));
  //line( start point by the calculated length and cos andle to get x cordinator, then sin with y cordinator, then ending points
  }
  popMatrix();
}

//this get by the angle. same as above
void drawLine() {
  pushMatrix();
  strokeWeight(5);
  stroke(98,245,31);
  translate(width/2,height-height*0.074); 
  line(0,0,(height-height*0.12)*cos(radians(iAngle)),-(height-height*0.12)*sin(radians(iAngle)));
  popMatrix();
}


//draw texts in graph
void drawText() {
  
  pushMatrix();
  if(iDistance>40) {
  noObject = "No threat";
  }
  else {
  noObject = "Attack detected";
  }
  
  textSize(20);
 fill(255,200,10);
 text("Defense System",100,100);
 
  fill(255,255,255);
  noStroke();
  rect(0, height-height*0.0648, width, height);
  fill(0,255,0);
  textSize(25);
  text("10cm",width-width*0.3854,height-height*0.0833);
  text("20cm",width-width*0.281,height-height*0.0833);
  text("30cm",width-width*0.177,height-height*0.0833);
  text("40cm",width-width*0.0729,height-height*0.0833);
  
  textSize(40);
  fill(0,0,0);
  text("Object: " + noObject, width-width*0.875, height-height*0.0277);
  text("Angle: " + iAngle +" °", width-width*0.48, height-height*0.0277);
  text("Distance: ", width-width*0.26, height-height*0.0277);
  if(iDistance<40) {
  text("  " + iDistance +" cm", width-width*0.140, height-height*0.0277);
  }
  
  textSize(25);
  fill(98,245,60);
  translate((width-width*0.4994)+width/2*cos(radians(30)),(height-height*0.0907)-width/2*sin(radians(30)));
  rotate(-radians(-60));
  text("30°",0,0);
  resetMatrix();
  translate((width-width*0.503)+width/2*cos(radians(60)),(height-height*0.0888)-width/2*sin(radians(60)));
  rotate(-radians(-30));
  text("60°",0,0);
  resetMatrix();
  translate((width-width*0.507)+width/2*cos(radians(90)),(height-height*0.0833)-width/2*sin(radians(90)));
  rotate(radians(0));
  text("90°",0,0);
  resetMatrix();
  translate(width-width*0.513+width/2*cos(radians(120)),(height-height*0.07129)-width/2*sin(radians(120)));
  rotate(radians(-30));
  text("120°",0,0);
  resetMatrix();
  translate((width-width*0.5104)+width/2*cos(radians(150)),(height-height*0.0574)-width/2*sin(radians(150)));
  rotate(radians(-60));
  text("150°",0,0);
  popMatrix(); 
}
