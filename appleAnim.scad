//an animation of a growing apple, this can take quite a while to render for the first time due to the minkowski transform

$fn=40;
size = 1 + 2*$t;

color([pow($t,1),1-pow($t,2),0])
scale([size,size,size])
apple();

module apple(){
    minkowski()
    {
        difference(){
            scale([1,1,1.2])sphere(5);  
            translate([0,0,2])
            cone(4,5);
            translate([0,0,-3])rotate([180,0,0])cone(5,3);
        }
        sphere(1);
    }
}
module cone(r,h){
    rotate_extrude()
    polygon([[0,0],[0,h],[r,h]]);
    
}
module ring(r){
    rotate_extrude()
    translate([r,0])
    circle(d=1);
    
}
