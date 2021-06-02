//-- IR Sensors
//-- Ariel Burman 
//-- Moorman Lab, University of Massachusetts Amherst
//-- v1.0 - April 2021

use <utils.scad>;

module adafruitIRsensor(){
  translate([4,0,0])r2cube([12,10,8],r=1.5,fn=32,center=true);
  translate([-4,0,0])cube([12,10,8],center=true);
  translate([5,0,4])cylinder(h=0.6,d=8,$fn=64);
  translate([5,0,4])cylinder(h=1,d=3,$fn=64);
  translate([5,0,5])sphere(d=3,$fn=64);
}

module adafruitSensorCase(W=6,show=false){
  //difference(){
    translate([0,-5,0])
    union(){
      //translate([0,0,0])cube([53,5,25],center=true);
      for(i=[0,1])mirror([i,0,0])
        {
        translate([W/2,0,0])difference(){
          r2cube([10,20,13],r=1.5,fn=64,center=false);
          translate([1.6,-1.25,1.25])cube([10,20,10.5]);
          translate([9,-1.25,-.5])cube([2,22,14]);
          translate([-1,-1.25,-.5])cube([12,6,14]);
          
          translate([1,20-1.5-4-1,13/2])rotate([0,90,0])cylinder(h=0.65,d=8,$fn=64);
          translate([-.1,20-1.5-4-1,13/2])rotate([0,90,0])cylinder(h=1.2,d=3,$fn=32);
        }
        if (show)  %translate([W/2+5.6,8.5,5+1.5])rotate([-90,0,90])adafruitIRsensor();
      }
      translate([0,5.75,13/2])cube([W+.2,2,13],center=true);
    }
}

!adafruitSensorCase(W=12,show=true);

module sparkfunIR(){
  cube([4.4,1.5,5.7], center=true);
  translate([0,.75,5.7/2-1.22])sphere(r=.75,$fn=64);
  translate([ 1.27, 0,(-12.7-5.7)/2])cube([.5,.5,12.7],center=true);
  translate([-1.27, 0,(-12.7-5.7)/2])cube([.5,.5,12.7],center=true);
}

*sparkfunIR();

module sparkfunSensorCase(W=6,depth=8,show=false){
  D = depth;
  assert (depth >= 4);
  for(i=[0,1])mirror([i,0,0])translate([W/2,0,0])translate([2,0,0]){
    difference(){
      translate([0,0,0])r2cube([4,depth+1,5.8],r=1,fn=64,center=true);
      translate([.75,0,0])cube([3,depth,4.8],center=true);
      translate([2,0,0])cube([2,depth+2,6],center=true);
      translate([0,-depth/2-.5,0])cube([6,2,6],center=true);
          
      translate([-2.1,depth/2-1.22,0])rotate([0,90,0])cylinder(h=2,d=1.53,$fn=32);
    }
    if (show) %translate([0,-5.7/2+depth/2,0])rotate([-90,90,0])sparkfunIR();
  }
  translate([0,-depth/2+1,0])cube([W+1,1,5.8],center=true);
}

*sparkfunSensorCase(W=8,show=true,depth=8);

