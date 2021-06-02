//-- General parts
//-- Ariel Burman
//-- Moorman Lab, University of Massachusetts Amherst
//-- v1.2 - April 2021


module screwM3(length,show=false){
  translate([0,0,-length-.005])cylinder(h=length+.1+.005,d=3.4,$fn=64);
  cylinder(h=3,d=5.5,$fn=64);
  if (show==true) {
    %translate([0,0,-length])cylinder(h=length,d=3.2,$fn=64);
    %cylinder(h=3,d=5.5,$fn=64);
    echo(str("M3 screw lenght: ", length, " mm"));
  }
}

module nutM3(rotation=0,show=false) {
  rotate([0,0,rotation])cylinder(h=2.6+.01,d=6.5,$fn=6,center=true);
  if (show==true) {
    %difference(){
      rotate([0,0,rotation])cylinder(h=2.6,d=6.4,$fn=6,center=true);
      cylinder(h=3,d=3.5,$fn=64,center=true);
    }
  }
}

module torus(d1,d2,fn=64){
  assert (d1<=d2, str("ERROR d1 must not be greater than d2. d1 = ",d1,"| d2 = ",d2));
  rotate_extrude(convexity = 10,$fn=fn)
  translate([d2/2, 0, 0])
  circle(d=d1, $fn=fn);
}


module rrect(size,center=false,fn=64){

  dx = size[0];
  dy = size[1];
  dz = size[2];
  
  module _rrect(size,fn){
    d = min(dx,dy);
    a = (d == dx ? 0 : 1);
    
    hull()
      for(i=[-1,1]) 
        translate([a*i*(dx-d)/2,(1-a)*i*(dy-d)/2,0])
             cylinder(h=dz,d=d,$fn=fn,center=true);
  }
  
  if (center==true)
    _rrect(size,fn);
  else
    translate([dx/2,dy/2,dz/2]) _rrect(size,fn);
  
}  

module r2cube(size,center=false,r=0,fn=64){

  module _r2cube(size,r,fn){
    
    hull()
      for(i=[-1,1]) 
        translate([i*(dx/2-r),0,0])
          rrect([2*r,dy,dz],$fn=fn,center=true);

//    hull(){
//      for(i=[-1,1]) 
//        translate([i*(dx/2-r),0,0])
//          hull(){
//            for(j=[-1,1])
//              translate([0,j*(dy/2-r),0])
//                cylinder(h=dz,r=r,$fn=fn,center=true);
//          }
//    }

//    hull()
//      for(i=[-1,1]) 
//        for(j=[-1,1])
//          translate([i*(dx/2-r),j*(dy/2-r),0])
//            cylinder(h=dz,r=r,$fn=fn,center=true);
    
  }

  dx = size[0];
  dy = size[1];
  dz = size[2];

  assert(r>0,"Corner radius must be grater than 0 (otherwise just use cube)");
  assert(r<=min(dx,dy)/2,"Corner radius must not be greater than min(x,y)/2");

  if (center==true)
    _r2cube(size,r,fn);
  else
    translate([dx/2,dy/2,dz/2]) _r2cube(size,r,fn);
}


module rcylinder(h,r,rb,center=false,fn=64){
  module _rcylinder(h,r,rb,fn){
    hull(){
      translate([0,0,-h/2+rb/2])torus(rb,2*r-rb,fn);
      translate([0,0,h/2-rb/2])torus(rb,2*r-rb,fn);
    }
  }
  if (center==true)
    _rcylinder(h,r,rb,fn);
  else
    translate([0,0,h/2])_rcylinder(h,r,rb,fn);
}

module rhcylinder(h,rout,rin,rb,center=false,fn=64){
  //rounded hollow cylinder
  module _rhcylinder(h,rout,rin,rb,fn){
    difference(){
      union(){
      cylinder(h=h,d=2*rout-rb,$fn=fn,center=true);
      cylinder(h=h-rb,d=2*rout,$fn=fn,center=true);
      }
      cylinder(h=h-rb,d=2*rin,$fn=fn,center=true);
      translate([0,0,h/2])cylinder(h=rb+.1,d=2*rin+rb,$fn=fn,center=true);
      translate([0,0,-h/2])cylinder(h=rb+.1,d=2*rin+rb,$fn=fn,center=true);
    }
    translate([0,0,-h/2+rb/2])torus(rb,2*rout-rb,fn);
    translate([0,0,h/2-rb/2])torus(rb,2*rout-rb,fn);
    translate([0,0,-h/2+rb/2])torus(rb,2*rin+rb,fn);
    translate([0,0,h/2-rb/2])torus(rb,2*rin+rb,fn);
  }
  
  //do assertions
  assert(rout>rin);
  assert(rb<=(rout-rin));
  assert(h>=rb);

  if (center==true)
    _rhcylinder(h,rout,rin,rb,fn);
  else
    translate([0,0,h/2])_rhcylinder(h,rout,rin,rb,fn);
}

module r3cube(size,center=true,rc=0,rb=0,fn=32){
  
  
  module _r3cube(size,r,fn){
//    hull(){
//      for(i=[-1,1]) 
//        for(j=[-1,1])
//          for(k=[-1,1])
//          translate([i*(dx/2-r),j*(dy/2-r),k*(dz/2-r)]) sphere(r=r,$fn=32);
//    }

     hull(){
      for(k=[-1,1]) translate([0,0,k*(dz/2-r)])
        hull(){
          for(j=[-1,1])translate([0,j*(dy/2-r),0])
            hull(){
              for(i=[-1,1])
                translate([i*(dx/2-r),0,0]) sphere(r=r,$fn=fn);
            }
        }
     }

  }

  module _r3cube(size,r,fn){
//    hull(){
//      for(i=[-1,1]) 
//        for(j=[-1,1])
//          for(k=[-1,1])
//          translate([i*(dx/2-r),j*(dy/2-r),k*(dz/2-r)]) sphere(r=r,$fn=32);
//    }

     hull(){
      for(k=[-1,1]) translate([0,0,k*(dz/2-r)])
        hull(){
          for(j=[-1,1])translate([0,j*(dy/2-r),0])
            hull(){
              for(i=[-1,1])
                translate([i*(dx/2-r),0,0]) sphere(r=r,$fn=fn);
            }
        }
     }

  }
  

  
  dx = size[0];
  dy = size[1];
  dz = size[2];
  assert (rc>0,"Missing radius value rc");
  if (rb==0){
    //same radius for all corners and edges;
    assert (rc<=min(dx,dy,dz)/2,"Corner radius must not be greater than min(x,y,z)/2");
    
    if (center==true)
      _r3cube(size,rc,fn);
    else
      translate([dx/2,dy/2,dz/2]);
  }
  else {
  //assert (rb>0,"Missing radius value rb");
    assert (rc<=min(dx,dy)/2,"Corner radius must not be greater than min(x,y)/2");
    assert (rb<dz/2,"Border radius must not be greater than z/2");

    if (center==true)
      _r3bcube(size,rc,fn);
    else
      translate([dx/2,dy/2,dz/2]);
  }
}



*difference(){
  cube(12,center=true);
  translate([0,0,5])screwM3(11,show=true);
  translate([0,0,-4.7])nutM3(rotation=0,show=true);
}
//translate([10,10,0])
*torus(1,20-1,64);

*rrect([10,5,2],center=false,fn=1024);
r2cube([15,20,2],r=7.5,fn=64,center=false);
*r3cube([20,15,5],rc=2);
*rcylinder(h=10,r=10,rb=4,center=false,fn=64);
*rhcylinder(h=15,rout=14,rin=8,rb=2,center=true,fn=128);

