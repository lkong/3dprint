//dimensions for cap connector
c_out_dia=5.6;
c_in_dia=3.9;
c_gap=1.6;
c_space = 4;
//cut out size
cut_h=9;
cut_x=1.4;
cut_y=1;


// keycap shape
head_tilt = 3;              // rotation of top around x-axis
head_pos = 2.25;            // keycap top y-offset
head_height = 11;           // z-offset of keycap top from the bottom of the keycap
cutoff = 6.5;               // cut keycap here to make room for decoration
                            // must be bigger than c_space + c_corr
key_scale = [1.01,1.01,1.01]; // overall scale

// stuff
$fn = 64;

// create basic key shape from dxf frames for base and top
module shape()
{
    hull()
    {
        translate([0,0,-c_inset]) linear_extrude(height=.01) import("base.dxf");
        rotate([head_tilt,0,0]) translate([0,6.75+head_pos,head_height-c_inset]) linear_extrude(height=.01) import("top.dxf");
    }
}

// construct the connector pin
module connector() 
{
	difference(){
		cylinder(h=c_space,r=c_out_dia/2);
		cylinder(h=c_space,r=c_in_dia/2);
		//cube(size = [c_out_dia,c_gap,c_space], center = true);
		} 
}


// create the hollow key with decoration
module key()
{
    difference()
    {
        // combine basic key shape with decoration
        union()
        {
           // translate(obj_pos) rotate(obj_rot) scale(obj_scale) import(obj);
            
            difference()
            {
                shape();
                rotate([head_tilt,0,0]) translate([0,0,5+cutoff-c_inset]) cube([100,100,10], center=true);
            }
        }

        // subtract scaled basic shape, cut at minimum required height
        difference()
        {
            scale([.9,.9,.9]) translate([0,0,-1]) shape();
            translate([0,0,5+c_space+c_corr]) cube([100,100,10], center=true);
        }
    }
}

// combine key, pin and connector. cleanup below the key
scale(key_scale) difference()
{
    union() 
    { 
        key();
			connector();		
    }
    
	

	//translate([0,0,-50-c_inset]) cube([100,100,100], center=true);
}
