//-- Touchscreen Behaviour Training Case
//-- Ariel Burman 
//-- Moorman Lab, University of Massachusetts Amherst
//-- v1.2 - April 2021

use <utils.scad>;
use <hoseadapt.scad>;
use <sensors.scad>;

use <threadlib/threadlib.scad>
// https://github.com/adrianschlatter/threadlib

globalShow = true;
TAU = 2*PI;

// case
tilt = 25;
assert (tilt >= 0 && tilt <= 30);
rcase = 8;  // ideal 8
caseWallThick = 2; // ideal 2
caseD = 100;
//there should be a minimum caseD
//assert (caseD >= XX);
caseGap = 1;
addReward = true;
sideRewardW = 18;

// case reel
reelW=3;
reelH=4;
reelL=30;

// case latchs
latchW = 10;
latchL = 20;
latchR = 7;
latchT = 2;

// touchscreen
touchW = 121;
touchH = 76;
touchD = 7.8;
touchSdx = 58;
touchSdz = 49;
touchSxp = 41.5;

// touchenclousure
encThick = 1.5;
encGap = 2; //total (left+right / up+down)

openingD = 12;
openingH = 6;

ext_switch_d = 13;
ext_switch_oh = 6;
ext_switch_ih = 25;

//https://osoyoo.com/driver/dsi_screen/5inch-dsi-datasheet.pdf
module touchScreen(showpi=false) {
  translate([0,0,touchH/2])cube([touchW,touchD,touchH],center=true);
  //bending cables
  translate([-touchW/2+10+15,0,-.5])cube([30,touchD,1],center=true);
  //tower screws
  for(j=[-1,1])for(i=[0,1])translate([i*touchSdx+touchSxp-touchW/2,-touchD/2-11/2+.01,j*touchSdz/2+touchH/2])rotate([90,0,0])
      cylinder(h=11,d=4,center=true,$fn=64);
  //raspberryPI
  if (showpi)
    translate([0,-12-touchD/2,touchH/2]){
      difference() {
        cube([85,2,56],center=true);
        for(j=[-1,1])for(i=[0,1])translate([i*touchSdx+touchSxp-touchW/2,0,j*touchSdz/2])rotate([90,0,0])
          cylinder(h=3,d=3,center=true,$fn=64);
      }
      //power connector: 21.5 position of raspi screw, 7.5 from screw, 12.5 from display
      translate([touchSdx+touchSxp-touchW/2-8,-2.5,touchSdz/2+2-2.35+1.5]) color("red")cube([9,3.2,7.66],center=true);
      //usb C  
      translate([touchSdx+touchSxp-touchW/2-7.7,-2.5,touchSdz/2+2+6])
      color("green"){
        cube([10,5,8],center=true);
        translate([-4.5,0,6.5])rotate([0,90,0])cylinder(h=23,d=7,$fn=32,center=true);
      }
      // audio connector
      translate([touchSdx-touchW/2-7.7,-4,touchSdz/2+4.5])color("red"){
        cylinder(h=3.5,d=6,center=true,$fn=32);
        translate([0,0,-5])cube([7,6,8],center=true);
      }
      
      //audio mini jack
      color("green")translate([touchSdx-touchW/2-7.7,-4,touchSdz/2+11]){
        cylinder(h=13,d=7.5,center=true,$fn=32);
        translate([-8,0,4.5])cube([20,6.8,8],center=true);
      }
      translate([-34,-8.5,0])cube([20,15,50],center=true);
      translate([10,-5,0])cube([50,8,50],center=true);
      //raspiaudio
      translate([9,-11,-11])cube([64,20,30],center=true);
    }
}

*!touchScreen(showpi=true);

encW = touchW + 2*encThick+encGap;
encH = touchH + 2*encThick+encGap;
encD = touchD + encThick;
module touchEnclosure(showTouch=false){
  p4 = 99.5;
  d1 = 10;
  difference(){
    union(){
      difference() {
        cube([encW,encD,encH],center=true);
        translate([0,-touchD/2+encD/2+.1,0])cube([touchW+encGap,touchD+.2,touchH+encGap],center=true);
        translate([8,-encD/2+encThick/2,0])rotate([90,0,0])r2cube([touchW+encGap-16,touchSdz-d1,encThick+1],center=true,r=12);
        translate([-touchW/2+(p4+touchSxp)/2,-encD/2+encThick/2,10])rotate([90,0,0])r2cube([touchSdx-d1,51,encThick+1],center=true,r=3);
        translate([-touchW/2+touchSdx/2+touchSxp,-encD/2+encThick/2,0])cube([touchSdx,encThick+1,touchSdz],center=true);
      }
      // tower nuts covers
      for(j=[-1,1])for(i=[0,1])translate([i*touchSdx+touchSxp-touchW/2,0,j*touchSdz/2])rotate([90,0,0]){
          translate([0,0,4+encD/2-encThick])cylinder(h=8,d=10,center=true,$fn=64);
          translate([0,0,1.5-.01+8+encD/2-encThick])cylinder(h=3.02,d1=10,d2=7,center=true,$fn=64);
      }
    }
    for(j=[-1,1])for(i=[0,1])translate([i*touchSdx+touchSxp-touchW/2,encD/2-touchD+.1,j*touchSdz/2])rotate([90,0,0])
      translate([0,0,6])cylinder(h=12,d=5,center=true,$fn=64);
        
  }
  if (showTouch)
    %translate([0,-touchD/2+encD/2,-touchH/2])touchScreen(showpi=showTouch);
}
*!touchEnclosure(showTouch=false);

assert (rcase > caseWallThick,str("ERROR case radius must be greater than wallThick. Rcase = ",rcase," | wallThick = ",caseWallThick));

caseW  = encW+8+(addReward==true?sideRewardW:0);
caseH  = encH+2+2*rcase;
caseTH = (caseH-2*rcase)*cos(tilt)+2*rcase;

echo("case W,H,D [mm] ",caseW,caseTH,caseD);

xdt = (caseH/2-rcase)*sin(tilt);
ydt = (caseH/2-rcase)*cos(tilt)+rcase;
caseFD = caseD -xdt; // case upper depth
openX = caseW/2 - openingD/2 - reelW - 12;
openY = (-(-15) + (-2*rcase-1-xdt) )/2 +10;

module frontCase(show=false) {
  difference(){
    union(){
      // top and bottom
      for(i=[-1,1]){
        translate([0,-rcase/2-i*xdt/2-1,i*(ydt-caseWallThick/2)])
          r2cube([caseW,caseFD-rcase-i*xdt-2,caseWallThick],center=true,r=rcase);
        translate([0,caseFD/2-1.5*rcase-1-i*xdt,i*(ydt-caseWallThick/2)])cube([caseW,rcase+2,caseWallThick],center=true);
      }
      // x-cross reinforcement
      for (j=[-1,1]) {
        translate([0,0,-j*(ydt-3*caseWallThick/2)])
        for(i=[0,1])mirror([i,0,0])hull(){
          translate([caseW/2-18,-(caseFD/2-12),0])cylinder(h=2,d=2,$fn=16,center=true);
          translate([-(caseW/2-18),caseFD/2-1.5*rcase+j*xdt-8,0])cylinder(h=2,d=2,$fn=16,center=true);
        }//caseFD/2+(j-1)*(xdt+10)/2
      }
      
      // rounded front
      difference() {
        hull(){
          for(i=[-1,1])
            translate([0,caseFD/2-rcase,0])
            rotate([tilt,0,0])
            translate([0,0,i*(caseH-2*rcase)/2])
            rotate([0,90,0])cylinder(h=caseW,r=rcase,center=true,$fn=64);
        }
        // removing inside front
        hull(){
          for(i=[-1,1])
          translate([0,caseFD/2-rcase,0])
          rotate([tilt,0,0])
          translate([0,0,i*(caseH/2-rcase)])
          rotate([0,90,0])
          cylinder(h=caseW+.1,r=rcase-caseWallThick,center=true,$fn=64);
        }

        hull()for(i=[-1,1]){
          translate([0,caseFD/2-1.5*rcase-1-4-i*xdt,i*(ydt-1.5*caseWallThick)])cube([caseW+1,rcase+2+8,caseWallThick],center=true);
        }
        
        // opening for touchscreen enclousure
        translate([(addReward ==true ? -sideRewardW/2:0),caseFD/2-rcase,0])
          rotate([tilt,0,0])
          translate([0,rcase-caseWallThick/2,0])
          cube([encW,caseWallThick+.1,encH],center=true);
        // opening for sideReward
        if (addReward)
          translate([(addReward ==true ? encW/2-0.001:0),caseFD/2-rcase,0])
          rotate([tilt,0,0])
          translate([0,rcase-caseWallThick/2,0])
          cube([sideRewardW,caseWallThick+.1,encH],center=true);
      }
    }
    // holes for legs 
    for(i=[-1,1])translate([i*(caseW/2-15),0,-(ydt+.1)])
      for(k=[0,1])translate([0,k*(caseFD/2-1.5*rcase+xdt-11)-(1-k)*(caseFD/2-15),0])rotate([0,180,0])screwM3(8,show=false);

    // opening for reward screw
    translate([openX,openY,ydt-caseWallThick-1])
      translate([0,0,.1])cylinder(h=caseWallThick+openingH+1,d=openingD+5,$fn=64,center=true);
      
    // hole for external switch
    translate([-caseW/2 + (ext_switch_d/2 + reelW + 8),0,-ydt+caseWallThick/2])
      translate([0,0,0])cylinder(h=caseWallThick+.5,d=ext_switch_d+1,$fn=64,center=true);
      
  }
  // reel to close
  for(i=[-1,1])for(j=[0,1])mirror([0,0,j])translate([i*(caseW/2-caseWallThick-reelW/2-.25),-reelL/2+caseFD/2+xdt-1.5*rcase-2*j*xdt-5,-(ydt-caseWallThick)]){
    translate([0,0,reelH-reelW/2])rotate([90,0,0])cylinder(h=reelL,d=reelW-.5,$fn=32,center=true);
    translate([0,0,reelH/2-reelW/4-caseWallThick/2])cube([reelW-.5,reelL,reelH-reelW/2+caseWallThick],center=true);
  }
  // latchs
  for(i=[-1,1])for(j=[0,1])mirror([0,0,j])
    translate([i*(caseW/2-30),-caseFD/2,-ydt+caseWallThick])
    translate([0,latchL-latchR-1,0])union(){
    difference(){
      rotate([0,90,0])cylinder(r=latchR,h=latchW,$fn=32,center=true);
      rotate([0,90,0])cylinder(r=latchR-latchT,h=latchW+1,$fn=32,center=true);
      translate([0,0,-(latchR+1)/2])cube([latchW+1,2*latchR+1,latchR+1],center=true);      
      translate([0,-(latchR+1)/2,0])cube([latchW+1,latchR+1,2*latchR+1],center=true);
    }
    translate([0,-(latchL-latchR+.5)/2,latchT/2+latchR-latchT])cube([latchW,latchL-latchR+.5,latchT],center=true);
    translate([0,-(latchL-latchR)-.5,latchR-latchT])
      difference(){
        translate([0,.5,-.5])cube([latchW,1,1],center=true);
        rotate([-135,0,0])translate([0,.8,.8])cube([latchW+1,1.6,1.6],center=true);
      }
  }
  // nuts for legs
  for(i=[-1,1])translate([i*(caseW/2-15),0,-(ydt-caseWallThick-1.2)])
    for(k=[0,1])translate([0,k*(caseFD/2-1.5*rcase+xdt-11)-(1-k)*(caseFD/2-15),0])
      difference(){
        cylinder(d=10,h=2.6,center=true,$fn=32);
        nutM3(show=false);
      }

  // thread for water contanier
  translate([openX,openY,-caseWallThick+ydt]){
    opening_receptacle();
  }

  // adding touch enclosure and reward
  translate([0,caseFD/2-rcase,0])
  rotate([tilt,0,0])
  union(){
    translate([(addReward ==true ? -sideRewardW/2:0),-encD/2+rcase,0])
      touchEnclosure(showTouch=show);
    if (addReward)
      translate([encW/2,-encD/2+rcase,0]) sideReward(W=sideRewardW,show=show);
  }
  if (show)
    %translate([-caseW/2 + (ext_switch_d/2 + reelW + 8),0,-ydt])
      translate([0,0,(ext_switch_ih-ext_switch_oh)/2])cylinder(h=ext_switch_ih+ext_switch_oh,d=ext_switch_d,$fn=64,center=true);
     
}

module sideReward(W,show=false){
  sensorW=8;
  sensorH = -25;
  translate([0,0,0])
  difference(){
    translate([0,0,0])cube([W+.01,encD,encH],center=true);
    translate([0,0,sensorH])rotate([-tilt,0,0])sensorOpening(sensorW);
  }
  if (show) {
    %translate([0,0,sensorH])rotate([-tilt,0,0]){
         sensorWithSpout(W=sensorW,show=false);
    }
  }
}

module sensorWithSpout(W,show=true) {
  sparkfunSensorCase(W=W,show=show,depth=8);
  
  translate([0,-3.5,3.6])rotate([0,90,90])
    union(){
      lickportHolder(4,10,1);
      rotate([0,45,0]) translate([0,0,-9.5])lickport(4,10,1);
    }
  if(show) %sensorOpening(W=W,depth=8);
}

module sensorOpening(W,depth=8) {
  union(){
      cube([W+2,2*encD,6],center=true);
      translate([0,-encD/2-1,4])cube([W-1,encD+1,14],center=true);
      translate([0,-encD/2-5,5])cube([W-1,encD-1,16],center=true);
      translate([0,.5-3,0])cube([W+7,depth+6,7],center=true);
      translate([0,4,0])rotate([90,0,0])cylinder(h=10,d=W+2,$fn=32,center=true);
  }
}

*!rotate([tilt,0,0])sideReward(W=sideRewardW,show=true);
*!sensorWithSpout(W=8,show=true);

module opening_cap() {
  difference(){
    union(){
      cylinder(h=caseWallThick, d = openingD + 4, $fn=64);
      translate([0,0,-openingH/2])cylinder(h=openingH, d = openingD, $fn=64, center=true);
      translate([0,0,-openingH+2]) rotate([90,0,10]) rcylinder2(h=openingD + 3.5, d=2,center=true,fn=64);
    }
    translate([0,0,caseWallThick-0.99])cube([openingD,2,2],center=true);
  }
}

module opening_cap_wing() {
  union(){
   cylinder(h=caseWallThick, d = openingD + 4, $fn=64);
   translate([0,0,caseWallThick+1.49])cube([openingD,2,3],center=true);
   translate([0,0,-openingH/2])cylinder(h=openingH, d = openingD, $fn=64, center=true);
   translate([0,0,-openingH+2]) rotate([90,0,0]) rcylinder2(h=openingD + 3.5, d=2,center=true,fn=64);
  }
}

module opening_receptacle() {
  Ns = 36;
  thread_profile_points = [for (i=[0:Ns]) [1.2*sin(i*180/Ns),1.2*cos(i*180/Ns)]];
  
  customTable = [
                ["special", [8, (openingD+1.6)/2-.01, 40, thread_profile_points]]
                ];
 
  difference(){
    translate([0,0,-openingH])cylinder(h=openingH+caseWallThick,d=openingD+6,$fn=64);
    translate([0,0,0])cylinder(h=caseWallThick+.1,d=openingD+5,$fn=64);
    translate([0,0,-openingH-.1])cylinder(h=openingH+.2,d=openingD+1.6,$fn=64);
    for(i=[-1,1]) {
      *translate([0,i*(openingD/2+.8),-openingH+1.5])rcylinder2(h=openingH+2,d=2.4,fn=32);
      rotate([0,0,90*i])translate([0,0,-openingH+1.2+1.5+3])mirror([0,1,0])mirror([0,0,1])
      thread("special", turns=.5, table=customTable, higbee_arc=0, fn=128);

    }
  }
}
*!union(){
  opening_receptacle();
  translate([0,0,0])opening_cap();
}
  
spk_y=-10;
spk_z=0;
module backCase(show=false, speakers=false){
  difference(){
    union(){
      //sidewalls
      for(i=[-1,1]){
        hull(){
          translate([i*(caseW-caseWallThick)/2,caseFD/2-rcase-caseGap/2,0])
            rotate([tilt,0,0])rotate([0,90,0])
            rrect([caseH-2*caseWallThick-caseGap,2*(rcase-caseWallThick),caseWallThick],center=true);
          translate([i*(caseW-caseWallThick)/2,-caseFD/2+1.5*rcase,0])rotate([0,90,0])cube([caseTH-2*caseWallThick-caseGap,rcase,caseWallThick],center=true);
        }
        // reel guides
        mirror([(i+1)/2,0,0])for(j=[0,1])mirror([0,0,j])translate([-(caseW/2-caseWallThick-reelW/2),-reelL/2+caseFD/2+xdt-1.5*rcase-2*j*xdt-5,-(ydt-caseWallThick)]){
          difference(){
            translate([0,0,reelH/2])union(){
              translate([-reelW/4-.05,0,.75])cube([reelW/2+.1,reelL,reelH+1.5],center=true);
              translate([.75,0,-reelW/4])cube([reelW+1.5,reelL,reelH-reelW/2],center=true);
              translate([0,0,reelH/2-reelW/2])rotate([90,0,0])cylinder(h=reelL,d=reelW+3,$fn=64,center=true);
            }
            translate([-3*reelW/4-.1,0,reelH/2])cube([reelW/2,reelL+1,reelH+4],center=true);
            translate([0,0,-1+caseGap-reelH/2])cube([reelW+4,reelL+1,2+reelH],center=true);
            //copied from frontcase
            translate([0,0,reelH-reelW/2])rotate([90,0,0])cylinder(h=reelL+1,d=reelW+.4,$fn=32,center=true);
            translate([0,0,reelH/2-reelW/4-.1])cube([reelW+.4,reelL+1,reelH-reelW/2+.2],center=true);
            translate([-reelW/4-.1,0,reelH/2])cube([reelW/2+.2,reelL+1,reelH+.4],center=true);
          }
        }
        // x-cross reinforcement
        translate([i*((caseW-caseWallThick)/2-2),0,0])difference(){
          union(){
            for(j=[-1,1]) hull() {
              translate([0,-caseFD/2+1.5*rcase,-j*(ydt-caseWallThick-10)]) rotate([0,90,0]) cylinder(h=2.1,d=2,$fn=16,center=true);
              translate([0,caseFD/2-rcase-j*xdt,j*(ydt-caseWallThick-10)]) rotate([0,90,0]) cylinder(h=2.1,d=2,$fn=16,center=true);
            }
          }
          if (speakers) translate([0,spk_y,spk_z]) rotate([0,90,0]) cylinder(h=4,d=33,$fn=64,center=true);
        }
        //speakers
        if (speakers) translate([i*(caseW/2-caseWallThick-2),spk_y,spk_z]) rotate([0,90,0])
        difference(){
          cylinder(h=4,d=35,$fn=64,center=true);
          cylinder(h=4.2,d=31,$fn=64,center=true);
        }
      }
      //backwall
      difference(){
        hull(){
          for(i=[-1,1])translate([i*(caseW-2*rcase)/2,-caseFD/2+rcase,0])cylinder(h=caseTH-2*caseWallThick-caseGap,r=rcase,center=true,$fn=64);
        }
        // removing extra back wall
        translate([0,-caseFD/2+rcase,0]){
          hull(){
            for(i=[-1,1])
              translate([i*(caseW-2*rcase)/2,0,0])
                cylinder(h=caseTH-2  *caseWallThick+.1,r=rcase-caseWallThick,center=true);
          }
          translate([0,rcase/2+.1,0])
            cube([caseW-2*caseWallThick,rcase+.2,caseTH-2*caseWallThick+.1],center=true);
        }
      }
    }
    // latch holes
    for(i=[-1,1])for(j=[0,1])mirror([0,0,j])
      translate([i*(caseW/2-30),-caseFD/2+caseWallThick/2,-caseTH/2+caseWallThick+latchR-latchT/2+.5])
      translate([0,0,0]) cube([latchW+1.4,caseWallThick+1,latchT+2],center=true);  

    // cable input
    translate([0,-caseFD/2+caseWallThick/2,caseTH/2-caseWallThick-caseGap/2-4/2]) {  
      rotate([90,0,0])cylinder(h=caseWallThick+.2,d=4,center=true,$fn=64);
      translate([0,0,8/4])cube([4,caseWallThick+.2,8/2],center=true);
    }
    //speaker holes
    if (speakers) for(i=[-1,1]) translate([i*(caseW-caseWallThick)/2,spk_y,spk_z]) rotate([0,90,0]) {
      cylinder(h=caseWallThick+.2,d=2,$fn=64,center=true);
      for(j=[0:5]) rotate([0,0,j*60])translate([8,0,0])cylinder(h=caseWallThick+.2,d=2,$fn=64,center=true);
    }
  }

  // cable input
  translate([0,-caseFD/2+caseWallThick+1,caseTH/2-caseWallThick-caseGap/2-4/2])
  difference(){
    union(){
      rotate([90,0,0])cylinder(h=2,d=4+3,center=true,$fn=64);
      translate([0,0,7/4])cube([7,2,7/2],center=true);
    }
    rotate([90,0,0])cylinder(h=2.1,d=4,center=true,$fn=64);
    translate([0,0,8/4])cube([4,2.1,8/2],center=true);
    translate([0,0,8/2])cube([8,2.1,8/2],center=true);
  }
  
  // battery bottom stop
  translate([0,-caseFD/2+caseWallThick+1,-34.5])
  cube([50,2,2],center=true);
  
  // battery wings
  for(i=[0,1])for(j=[-1,1])mirror([i,0,0])translate([-126.5/2,-caseFD/2+caseWallThick+1,j*25-2.2])
    difference(){
      translate([-1.5,1.25,-1.51]) cube([7,5,9],center=true);
      cube([5.5,3.2,6],center=true);
    }
    
  if (show){
    //battery
    translate([0,-caseFD/2+caseWallThick,-2]) batteryHolder(show=show);
    //speakers
    if (speakers)
      %for(i=[0,1])mirror([i,0,0])translate([(caseW/2-caseWallThick-13),spk_y,spk_z]) rotate([0,90,0]) sparkfunSpeaker();
  }
}

module batteryHolder(show=false){
  translate([0,5,0]){
    difference(){
      translate([0,1,0])cube([115+5,10+2,62],center=true);
      translate([0,-.01,2])cube([115+1,10,62],center=true);
      //cable out
      translate([-(115-3)/2,-2.5,-(62-2)/2])cube([3,8,4],center=true);
    }
    // wings
    for(i=[-1,1])for(j=[-1,1])translate([i*125/2,-4,j*25])cube([5,2,6],center=true);
    // x-cross
    for(i=[-1,1])rotate([0,i*20,0])translate([0,8-.01,0])rotate([90,0,0])r2cube([115,2,2],r=1,center=true);
    //tower screws
    for(j=[-1,1])for(i=[0,1])translate([i*touchSdx-85/2+3.5,10+.01,j*touchSdz/2])rotate([90,0,0])
        difference(){
          cylinder(h=6,d=7,center=true,$fn=64);
          cylinder(h=6.1,d=2.6,center=true,$fn=64);
        }
    if (show) {
      // battery
      %translate([0,0,4])cube([115,9,65],center=true);
      // UPSV3.2P board 
      %translate([0,14,0]){
        union(){
          difference() {
            cube([85,2,56],center=true);
            for(j=[-1,1])for(i=[0,1])translate([i*touchSdx-85/2+3.5,0,j*touchSdz/2])rotate([90,0,0])
              cylinder(h=3,d=3,center=true,$fn=64);
          }
          //power connector: 21.5 position of raspi screw, 7.5 from screw, 12.5 from display
          translate([-85/2+13.3/2+7.5,4.5,touchSdz/2-1.5]){
            color("red")cube([13.3,7,10],center=true);
            //usb A
            translate([0,0,15.8])color("green"){
              translate([0,0,-7])cube([15,6,10],center=true);
              translate([6,0,.5])rotate([0,90,0])cylinder(h=30,d=9,$fn=32,center=true);
            }
          }
          translate([85/2-37,2.5,56/2-3.5]) {
            //power connector
            color("red")cube([9,3.2,7],center=true);
            //usb C  
            translate([0,0,13.3])color("green"){
              translate([0,0,-6])cube([10,5,8],center=true);
              translate([4.5,0,0])rotate([0,90,0])cylinder(h=23,d=7,$fn=32,center=true);
            }
          }
        }
      }
    }
  }
}

module leg(height=5) {
  assert (height >= 5);
  difference(){
    cylinder(d=20,h=height,$fn=32);
    %translate([0,0,-.1])cylinder(d=6,h=height-2,$fn=32);
    translate([0,0,height-2])rotate([0,180,0])screwM3(length=2+caseWallThick+3,show=true);
  }
}

/////////////////////////
////show
/////////////////////////
union(){
  frontCase(show=true);
  translate([0,0,0])backCase(show=true, speakers=true);
  translate([openX,openY,ydt-caseWallThick]) opening_cap();
  for(i=[-1,1])translate([i*(caseW/2-15),0,-(ydt+.1)])
    for(k=[0,1])translate([0,k*(caseD/2+xdt/2-15)-(1-k)*(caseFD/2-15),-8])leg(8);
}
/////////////////////////
////print
/////////////////////////


*!rotate([-tilt-90,0,0])frontCase();
*!rotate([90,0,0])backCase(speakers=true);
*!rotate([180,0,0])opening_cap_wing();
*!rotate([180,0,0])opening_cap();
*!rotate([180,0,0])leg(6); // x4
*!rotate([0,0,0])batteryHolder();
*!sensorWithSpout(W=8,show=false);

