//A simple animation of a bucket, through emptying, this could be used for an animation of a water wheel of for construction equipent or something else

$fn = 40;
angle = 45 * $t;
size = [11,10,5];

bucketFilled(size, angle);

module bucketFilled(size, angle){
    
    color("blue")
    rotate([0,angle,0])
    resize(size)
    difference(){  
        bucketShape();
        translate([0,0,0.5])
        resize([0,9,0])
        bucketShape();
    }
    
    color("aqua", alpha=0.6)
    difference(){
        //water
        scale([0.999,0.999,0.999]) //prevents discolouration due to z-fighting
        rotate([0,angle,0])
        difference(){
            resize(size - [0,1,0])
            translate([0,0,0.5])
            resize([0,9,0])
            bucketShape();    
            translate([0,(size * -[0,0.5,0]), 0.001])
            cube(size);
        }
            
        //water leveller
        lipLevel = ((size * -[1,0,0]) + 0.5) * sin(angle) - 0.01 ;       
        translate([0,(size * -[0,0.5,0]) + 0.4, lipLevel])
        cube(size + [1,-0.8,100]);
    }
}



module bucket(size){
    resize(size) 
    difference(){  
        bucketShape();
        translate([0,0,0.5])
        resize([0,9,0])
        bucketShape();
    }
}


module bucketShape(){
    translate([0,5,0])
    rotate([90,0,0])
    hull() {
        linear_extrude(10)
        polygon(points=[[0,0],[10,0],[5,-2]]);
        translate([5,-3])
        cylinder(d=4,h=10);
    }
}