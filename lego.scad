fudge = 0.1;




// Row 4 decorated Cherry MX key

// dimensions Cherry MX connector
c_corr = .1;                // tolerance
c_horiz = 1.1;              // horizontal bar width
c_vert = 1.0;               // vertical bar width
c_dia = 4;                  // cross width
c_depth = 4.5;                // connector depth
c_space = 4;                // height of hollow inside
c_inset = .75;              // distance connector start to keycap base

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
key_scale = [1.03,1.03,1.03]; // overall scale

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
    translate([0,0,c_depth/2-.1]) union()
    {
        cube([c_vert+c_corr,c_dia+c_corr,c_depth+.1], center=true );
        cube([c_dia+c_corr,c_horiz+c_corr,c_depth+.1], center=true );
    }
}

module lego()
{
translate([-41,-19,8.4])
	import("Lego_4Block.stl");
}


// create the hollow key with decoration
module key()
{
    difference()
    {
        // combine basic key shape with decoration
        union()
        {

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
scale(key_scale) 
difference()
{
	
	union()
	{
		lego();
		scale([1,1,2])
			difference()
			{
				cylinder( h=c_space+c_corr, r=(c_dia+c_corr+1.5)/2 );
				scale([1.1,1.1,1.1])
				connector();
			}
	}
	translate([-3,2.0,-1])
		cube([6,4.49,7.39]);
	translate([-3,-6.3,-1])
		cube([6,4.29,7.39]);
	translate([-20,-20,-0.5])
		cube([40,40,3]);
	//translate([-5,-2.5,0])
		//cube([10,10,8]);	
}


