//A bike rack a friend designed for a project, I modeled it and made it easy to tweak. The cylinders beside it are to represent children and give a sense of scale


//base vars, in inches, all measurements are from the center of the pipe, model will be slightly bigger than the specified width
pipeDia = 7/8; 
rackWidth = 48; // diameter of the base
loopWidth = 6; //width of each loop
lowLoopLen = 16; //length of pipe in the vert segment of each loop
highLoopLen = 22; //adjusting this and the previous one may also require tweaking offsets

//resolution setting
res = 60;

//code will create this number of each loop height, currently the code only supports two different alternating heights
numLoops = 4;

//tweaks for lining stuff up, the third one should be automatic but I have yet to figure out the others
highLoopTopExtraOffset = 0.065; 
lowLoopTopExtraOffset = 0.015;
loopOffset = rackWidth/2 - sqrt(pow(loopWidth/2,2) + pow(rackWidth/2,2)) - 0.01; 

//pi
pi = 3.14159;

//angle from center for the loops
// to calculate find % of circumference and multiply by 360
lowLoopAngle = lowLoopLen / (rackWidth * pi) * 360;
highLoopAngle = highLoopLen / (rackWidth * pi) * 360;

//representative children for scale, ~4 and ~8 years old
translate([rackWidth/2 + 18,0,0])
cylinder(d=12,h=40);
translate([rackWidth/2 + 36,0,0])
cylinder(d=15,h=50);

//color("silver")
{
    //positioning the tops of the loops
    rotate([0,0,(1 - (numLoops % 2)) * (180 / numLoops)]) //corrects the position of loops when numLoops is even, I'm not sure why this is needed
    for(i=[0:360/numLoops:369]){
        
        rotate([0,-highLoopAngle,i])
        translate([rackWidth/2+loopOffset+highLoopTopExtraOffset,0,0])
        rotate([0,-90,0]) //moves loop from horizontal to veritcal position
        loopTop(); 
        rotate([0,-lowLoopAngle,i+180/numLoops])
        translate([rackWidth/2+loopOffset+lowLoopTopExtraOffset,0,0])
        rotate([0,-90,0]) //moves loop from horizontal to veritcal position
        loopTop();  
    }

    //places the vertical parts of the loops
    for(i=[0:360/numLoops:369]){
        rotate([0,0,i])
        loopDupe(lowLoopAngle);;  
        rotate([0,0,i+180/numLoops])
        loopDupe(highLoopAngle);;  
    }


    baseRing();
}
//%sphere(d=rackWidth, $fn=60);

//data outputs
echo("Length of base ring pipe:");
echo(rackWidth * pi);
echo("Length of low loop pipe:");
echo(lowLoopLen * 2 + loopWidth * pi / 2);
echo("Length of high loop pipe:");
echo(highLoopLen * 2 + loopWidth * pi / 2);


module baseRing(){
    rotate_extrude(center=true,$fn=res*2)
    translate([rackWidth/2,0,0])
    circle(d=pipeDia,center=true,$fn=res);
}

module loopTop(){
    render(convexity=1) //prevents viewing glitches
    difference(){           
        rotate_extrude(center=true,$fn=res*2)
        translate([loopWidth/2,0,0])
        circle(d=pipeDia,center=true,$fn=res);
        
        translate([-(loopWidth+pipeDia)/2,0,0])
        cube(loopWidth+pipeDia, center=true);
    }
    
}

module loopDupe(angle){ //duplicates the below and offsets to make both sides
    translate([-loopOffset,loopWidth/2,0])
    loopPartial(angle);
    translate([-loopOffset,-loopWidth/2,0])
    loopPartial(angle);
    
}

module loopPartial(angle){ //produces an arc segment for the vertical component
    
    render(convexity=1) //prevents viewing glitches
    rotate([0,0,180])
    difference(){
        rotate([90,0,0]) //moves loop from horizontal to veritcal position
        rotate_extrude(center=true,$fn=res*2)
        translate([rackWidth/2,0,0])
        circle(d=pipeDia,center=true,$fn=res);
        
        union(){ //joins a pair of cubes to cut ring to correct angle
            rotate([0,-90,0])
            translate([-(rackWidth+pipeDia)/2,0,0])
            cube(rackWidth+pipeDia, center=true);        
            rotate([0,90-angle,0])
            translate([-(rackWidth+pipeDia)/2,0,0])
            cube(rackWidth+pipeDia, center=true);
        }
    }
    
    
}