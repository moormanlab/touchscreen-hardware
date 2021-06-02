//-- Syringe Holder
//-- Ariel Burman 
//-- Moorman Lab, University of Massachusetts Amherst
//-- v1.0 - April 2021

syringeD = 16.2;
T = 1.8;
angle = 60;
$fn = 100;
slot = 3.5;
gripH = 5;
module syringeHolder(){
  difference(){
    union(){
      translate([0,-syringeD/2,0])cube([syringeD+2*T,syringeD,16],center=true);
      translate([0,0,0])cylinder(h=16,d=syringeD+2*T,center=true);
      translate([0,-syringeD,0])cube([6,6,gripH],center=true);
      hull(){
        translate([0,-syringeD,0])cube([6,1,gripH],center=true);
        translate([0,-syringeD+.5,0])cube([8,1,gripH+2],center=true);
      }
      translate([0,-syringeD-slot,0])hull(){
        for(i=[-1,1]) for(j=[-1,1]){
            translate([i*1.5,0,0])
            translate([0,j*(slot/2-.5),0]) cylinder(h=gripH,d=3,center=true);
        }
      }

    }
    cylinder(d=syringeD,h=16+.1,center=true,$fn=100);
    hull() {
      for (i=[0,1]) mirror([i,0,0])rotate([0,0,angle])translate([.5,syringeD/2,0])cube([1,syringeD,16.2],center=true);
      translate([0,syringeD,0])cube([1,2,16.2],center=true);
    }
    translate([0,-syringeD+slot/2+2,-8+2.5])cube([syringeD+2*T+.2,slot,5+.2],center=true);
    translate([0,-syringeD+slot/2+2,-8+5])rotate([0,90,0])cylinder(h=syringeD+2*T+.2,d=slot,center=true);
    
    translate([0,-syringeD-slot,0])hull(){
      for(i=[-1,1]) for(j=[-1,1]){
          translate([i*1.5,0,0])
          translate([0,j*(slot/2-.5),0]) cylinder(h=gripH+.1,d=1,center=true);
      }
    }
    translate([0,-syringeD-6,0])cube([3.5,6,gripH+.1],center=true);
      
  } 
  for (i=[0,1]) mirror([i,0,0]) {
    translate([(T+syringeD)/2*sin(angle),syringeD/6+syringeD/2*cos(angle),0])cube([T*sin(angle),syringeD/3,16],center=true);
    translate([(T+syringeD)/2*sin(angle),syringeD/3+syringeD/2*cos(angle),0])cylinder(d=T*sin(angle),h=16,center=true);
      
  }

  for (i=[-1,1]) {
    translate([i*2,-syringeD-5.616-.5,0])cube([1,1,gripH],center=true);
    translate([i*2,-syringeD-5.616-1,0])cylinder(d=1,h=gripH,center=true);
    translate([i*2,-syringeD-5.616,0])cylinder(d=1,h=gripH,center=true);
  }
}
syringeHolder();

//    translate([0,5.5,0])cube([1.5,14,16+.1],center=true);
//    translate([0,7.5,0])rotate([0,90,0])cylinder(d=3.06,h=10,center=true,$fn=100);
//    translate([mountSizeW/2-1,7,0])rotate([0,90,0])rotate([0,0,0])nutM3(globShow);
//    translate([-mountSizeW/2+2.95,7,0])rotate([0,90,0])rotate([0,0,0])screwM3(mountSizeW-3,globShow);