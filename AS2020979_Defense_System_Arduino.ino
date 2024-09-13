
/* 
Project    : Arduino Project - Defense System
Student ID : AS2020979
Name       : K.D.Y.Niwarthana
*/


//LIBARIES

#include <Servo.h>
#include <math.h>

//Pin declarations

int trigPin = 8;
int echoPin = 9;
int laserPin = 10;
int redLED = 3;
int blueLED = 4;
int greenLED = 5;
int yellowLED = 6;
int orangeLED = 7;

//Varible declaration
long duration;
int distance;
Servo myServo; //for rotate ultrasonic sensor
Servo myServo2; //for rotate laser
int targetAngle = 0;
double targetAngleDegrees;

int angle1to40 = 0;  // Angle when distance is between 1-40
int loopCount = 0;  // Counter for the number of loop iterations


//Setup 
void setup() {
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(laserPin, OUTPUT);
  pinMode(redLED, OUTPUT);
  pinMode(blueLED, OUTPUT);
  pinMode(greenLED, OUTPUT);
  pinMode(yellowLED, OUTPUT);
  pinMode(orangeLED, OUTPUT);

  digitalWrite(laserPin, LOW); 
  Serial.begin(9600);
  myServo.attach(2);
  myServo2.attach(12);
  myServo2.write(0);
  myServo.write(0);
}

//Function for calculate distance and get target angle
void calculateDistance() {

  //distance calculation
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH);
  distance = duration * 0.034 / 2;

  //calculate target angle for laser using sin Rule
  if (distance >= 1 && distance <= 40) {
    angle1to40 = myServo.read(); //get the current angle
    double targetAngle = atan((distance*sin(angle1to40)) / (10 - (distance * cos(angle1to40))));
    // Convert radians to degrees
    targetAngleDegrees = targetAngle * 180.0 / M_PI;
  } 

}

//Function for laser pointer shooting dimostration
void Shooting(){
    loopCount++; 
    // Update myServo2 when one full rotation of myServo is complete only
    if (loopCount == 1) {
      myServo2.write(180 - targetAngleDegrees); //Target angle is the angle from 180. To ge the rotate angle minus it from 180
      digitalWrite(laserPin, HIGH); //on laser
      loopCount = 0; 
      delay(4000);
      digitalWrite(laserPin, LOW);
      myServo2.write(0); // Reset the position
      loopCount = 0; //reset loop count
    }
  }

//FDunction to control LEDs
void controlLEDs() {
  if (distance > 40) {
    digitalWrite(greenLED, HIGH);
    digitalWrite(blueLED, LOW);
    digitalWrite(yellowLED, LOW);
    digitalWrite(orangeLED, LOW);
    digitalWrite(redLED, LOW);
  } else if (distance >= 30 && distance <= 40) {
    digitalWrite(greenLED, LOW);
    digitalWrite(blueLED, HIGH);
    digitalWrite(yellowLED, LOW);
    digitalWrite(orangeLED, LOW);
    digitalWrite(redLED, LOW);
  } else if (distance >= 20 && distance < 30) {
    digitalWrite(greenLED, LOW);
    digitalWrite(blueLED, LOW);
    digitalWrite(yellowLED, HIGH);
    digitalWrite(orangeLED, LOW);
    digitalWrite(redLED, LOW);
  } else if (distance >= 10 && distance < 20) {
    digitalWrite(greenLED, LOW);
    digitalWrite(blueLED, LOW);
    digitalWrite(yellowLED, LOW);
    digitalWrite(orangeLED, HIGH);
    digitalWrite(redLED, LOW);
  } else if (distance >= 0 && distance < 10) {
    digitalWrite(greenLED, LOW);
    digitalWrite(blueLED, LOW);
    digitalWrite(yellowLED, LOW);
    digitalWrite(orangeLED, LOW);
    digitalWrite(redLED, HIGH);
  }
}


void loop() {
  // Increment the loop count for each iteration to degree by degree unlit 180
  for (int i = 0; i <= 180; i++) {
    myServo.write(i);
    delay(30);
    calculateDistance(); //calculate distanse
    controlLEDs(); //call led function

    //print distance and angle to use in processor code. Used "," and "." to seperate each record
    Serial.print(i);
    Serial.print(",");
    Serial.print(distance); 
    Serial.print(".");

  }

  delay(3000);
  Shooting();

  //go back to 0 from 180

  for (int i = 180; i > 0; i--) {
    myServo.write(i);
    delay(180);
    calculateDistance();
    controlLEDs();
    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }

}

