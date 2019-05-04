//Part of a school project

$fn = 80;
vecRadius = 0.5;
origin = [0,0,0]; //convenience

//R3 Driven, R2 Driver

//$convert -delay 5 -loop 0 *.png genevaVec.gif

//Units in mm
drivenPoints = 4;
cycleSize = 360/drivenPoints;
driverR = 12; //Driver Radius
driverA = 360*$t - 90;
drivenRo = driverR; //Driven Outer Radius, set =, as in benwyrosdick sample
gearSep = driverR / cos(cycleSize/2); //Distance between wheels, eqtn stolen from benwyrosdick sample
echo("Gear Radius",drivenRo);
echo("Gear Separation",gearSep);

drivenX = gearSep + driverR * cos(driverA);
drivenY = driverR * sin(driverA);

//Converting between relative and absolute co-ordinates
diff = [drivenX,drivenY,0] - 2*[gearSep,0,0]; // What is this factor of two?

//If driver driving driven comput angle, else, set to an apropriate extrema
drivenA = (norm(diff) < drivenRo) ? //Nested ternary? Gross, but scope rules are scope rules
            atan2(diff[1],diff[0]) : 
            (drivenY > 0) ? (90+cycleSize/2) : (180+cycleSize/2);
drivenRi = min(norm(diff),drivenRo);

echo("Driven Angle:",drivenA);

////Do All Drawing Below Here////

// Polar coordinates, around z axis on xz plane
module drawVecP(basePos,angle,mag,colour="yellow",tipSize=1.5){
    translate([basePos[0],0,basePos[1]])
    color(colour)
    rotate([0,90,angle]){
        cylinder(r=vecRadius,h=mag-tipSize);
        translate([0,0,mag-tipSize])
        cylinder(r1=tipSize*0.8,r2=0,h=tipSize);
    }
}

function sqr(x) = pow(x,2);

pinRad = 2;

module pin(pos){
    color("lightgrey")
    translate(pos)
    cylinder(h=3,r=pinRad,center=true);
}


//Code below here by benwyrosdick
//And modified under CC BY 3.0 http://creativecommons.org/licenses/by/3.0/
//https://www.thingiverse.com/thing:2311551
axleH = 20;
axleR = 2.9;
platterH = 2;
platterR = 30;
gearThickness = 2;
fudge = 0.005;
cutHeight = gearThickness + 2 * fudge;
margin = 3; // platform margin
//c=gearSep
//b=driverR

p = 3; // drive pin diameter
t = 0.2; // allowed clearance
a = sqrt(pow(gearSep, 2) - pow(driverR, 2)); // drive crank radius
y = a - pow(p, 1.5); //stop arc radius
z = y - t; // stop disc radius
w = p + t; // slot width
s = a + driverR - gearSep; //slot center length

echo(a);

// Geneva wheel
color("blue")
translate([gearSep,0,gearThickness+fudge])
rotate([0,0,drivenA-45])
difference() {
    cylinder(r = driverR, h = gearThickness);
    
    translate([0,0,-fudge])
    cylinder(r = axleR*0.8, h = cutHeight);
    
    for (i = [0:drivenPoints-1]) {
        rotate([0,0,360/drivenPoints*i]) {
            translate([gearSep,0,-fudge])
            cylinder(r = y, h = cutHeight);
            
            rotate([0,0,360/(drivenPoints*2)])
            hull() {
                translate([driverR,0,-fudge])
                cylinder(d = w, h = cutHeight);
                translate([driverR-s,0,-fudge])
                cylinder(d = w, h = cutHeight);    
            }
        }
    }
}

// Crank wheel
crankHandleWidth = 3;
color("red")
translate([0,0,0])
rotate([0,0,driverA])
difference() {
    union() {
        cylinder(r = drivenRo+2, h = gearThickness);
        
        translate([0,0,gearThickness-fudge]) {
            translate([a,0,0])
            cylinder(d = p, h = gearThickness);
            
            difference() {
                cylinder(r = z, h = gearThickness);
                
                translate([gearSep,0,0])
                cylinder(r = driverR+t, h = gearThickness+fudge);
            }
        }
    }
    
    gearDivots = floor(drivenRo * 2 * 3.14 / (2 * w));
    for (i = [0:gearDivots-1]) {
        deg = 360 / gearDivots;
        rotate([0,0,deg*i+deg/2])
        translate([drivenRo+2,0,-fudge])
        cylinder(d = w, h = cutHeight);
    }
    
    translate([0,0,-fudge])
    cylinder(r = axleR*0.8, h = 2 * (gearThickness + fudge));
}

// platform
wheelBase = driverR + margin;
crankBase = drivenRo + margin;
color([0.3,0.3,0.3])
translate([0,0,-gearThickness])
union() {
        hull() {
            cylinder(r = crankBase, h = gearThickness);
            
            translate([gearSep,0,0])
            cylinder(r = wheelBase, h = gearThickness);
            
        }

        wheelPlatformRadius = gearSep-drivenRo-t+driverR/4;
        translate([gearSep+driverR/4,0,0])
        cylinder(r = wheelPlatformRadius, h = 2*gearThickness);

        cylinder(d = 1.8*axleR-t, h = 3.5*gearThickness);
        
        translate([gearSep,0,0])
        cylinder(d = 1.8*axleR-t, h = 3.5*gearThickness);
}

//Code Below here by Gridflare again

//Axle
color("lightgrey")
translate([gearSep,0,2*gearThickness])
cylinder(r=axleR,h=axleH);

//Platter
blockwidth = 8;

translate([gearSep,0,axleH+0.8*gearThickness])
rotate([0,0,drivenA+45]){
    color("grey",alpha=0.5)
    cylinder(r=platterR,h=platterH);
    
    color("lightgrey")
    for (i = [0:90:359]) {
        rotate([0,0,i])
        translate([0.6*platterR,-blockwidth/2,0.1])
        cube([6,8,5]);
        
    }
    
}
