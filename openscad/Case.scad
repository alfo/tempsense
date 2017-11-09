$fn = 30;

// Do you have access to a printer that uses soluble support material?
// e.g. HP DesignJets
using_support_material = true;

// The model should be printed upside down in your GCode editor/print server

module pillar(x = 0, y = 0, height = 10) {
    difference() {
        // Main pillar
        translate([x, y, -20])
            cylinder(r = 3, h = height);
        
        // Hole for self-tapping bolts
        translate([x, y, -height - 1])
            cylinder(r = 1.5, h = height / 2);
    }
        
}

difference() {
    union() {
        // Base for Arduino, with mounting holes
        difference() {
            cube([70, 53, 3]);
            translate([14, 2.5, -1])
                cylinder(r = 1.5, h = 5);
            translate([15.3, 50.7, -1])
                cylinder(r = 1.5, h = 5);
            translate([66.1, 7.6, -1])
                cylinder(r = 1.5, h = 5);
            translate([66.1, 35.5, -1])
                cylinder(r = 1.5, h = 5);
        }

        // Base for breadboard to be stuck to
        translate([0, 53, 0])
            cube([120, 50, 3]);
        
        // Mounting pillars
        pillar_height = 20;
        pillar(10, 15, pillar_height);
        pillar(60, 15, pillar_height);
        pillar(10, 95, pillar_height);
        pillar(110, 95, pillar_height);
        pillar(110, 65, pillar_height);
    }
    
    // Text, which can only be printed when using soluble support material
    if (using_support_material) {
        translate([5, 75, 2])
            linear_extrude(1)
                text("Arduino TempSense", font = "Helvetica", size = 9);
    }
}
    