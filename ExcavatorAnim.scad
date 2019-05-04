$fn = 80; //you can set this quite low and it will still look okay

//inputs, feel free to try different equations to see how they affect movement.
// they are relative to the ground, if you want relative to each other add them together here
boomAngle = -15 -15 * $t; //range -30 to 75
dipperAngle = -10 - 70 * $t; //range -85 to 45
bucketAngle = -10 + 120 * -pow($t,2); //range -110 to 15

//lengths in meters, changing these will probably break things
boomLen = 5; //length of horz segment, vert will scale with it
dipperLen = 4; //from boom to bucket

//in centimeters
linkageLen = 90; //length of the bars in the bucket linkage
pinSize = 15; 
width = 50; //global model width setting, changing this may require tweaking in other places

//pin locations, some require large amounts of math converting cyl to cart coordinates
baseBoom = [-14,0,15]; //DO NOT TWEAK
baseHydr = [20,0,-20]; //this one you can tweak
boomDipper = [575 * cos(-boomAngle+30) + baseBoom[0],0,
              575 * sin(-boomAngle+30) + baseBoom[2]];
hydrBoom = [300 * cos(-boomAngle+59) + baseBoom[0],0,
            300 * sin(-boomAngle+59) + baseBoom[2]];
boomHydr = [370 * cos(-boomAngle+64) + baseBoom[0],0,
            370 * sin(-boomAngle+64) + baseBoom[2]];
hydrDipper = [85 * cos(-dipperAngle+69) + boomDipper[0],0,
              85 * sin(-dipperAngle+69) + boomDipper[2]];
dipperBucket = [-dipperLen * 97 * sin(dipperAngle-3) + boomDipper[0],0,
                -dipperLen * 97 * cos(dipperAngle-3) + boomDipper[2]];
dipperLinkage = [-dipperLen * 80 * sin(dipperAngle-4) + boomDipper[0],0,
                -dipperLen * 80 * cos(dipperAngle-4) + boomDipper[2]];
dipperHydr = [-85 * sin(dipperAngle-45) + boomDipper[0],0,
                -85 * cos(dipperAngle-45) + boomDipper[2]];
bucketLinkage = [-36 * cos(-bucketAngle+81) + dipperBucket[0],0,
                -36 * sin(-bucketAngle+81) + dipperBucket[2]];
              
{ //linkage pin requires a lot of math

    //find a vector perpendicular to the distance between the two pins and the y axis
    linkagePerp = cross([0,1,0],dipperLinkage-bucketLinkage);
    linkageMiddle = (dipperLinkage+bucketLinkage)/2;

    //remove the * on the next line to show the vector calculated above
    *translate(linkageMiddle)
    rotate([0,atan2(linkagePerp[0],linkagePerp[2]),0])
    %cylinder(r=8,h=400);

    //used later to find coordinates
    linkageAngle = atan2(linkagePerp[0],linkagePerp[2]);

    //find height of isoceles triangle with base between two linkage pins and side linkageLen
    linkageHeight = sqrt(pow(linkageLen, 2) - pow(norm(dipperLinkage-bucketLinkage)/2,2));

    //find z coord
    linkageZ = linkageHeight * cos(linkageAngle) + linkageMiddle[2];
    //find x coord
    linkageX = linkageHeight * sin(linkageAngle) + linkageMiddle[0];

    //stores the location of the pin that connects the linksge to the piston
    hydrLinkage = [linkageX,0,linkageZ];
}

//draw model, each of the models drawn here can be tweaked without affecting the placement of the pins
color("gold"){
    base();
    boom();
    dipper();
    bucket();
    linkage();
}

//draw pins, their locations are determined entirely by the math above, the models we just drew will not affect their location or movement
color("grey"){
    pin(baseBoom,width+30);
    pin(baseHydr,width+30);
    pin(boomDipper,width+30);
    pin(hydrBoom,width+10);
    pin(boomHydr,width+10);
    pin(hydrDipper,width+30);
    pin(dipperBucket,width+30);
    pin(dipperLinkage,width+60);
    pin(bucketLinkage,width+30);
    pin(hydrLinkage, width+60);
    pin(dipperHydr, width+30);
}


{//draw hydraulics 
    echo("Hydraulic lengths:");
    hydraulic(baseHydr, hydrBoom, 180);
    echo(norm(baseHydr-hydrBoom));
    hydraulic(boomHydr, hydrDipper, 220);
    echo(norm(boomHydr-hydrDipper));
    hydraulic(dipperHydr, hydrLinkage, 170);
    echo(norm(dipperHydr-hydrLinkage));
}

module base(){
    difference(){
        cube([70,70,70],center=true);
        
        rotate([0,30,0])
        translate([0,0,5])
        cube([100,50,65],center=true);
        
        translate([25,0,25])
        rotate([0,45,0])
        cube([70,75,35],center=true);
    }
}

module boom(){
    roundness=8; //controls the roundness of a few corners

    translate(baseBoom) //translate back again (to pin location)
    rotate([90,boomAngle,0])
    translate([-baseBoom[0],-baseBoom[2],0]) //translate to x axis for rotation
    difference(convexity=6){
        linear_extrude(width-1, center=true,convexity=4)
        //rounding some corners
        offset(r=+roundness)offset(delta=-roundness)
        offset(r=-roundness*2)offset(delta=+roundness*2) 
        //the basic shape of the boom
        polygon([[-10,0],
                 [-30,10],
                 [100,boomLen*55+width],
                 [150,boomLen*55+width+40],
                 [180,boomLen*55+width],
                 [boomLen*100,boomLen*55+width],
                 [boomLen*100,boomLen*55+10],
                 [160,boomLen*55-30]
                 ]);
       
       //hollow for boom hydraulic
       rotate([0,0,-30])
       translate([0,170,0])
       cube([50,310,width-16],center=true);
        
       //hollow for dipper hydraulic
       translate([140,350,0])
       cube([80,40,width-16],center=true);
    }
}       

module dipper(){
    roundness=10; //controls the roundness of a few corners
    
    translate(boomDipper)
    rotate([90,dipperAngle,0])
    difference()
    {
        linear_extrude(width+20, center=true,convexity=4)
        offset(r=+roundness)offset(delta=-roundness) //rounding some corners
        //the basic shape of the dipper
        polygon([[-15,-20],
                [-15,20],
                [30,110],
                [80,20],
                [80,-50],
                [30, dipperLen * -100],
                [10, dipperLen * -100]
                ]);
       
       //hollow for bucket hydraulic
       translate([70,-140,0])
       rotate([0,0,6])
       cube([55,200,50],center=true);
        
       //hollow for bucket hinge
       translate([20,10 - dipperLen*100,0])
       cube(50,center=true);
        
       //hollow for dipper hydraulic
       translate([30,70,0])
       cube([120,60,width],center=true);
       //hollow for boom
       translate([0,-5,0])
       cube([50,95,width],center=true);
       
    }
}

module bucket(){
    roundness=25; //controls the roundness of a few corners
    
    translate(dipperBucket)
    rotate([90,bucketAngle,0]){
        //hinge
        hull(){
            cylinder(r=20,h=width-10, center=true);
            translate([-8,-32,0])
            
            cylinder(r=18,h=width-10, center=true);
        }
        
        difference(){
            //outside of bucket
            linear_extrude(width+70, center=true,convexity=4)
            offset(r=+roundness)offset(delta=-roundness)
            polygon([[-20,35],
                    [-12,-10],
                    [-30,-65],
                    [-110,-65],
                    [-160,50]
                    ]);
            
            translate([-80,30,0])
            cube([140,40,140],center=true);
            
            //inside bucket
            linear_extrude(width+60, center=true,convexity=4)
            offset(r=+roundness)offset(delta=-roundness)
            polygon([[-16,40],
                    [-25,-10],
                    [-35,-60],
                    [-105,-60],
                    [-165,55]
                    ]);
        }
        
        //teeth
        for (i=[-50:25:50]){
            translate([-140,10,i])
            linear_extrude(12,center=true)
            polygon([[-3,-4],
                    [-5,10],
                    [1,1],
                    [5,-15]                      
                    ]);
        }        
    }
}

module linkage(){ // bucket linkage
   
    //bucket bar
    translate(bucketLinkage)
    rotate([0,-atan2(hydrLinkage[2]-bucketLinkage[2],hydrLinkage[0]-bucketLinkage[0]),0]){
        difference(){
            union(){
                translate([0,-35,-10])
                cube([linkageLen,70,20]);
                rotate([90,0,0])
                cylinder(d=20,h=70,center=true);
                translate([linkageLen,0,0])
                rotate([90,0,0])
                cylinder(d=20,h=70,center=true);
            }
           cube([600,50,40],center=true);
            
        }
        
    }
    //dipper bar
    translate(dipperLinkage)
    rotate([0,-atan2(hydrLinkage[2]-dipperLinkage[2],hydrLinkage[0]-dipperLinkage[0]),0]){
        difference(){
            union(){
                translate([0,-50,-10])
                cube([linkageLen,100,20]); //I could hull instead but I think this is much faster, it also looks better at lower resolutions
                rotate([90,0,0])
                cylinder(d=20,h=100,center=true);
                translate([linkageLen,0,0])
                rotate([90,0,0])
                cylinder(d=20,h=100,center=true);
            }
           cube([600,80,40],center=true); 
        }
        
    }
    
}

module hydraulic(pin1, pin2, length){ //draws hydraulics between two given points and with a specified minimum length
    xdist = (pin2[0]-pin1[0]);
    zdist = (pin2[2]-pin1[2]);
    
    angle = atan2(xdist,zdist); 
  
    
    translate(pin1)
    rotate([0,angle,0])
    color("black")
    union(){
        cylinder(r=15,h=length);
        rotate([90,0,0])
        cylinder(r=15,h=width-20,center=true);
    }
    
    color("lightgrey")
    translate(pin2)
    rotate([0,180 + angle,0])
    union(){
        cylinder(r=10,h=length);
        rotate([90,0,0])
        cylinder(r=10,h=width-20,center=true);
    }
    
}

module pin(coords,length){ //draws a pin along the y-axis at the specified location
    translate(coords)
    rotate([90,0,0])
    cylinder(d=pinSize,h=length,center=true);
}