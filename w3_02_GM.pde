/*
 * Creative Coding
 * Week 3, 02 - array with sin()
 * by Indae Hwang and Jon McCormack
 * Updated 2016
 * Copyright (c) 2014-2016 Monash University
 *  
 * Modified by GrandeMago, AUG 2016
 * This program demonstrates the use of arrays.
 * It creates three arrays that store the y-position, speed and phase of some oscillating circles.
 * You can change the number of circles by changing the value of num in setup()
 * 
 * When user click on circles he/she makes it stop/resume movement and change color
 * Now circles stops at present position when clicked, without any jumping to a different spot
 * 
 */

int     noCircles;    // the number of items in the array (# of circles)
float[] y;      // y-position of each circle (fixed)
float[] speed;  // speed of each circle
float[] phase;  // phase of each circle
boolean[] moving;  //  used to keep track of circles' status: moving/stationary
int[] counter;  // I preferred to use a dedicated counter that can be stopped/resumed versus frameCounter
                // this solve also the "stop and jumping" issue of the original sketch
int[] hue;  //  color control
float gap;  // now a global variable, used to control circle size and evaluate distance

void setup() {
  size(500, 500);
  colorMode(HSB, 360, 100, 100, 100);

  noCircles = 6;

  // allocate space for each array
  y = new float[noCircles];
  speed = new float[noCircles];
  phase = new float[noCircles]; 
  moving = new boolean[noCircles];
  counter = new int [noCircles];
  hue = new int [noCircles];

  // calculate the vertical gap between each circle based on the total number of circles
  gap = height / (noCircles + 1);

  //setup an initial value for each item in the array
  for (int i=0; i<noCircles; i++) {
    y[i] = gap * (i + 1);      // y is constant for each so can be calculated once
    speed[i] = random(6);
    phase[i] = 0;//random(TWO_PI);
    moving[i] = true;
    counter[i] = 1;
    hue[i] = 136; //  green
    noStroke();
  }
}

void draw() {
  background(0, 0, 90);
  println(frameRate);

  for (int i=0; i<noCircles; i++) {
    if(moving[i]) {
      counter[i] ++;
    }
      
    // calculate the x-position of each ball based on the speed, phase and current frame
    float x = width/2 + sin(radians(counter[i]*speed[i] ) + phase[i])* 200;
    fill(hue[i], 75, 80);
    ellipse(x, y[i], gap*.9, gap*.9);
  }
}

//  check if a circle is clicked
//  I preferred mousepressed to mouseclicked because of a better responsiveness (stopping action 
//  happens after one click versus one click + one release)
void mousePressed() {
  for(int i = 0; i<noCircles; i++) {
    float x = width/2 + sin(radians(counter[i]*speed[i] ) + phase[i])* 200;
    float d = dist(x, y[i], mouseX, mouseY);
    // if distance between mouse and center of circle is less than radius than mouse is over circle
    if(d< gap*.45) {
      if (moving[i]) {
        moving[i] = false;
        hue[i] = 0;  //  red
      } else {
        moving[i] = true;
        hue[i] = 120;
      }
    }
  }
}