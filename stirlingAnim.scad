res = 40; //resolution
angle = 360*$t;

flyWheelRadius = 15;
crankShaftRadius = 4;
connRodLen = 8;
cylinderRadius = 15;
cylinderlen = 45;
displacerLead = 90;
crossSection = true;
pinSize = 2;

//pin locations
axle = [0,12,0];
axle2 = [0,-10,0];
crankPin1 = [crankShaftRadius*sin(angle),5,crankShaftRadius*cos(angle)];
crankPin2 = [crankShaftRadius*sin(angle+displacerLead),0,crankShaftRadius*cos(angle+displacerLead)];
crankPin3 = crankPin1 - [0,10,0];
crossPin1 = [0,crankPin1[1],crankPin1[2]-sqrt(pow(connRodLen,2)-pow(crankPin1[0],2))];
crossPin2 = [0,crankPin2[1],crankPin2[2]-sqrt(pow(connRodLen,2)-pow(crankPin2[0],2))];
crossPin3 = crossPin1 - [0,10,0];


//pinning pins
pin(axle,10);
pin(axle2,5);
pin(crankPin1, 6);
pin(crankPin2, 6);
pin(crankPin3, 6);
pin(crossPin1, 3);
pin(crossPin2, 3);
pin(crossPin3, 3);

//drawing connecting rods
connRod(crankPin1,crossPin1,connRodLen);
connRod(crankPin2,crossPin2,connRodLen);
connRod(crankPin3,crossPin3,connRodLen);

//drawing structureres = 40; //resolution
angle = 360*$t;

flyWheelRadius = 15;
crankShaftRadius = 4;
connRodLen = 8;
cylinderRadius = 15;
cylinderlen = 45;
displacerLead = 90;
crossSection = true;
pinSize = 2;

//pin locations
axle = [0,12,0];
axle2 = [0,-10,0];
crankPin1 = [crankShaftRadius*sin(angle),5,crankShaftRadius*cos(angle)];
crankPin2 = [crankShaftRadius*sin(angle+displacerLead),0,crankShaftRadius*cos(angle+displacerLead)];
crankPin3 = crankPin1 - [0,10,0];
crossPin1 = [0,crankPin1[1],crankPin1[2]-sqrt(pow(connRodLen,2)-pow(crankPin1[0],2))];
crossPin2 = [0,crankPin2[1],crankPin2[2]-sqrt(pow(connRodLen,2)-pow(crankPin2[0],2))];
crossPin3 = crossPin1 - [0,10,0];


//pinning pins
pin(axle,10);
pin(axle2,5);
pin(crankPin1, 6);
pin(crankPin2, 6);
pin(crankPin3, 6);
pin(crossPin1, 3);
pin(crossPin2, 3);
pin(crossPin3, 3);

//drawing connecting rods
connRod(crankPin1,crossPin1,connRodLen);
connRod(crankPin2,crossPin2,connRodLen);
connRod(crankPin3,crossPin3,connRodLen);


//drawing structure
color("grey")
flyWheel();
crankShaft();
piston(15,6,15);
displacer(30,10,10);
case();


module flyWheel(){
    $fn = res;
    
    translate(axle)
    rotate([90,angle,0]){
        cylinder(r=2,h=3,center=true);
        difference(){
            rotate_extrude(center=true, $fn = res*2)
            offset(r=+0.9)offset(delta=-0.9)
            offset(r=-1.2) offset(delta=+1.2)
            polygon([[0,1],
                    [0,-1],
                    [flyWheelRadius-1.5,-1],
                    [flyWheelRadius,-2],
                    [flyWheelRadius+1,-0.65],
                    [flyWheelRadius+1,0.65],
                    [flyWheelRadius,2],
                    [flyWheelRadius-1.5,1]
                    
            
            ]);
            
            for (i=[0:60:359]){
                rotate([0,0,i])
                linear_extrude(5, center=true)
                offset(r=+1.7)offset(delta=-1.7)
                polygon([[0,1],
                        [4.5,flyWheelRadius-3.5],
                        [0,flyWheelRadius-3],
                        [-4.5,flyWheelRadius-3.5]               
                ]);
            }
        }
    }
    
}

module piston(rodLen, pistLen, radius){ //power piston
    $fn = res;
    width = 2;
    
    color("grey"){
        translate(crossPin1)
        difference(){
            union(){
               translate([-width/2,-width/2,-rodLen])
               cube([width,width,rodLen]);
               rotate([-90,0,0])
               cylinder(d=pinSize+1,h=width,center=true); 
            }
            rotate([-90,0,0])
            cylinder(d=pinSize+1.2,h=width);
        }
        translate(crossPin3)
        difference(){
            union(){
               translate([-width/2,-width/2,-rodLen])
               cube([width,width,rodLen]);
               rotate([-90,0,0])
               cylinder(d=pinSize+1,h=width,center=true);
            }
            rotate([-90,0,0])
            cylinder(d=pinSize+1.2,h=width);
        }
        translate([0,0,crossPin1[2]-pistLen-rodLen])
        difference(){
            cylinder(r=radius,h=pistLen,$fn=res*2);
            cube([width+0.1,width+0.1,100],center=true);
        }
    }

        
}

module displacer(rodLen, dispLen, radius){ //displacer piston
    $fn = res;
    width = 2;
    
    color("dimgrey")
    translate(crossPin2)
    difference(){
        union(){
           translate([-width/2,-width/2,-rodLen])
           cube([width,width,rodLen]);
           rotate([-90,0,0])
           cylinder(d=pinSize+1,h=width,center=true);
           translate([0,0,-rodLen-dispLen])
           cylinder(r=radius,h=dispLen,$fn=res*2);           
        }
        rotate([-90,0,0])
        cylinder(d=pinSize+1.2,h=width);
    }
}

module connRod(pin1,pin2,length){
    $fn = res;
    xdist = (pin2[0]-pin1[0]);
    zdist = (pin2[2]-pin1[2]);
    width = 2;
    
    color("darkgrey")
    translate(pin1)
    rotate([0,atan2(xdist,zdist),0])
    difference(){
       union(){
           translate([-width/2,-width/2])
           cube([width,width,length]);
           rotate([90,0,0]){
               cylinder(d=pinSize+1.1,h=width,center=true);
               translate([0,length,0])
               cylinder(d=pinSize+1,h=width,center=true);
           }
          
       } 
       rotate([90,0,0])
       translate([0,length,0])
       cylinder(d=pinSize+1.2,h=width);
    }
}

module case(){
    $fn = res*2;
    //find piston's upper bound
    top = crankShaftRadius - connRodLen - flyWheelRadius;
    
    //find displacer's lower bound
    bottom = -crankShaftRadius - connRodLen - cylinderlen;
    
    
    //make cylinder
    color("silver")
    difference(){
        translate([0,0,bottom])
        cylinder(r=cylinderRadius+1.5,h=top-bottom+1);
    
        //hollow it out
        translate([0,0,bottom+2])
        cylinder(r=cylinderRadius+0.1,h=top-bottom);
        //add cross-section option
        if (crossSection){
            translate([0,-2*cylinderRadius,bottom+4])
            cube([50,50,100]);
        }
        
    }
}

module crankShaft(){
    
    //axis
    *%rotate([90,0,0])
    cylinder(d=1,h=40,center=true);
    
    
    crankArm(crankPin1);
    crankArm(crankPin2);
    crankArm(crankPin3);
    
}
module crankArm(pin) {
    $fn = res;
    
    xdist = (axle[0]-pin[0]);
    zdist = (axle[2]-pin[2]);
    width = pinSize+1;
    
    color("grey")
    translate(pin)
    rotate([0,atan2(xdist,zdist),0])
    difference(){
       union(){
           translate([-width/2,-5.5/2])
           cube([width,5.5,crankShaftRadius]);
           rotate([90,0,0]){
               cylinder(d=width,h=5.5,center=true);
               translate([0,crankShaftRadius,0])
               cylinder(d=width,h=5.5,center=true);
           }
       }
       translate([0,0,0])
       cube([width+1,3,15],center=true);
       
    }
    
}

module pin(coords,length){
    $fn = res;
    color("lightgrey")
    translate(coords)
    rotate([90,0,0])
    cylinder(d=pinSize,h=length,center=true);
}
color("grey")
flyWheel();
crankShaft();
piston(15,6,15);
displacer(30,10,10);
case();


module flyWheel(){
    $fn = res;
    
    translate(axle)
    rotate([90,angle,0]){
        cylinder(r=2,h=3,center=true);
        difference(){
            rotate_extrude(center=true, $fn = res*2)
            offset(r=+0.9)offset(delta=-0.9)
            offset(r=-1.2) offset(delta=+1.2)
            polygon([[0,1],
                    [0,-1],
                    [flyWheelRadius-1.5,-1],
                    [flyWheelRadius,-2],
                    [flyWheelRadius+1,-0.65],
                    [flyWheelRadius+1,0.65],
                    [flyWheelRadius,2],
                    [flyWheelRadius-1.5,1]
                    
            
            ]);
            
            for (i=[0:60:359]){
                rotate([0,0,i])
                linear_extrude(5, center=true)
                offset(r=+1.7)offset(delta=-1.7)
                polygon([[0,1],
                        [4.5,flyWheelRadius-3.5],
                        [0,flyWheelRadius-3],
                        [-4.5,flyWheelRadius-3.5]               
                ]);
            }
        }
    }
    
}

module piston(rodLen, pistLen, radius){ //power piston
    $fn = res;
    width = 2;
    
    color("grey"){
        translate(crossPin1)
        difference(){
            union(){
               translate([-width/2,-width/2,-rodLen])
               cube([width,width,rodLen]);
               rotate([-90,0,0])
               cylinder(d=pinSize+1,h=width,center=true); 
            }
            rotate([-90,0,0])
            cylinder(d=pinSize+1.2,h=width);
        }
        translate(crossPin3)
        difference(){
            union(){
               translate([-width/2,-width/2,-rodLen])
               cube([width,width,rodLen]);
               rotate([-90,0,0])
               cylinder(d=pinSize+1,h=width,center=true);
            }
            rotate([-90,0,0])
            cylinder(d=pinSize+1.2,h=width);
        }
        translate([0,0,crossPin1[2]-pistLen-rodLen])
        difference(){
            cylinder(r=radius,h=pistLen,$fn=res*2);
            cube([width+0.1,width+0.1,100],center=true);
        }
    }

        
}

module displacer(rodLen, dispLen, radius){ //displacer piston
    $fn = res;
    width = 2;
    
    color("dimgrey")
    translate(crossPin2)
    difference(){
        union(){
           translate([-width/2,-width/2,-rodLen])
           cube([width,width,rodLen]);
           rotate([-90,0,0])
           cylinder(d=pinSize+1,h=width,center=true);
           translate([0,0,-rodLen-dispLen])
           cylinder(r=radius,h=dispLen,$fn=res*2);           
        }
        rotate([-90,0,0])
        cylinder(d=pinSize+1.2,h=width);
    }
}

module connRod(pin1,pin2,length){
    $fn = res;
    xdist = (pin2[0]-pin1[0]);
    zdist = (pin2[2]-pin1[2]);
    width = 2;
    
    color("darkgrey")
    translate(pin1)
    rotate([0,atan2(xdist,zdist),0])
    difference(){
       union(){
           translate([-width/2,-width/2])
           cube([width,width,length]);
           rotate([90,0,0]){
               cylinder(d=pinSize+1.1,h=width,center=true);
               translate([0,length,0])
               cylinder(d=pinSize+1,h=width,center=true);
           }
          
       } 
       rotate([90,0,0])
       translate([0,length,0])
       cylinder(d=pinSize+1.2,h=width);
    }
}

module case(){
    $fn = res*2;
    //find piston's upper bound
    top = crankShaftRadius - connRodLen - flyWheelRadius;
    
    //find displacer's lower bound
    bottom = -crankShaftRadius - connRodLen - cylinderlen;
    
    
    //make cylinder
    color("silver")
    difference(){
        translate([0,0,bottom])
        cylinder(r=cylinderRadius+1.5,h=top-bottom+1);
    
        //hollow it out
        translate([0,0,bottom+2])
        cylinder(r=cylinderRadius+0.1,h=top-bottom);
        //add cross-section option
        if (crossSection){
            translate([0,-2*cylinderRadius,bottom+4])
            cube([50,50,100]);
        }
        
    }
}

module crankShaft(){
    
    //axis
    *%rotate([90,0,0])
    cylinder(d=1,h=40,center=true);
    
    
    crankArm(crankPin1);
    crankArm(crankPin2);
    crankArm(crankPin3);
    
}
module crankArm(pin) {
    $fn = res;
    
    xdist = (axle[0]-pin[0]);
    zdist = (axle[2]-pin[2]);
    width = pinSize+1;
    
    color("grey")
    translate(pin)
    rotate([0,atan2(xdist,zdist),0])
    difference(){
       union(){
           translate([-width/2,-5.5/2])
           cube([width,5.5,crankShaftRadius]);
           rotate([90,0,0]){
               cylinder(d=width,h=5.5,center=true);
               translate([0,crankShaftRadius,0])
               cylinder(d=width,h=5.5,center=true);
           }
       }
       translate([0,0,0])
       cube([width+1,3,15],center=true);
       
    }
    
}

module pin(coords,length){
    $fn = res;
    color("lightgrey")
    translate(coords)
    rotate([90,0,0])
    cylinder(d=pinSize,h=length,center=true);
}