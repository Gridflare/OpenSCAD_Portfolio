//Part of a school project

$fn = 80;
vecRadius = 1;
origin = [0,0,0]; //convenience

//$convert -delay 5 -loop 0 *.png genevaVec.gif

drivenPoints = 4;
cycleSize = 360/drivenPoints;
driverR = 30; //Driver Radius
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
drawVecP(origin,0,gearSep,colour="lightgrey"); //Draw Sep vector (R1)
drawVecP(origin,driverA,driverR,colour="blue"); //Draw Driver vector (R2)

//Only draw if norm(diff) < drivenRo
if (norm(diff) <= drivenRo){
    drawVecP([gearSep,0,0],drivenA,drivenRi,"red"); //Draw drivenRi (R3i)
}

for (a=[0:cycleSize:359]) {
    drawVecP([gearSep,-5,0],drivenA+a,drivenRo); // Draw drivenRo (R3o)
}

// Polar coordinates, around z axis on xz plane
module drawVecP(basePos,angle,mag,colour="yellow",tipSize=2){
    translate([basePos[0],0,basePos[1]])
    color(colour)
    rotate([0,90,angle]){
        cylinder(r=vecRadius,h=mag-tipSize);
        translate([0,0,mag-tipSize])
        cylinder(r1=tipSize*0.8,r2=0,h=tipSize);
    }
}

function sqr(x) = pow(x,2);