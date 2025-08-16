// Laptop Camera Cover with Rounded Sides - Sliding Design
// Customizable parameters
// Design parameters
cover_width = 40;      // Width of the cover
cover_height = 15;     // Height of the cover
base_thickness = 1;    // Thickness of the base plate
mid_thickness = 1;     // Thickness of the middle plate
slider_thickness = mid_thickness;  // Thickness of the sliding part
corner_radius = 2;     // Radius for rounded corners
window_width = 8;      // Width of the camera window
window_height = 6;     // Height of the camera window
wall_thickness = 1.2;  // Thickness of walls
slide_clearance = 0.3; // Clearance for sliding mechanism
slider_width = 25;     // Width of the sliding part
margin = 2;           // Margin from edges for hollowing

// View parameters
exploded_view = true;  // Set to true for exploded view
explode_distance = 20; // Distance between parts in exploded view

// Base plate module
module base_plate() {
    difference() {
        // Outer shell
        hull() {
            for (x = [corner_radius, cover_width - corner_radius]) {
                for (y = [corner_radius, cover_height - corner_radius]) {
                    translate([x, y, 0])
                        cylinder(r=corner_radius, h=base_thickness, $fn=30);
                }
            }
        }
        
        // Center cutout
        translate([margin, margin, -0.1])
            hull() {
                for (x = [corner_radius, cover_width - margin*2 - corner_radius]) {
                    for (y = [corner_radius, cover_height - margin*2 - corner_radius]) {
                        translate([x, y, 0])
                            cylinder(r=corner_radius, h=base_thickness + 0.2, $fn=30);
                    }
                }
            }
    }
}

// Middle plate module
module middle_plate() {
    difference() {
        // Outer shell
        hull() {
            for (x = [corner_radius, cover_width - corner_radius]) {
                for (y = [corner_radius, cover_height - corner_radius]) {
                    translate([x, y, 0])
                        cylinder(r=corner_radius, h=mid_thickness, $fn=30);
                }
            }
        }
            
        // Sliding channel
        translate([wall_thickness, wall_thickness, -0.1])
            hull() {
                for (x = [corner_radius, cover_width - wall_thickness*2 - corner_radius]) {
                    for (y = [corner_radius, cover_height - wall_thickness*2 - corner_radius]) {
                        translate([x, y, 0])
                            cylinder(r=corner_radius, h=mid_thickness + 0.2, $fn=30);
                    }
                }
            }
    }
}

// Sliding part module
module slider() {
    total_width = slider_width;
    total_height = cover_height - (wall_thickness * 2) - slide_clearance*2;
    
    translate([wall_thickness + slide_clearance, wall_thickness + slide_clearance, slider_thickness]) {
        difference() {
            // Slider body
            hull() {
                for (x = [corner_radius, total_width - corner_radius]) {
                    for (y = [corner_radius, total_height - corner_radius]) {
                        translate([x, y, 0])
                            cylinder(r=corner_radius, h=slider_thickness, $fn=30);
                    }
                }
            }
            
            // Camera window cutout
            translate([total_width/4, (total_height-window_height)/2, -0.1]) {
                hull() {
                    for (x = [corner_radius, window_width - corner_radius]) {
                        for (y = [corner_radius, window_height - corner_radius]) {
                            translate([x, y, 0])
                                cylinder(r=corner_radius, h=slider_thickness + 0.2, $fn=30);
                        }
                    }
                }
            }
        }
    }
}

// Assembly module
module assembly(exploded = false) {
    if (exploded) {
        // Exploded view - stack parts vertically
        base_plate();
        translate([0, 0, explode_distance]) middle_plate();
        translate([0, 0, explode_distance * 2]) slider();
        translate([0, 0, explode_distance * 3]) base_plate();
    } else {
        // Normal assembly
        base_plate();
        translate([0, 0, base_thickness]) middle_plate();
        translate([0, 0, base_thickness]) slider();
        translate([0, 0, base_thickness + mid_thickness]) base_plate();
    }
}

// Final assembly - use exploded_view parameter
assembly(exploded_view);
