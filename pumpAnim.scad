$fn=150; //if the animation is running slow, consider lowering this term
wheelRadius = 15;
connRodLen = wheelRadius * 2 + 10;

//comment out the one you don't want
cutaway = true; 
cutaway = false; //comment out this line to show   inside cylinder

//Calculating the positions of the crank pin and cross pin
crankPinCoords = [sin(360 * $t)*(wheelRadius + 1.5),
                  cos(360 * $t)*(wheelRadius + 1.5),0];
crossPinPos = sin(360 * $t)*(wheelRadius + 1.5) + sqrt(pow(connRodLen, 2) -  pow(cos(360 * $t) * (wheelRadius + 1.5), 2));

//draw frame
frame();

//draw wheel
rotate([0,0,-360 * $t])
wheel();

//draw the rest
pin(crankPinCoords);
connRod(0, crankPinCoords);
pin([crossPinPos,0,0]);
piston();


module wheel(){
    
    //rim
    color("grey")
    rotate_extrude()
    translate([wheelRadius,-1.5,0])
    square(3);
    
    //hub
    color("silver")
    cylinder(r=3, center=true,h=4);
    //cylinder(r=1, center=true,h=8.5);
    
    //spokes
    for (i = [0:45:359]){
        color("DarkGoldenrod")
        rotate([90,0,i])
        cylinder(d=2,h=wheelRadius);
    }
    
}
module pin(coords){ //places a small cylinder at the given coordinates
    color("gold")
    translate(coords + [0,0,-2])
    cylinder(r=1,h=7.5);
}

module connRod(angle, coords) { //connecting rod
    
    color("silver")
    translate([0,0,3] + coords)
    rotate([0,0, -asin(cos(360 * $t)*(wheelRadius + 1.5) / connRodLen)])
    {
        translate([0,-1.5,0])
        cube([connRodLen, 3, 2]);
        cylinder(r=2, h=2);
        translate([connRodLen,0,0])
        cylinder(r=2, h=2);
    }
}

module piston(){
    
    color("grey")
    translate([crossPinPos,0,0])
    {
        //piston rod
        translate([0,0,-1.5])
        cylinder(r=3, h=3);
        translate([0,-2,-1.5])
        cube([wheelRadius * 2, 4, 3]);
        
        //piston plunger
        translate([wheelRadius * 2,0,0])
        rotate([0,90,0])
        cylinder(r=5, h= 20);
    }
}
module frame(){
    
    //axle
    color("gold")
    translate([0,0,-9.5])
    cylinder(d=3,h=12);
    
    //base
    color("goldenrod")
    translate([-9,-9,-12])
    cube([wheelRadius * 3 + connRodLen + 35,18,4]);
    
    //piston case
    color("silver")
    translate([wheelRadius  + connRodLen + 15,0,0])
    {
        rotate([0,90,0])
        difference(){
            translate([0,0,1])
            cylinder(r=7, h= wheelRadius * 2 + 7);
            cylinder(r=5.1, h= wheelRadius * 2 + 7);
            
            //cutaway
            if (cutaway){
                translate([-8,2,0])
                cube([10,5,wheelRadius * 2 + 9]);
            }
        }
        translate([1,-3,-10])
        cube([wheelRadius * 2 + 5, 6, 5]);
    }
}
