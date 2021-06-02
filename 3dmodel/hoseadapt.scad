//-- Hose adapter
//-- Ariel Burman 
//-- Moorman Lab, University of Massachusetts Amherst
//-- v1.0 - April 2021

use <utils.scad>;

LB = 10;
LS = 7;
outDB = 5;
outDS = 3.3;
inDB = 3.5;
inDS = 1.9;

module hoseSizeAdaptor(){
  difference(){
    union(){
      cylinder(h=LB-1,d=outDB,$fn=100);
      torus(d1=(outDB-inDB)/2,d2=(outDB+inDB)/2);
      translate([0,0,LB-1-.001])cylinder(h=2+.002,d1=outDB,d2=outDS,$fn=100);
      translate([0,0,LB+1-.1])cylinder(h=LS-1+.1,d=outDS,$fn=100);
      translate([0,0,LB+LS])torus(d1=(outDS-inDS)/2,d2=(outDS+inDS)/2);
    }
    union(){
      translate([0,0,-.1])cylinder(h=LB-1+.102,d=inDB,$fn=100);
      translate([0,0,LB-1-.001])cylinder(h=2+.002,d1=inDB,d2=inDS,$fn=100);
      translate([0,0,LB+1-.001])cylinder(h=LS-1+.102,d=inDS,$fn=100);
    }
  }
}

module lickport(hS,hB,inD) {
  outD = inD + 1.5;
  hD = 3;
  difference(){
    union(){
      torus(d1=(hD-inD)/2,d2=(hD+inD)/2);
      // hose connection
      cylinder(h=hS,d=hD,$fn=100);
      translate([0,0,hS-.01])cylinder(h=hB+.01,d1=2*outD,d2=outD,$fn=100);
      translate([0,0,hS+hB-.01])torus(d1=(outD-inD)/2,d2=(outD+inD)/2);
    }
    translate([0,0,-.05])cylinder(h=hS+hB+.1,d=inD,$fn=100);
  }      
}

module lickportHolder(a,b,c){
  d = c + 1.5;
  difference(){
    translate([-.5,0,0])cube([4*d,2.2*d,d],center=true);
    scale([1.02,1.02,1.02])
    rotate([0,45,0])cylinder(h=b,d1=2*d,d2=d,$fn=100,center=true);
    %rotate([0,45,0])cylinder(h=b,d1=2*d,d2=d,$fn=100,center=true);
  }
  translate([1.5*d-.5,0,-d+.001])cube([d,2.2*d,d],center=true);
}

//lickport(4,10,1);
lickportHolder(4,10,1);

