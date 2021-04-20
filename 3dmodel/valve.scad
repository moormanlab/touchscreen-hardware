//-- Valve Mainfold
//-- Ariel Burman 
//-- Moorman Lab, University of Massachusetts Amherst
//-- v1.0 - April 2021

use <utils.scad>;

valveD = 6.38;//6.27  //6.35 6.38 too tight
valveH = 6.5;
hoseOutD  =  1.7; // form mainfold A, outter diam of a house going inside the hole
hoseInD  = 1.8; // for mainfold B, sligly less than inner diam of a hose that goes over the port
portA = 3.18;

module socket() {
  socketL =  7.4;//7.14; //7.3 needed adjustment, testing 7.4
  roundedD = 4;// 5.5 was to big radius, testing 5.2// 5.2 last print but I think 4 is better
  thick = .75;
  translate([0,-roundedD/4,thick/2])cube([socketL,socketL-roundedD/2,thick],center=true);
  hull() {
    translate([(socketL-roundedD)/2,(socketL-roundedD)/2,thick/2])cylinder(h=thick,d=roundedD,$fn=50,center=true);
    translate([-(socketL-roundedD)/2,(socketL-roundedD)/2,thick/2])cylinder(h=thick,d=roundedD,$fn=50,center=true);
  }
}

module ORing(rad,h){
  rotate_extrude(convexity=10,$fn=50) 
  translate([rad,0,0])
  circle(d=h,$fn=100);
}

module valve() {
  translate([0,0,.75])cylinder(h=10,d=7.14,$fn=50);
  translate([0,0,])scale([.95,.95,1])socket();
  translate([0,0,-2])cylinder(h=2,d=6.27,$fn=50);
  translate([0,0,-1.1])ORing(2.4,1.8);

  translate([0,0,-3.18])difference(){
    cylinder(h=2.4,d=5.4,$fn=50,center=true);
    cylinder(h=6,d=1,$fn=50,center=true);
    rotate([90,0,0])cylinder(h=6,d=1.6,$fn=50,center=true);
  }
  translate([0,0,-5.1])ORing(2.4,1.8);
  translate([0,0,-6.4])difference(){
    union(){
      translate([0,0,.2])cylinder(h=2,d=6.2,$fn=50);
      cylinder(h=.2,d2=6.2,d1=5.5,$fn=50);
    }
    translate([0,0,-.1])cylinder(h=2.4,d=1.6,$fn=50);
  }
  
}


bottomTick=2;  //original 8
cubeH=bottomTick+valveH+.8;
wallTick = 2;  //original 8

module mainfoldA() {
  difference() {
    translate([0,0,cubeH/2])cube([2*wallTick+valveD,2*wallTick+valveD,cubeH],center = true);
    //valve holes
    translate([0,0,bottomTick+10])cylinder(h=20,d=valveD,$fn=100,center = true);
    translate([0,0,bottomTick-.2+0.0001])cylinder(h=.4,d2=valveD,d1=valveD*.9,$fn=100,center = true);
    translate([0,0,bottomTick+valveH])scale([1,1,10])socket();
    
    //ports holes
    translate([0,(wallTick+valveD)/2,bottomTick+3.18])rotate([90,0,0])cylinder(h=wallTick+1,d1=hoseOutD,d2=1.8,$fn=40,center=true);
    translate([0,0,bottomTick+3.18])ORing(rad=3,h=2.2);
    translate([0,0,bottomTick/2])cylinder(h=bottomTick+1,d1=hoseOutD,d2=1.8,$fn=40,center=true);
  }
}


portOD = 3.3;
portID = 1.9;


module mainfold() {
  portExt = 5; //original 3

  difference() {
    union(){
      translate([0,0,cubeH/2])cube([2*wallTick+valveD,2*wallTick+valveD,cubeH],center = true);
      //port external
      translate([0,wallTick+valveD/2+portExt/2-.01,bottomTick+portA])rotate([90,0,0]){
        cylinder(h=portExt,d1=portOD,d2=portOD+.4,$fn=100,center=true);
        translate([0,0,-portExt/2])torus((portOD-portID)/2,(portOD+portID)/2);
      }
      translate([0,0,-portExt/2]){
        cylinder(h=portExt,d1=portOD,d2=portOD+.4,$fn=100,center=true);
        translate([0,0,-portExt/2])torus((portOD-portID)/2,(portOD+portID)/2);
      }
    }
    //valve holes
    translate([0,0,bottomTick+10])cylinder(h=20,d=valveD,$fn=100,center = true);
    translate([0,0,bottomTick-.2+0.0001])cylinder(h=.4,d2=valveD,d1=valveD*.9,$fn=100,center = true);
 
    translate([0,0,bottomTick+valveH])scale([1,1,10])socket();
    
    //ports holes
    translate([0,(wallTick+valveD)/2+portExt/2-.08,bottomTick+portA])rotate([90,0,0])cylinder(h=wallTick+portExt+.2,d=portID,$fn=40,center=true);
    *translate([0,0,bottomTick+3.18])ORing(rad=3,h=2.2);
    translate([0,0,bottomTick/2-portExt/2-.2])cylinder(h=bottomTick+portExt-.3,d=portID,$fn=40,center=true);
  }
}

*translate([0,0,8.4+15])valve();
mainfold();

difference(){
  union(){
*    color("red")translate([0,0,8.4])valve();
    mainfold();
  }
  translate([25,0,0])cube([50,50,50],center=true);
}