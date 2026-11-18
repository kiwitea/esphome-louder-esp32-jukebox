// Snap-fit holder plate for Elechouse PN532 V4
// Board centred at origin, X right, Y up (8-pin header on +Y, 4-pin header on -X),
// component side up. Plate bottom (z=0) is glued to plywood.
// Print flat, glued face down, PETG recommended, 0.2 mm layers, no supports.

T      = 1.5;      // PCB thickness (measure yours!)
BW     = 42.68;    // board width  (X)
BH     = 40.38;    // board height (Y)
HOLES  = [[-13.95, 12.6], [13.85, -12.6]];
PEG_D  = 2.8;      // peg diameter (hole is 3.05)

BASE   = 1.8;      // plate thickness
PAD_H  = 2.8;      // board stands this high above plate (room for solder tails)
MARGIN = 6.0;      // plate margin around board
G      = 0.30;     // gap finger face <-> board edge
WALL   = 1.2;      // finger thickness (flex direction)
LIP    = 1.2;      // lip reach from finger face -> overlap = LIP-G = 0.9 mm
CLR    = 0.15;     // lip underside clearance above board
FRONT  = 0.5;      // flat front face of the lip tip
UND_ANG= 50;       // lip underside slope (deg from horizontal), rises toward the TIP -> no support needed
RISE   = 1.3;      // lead-in chamfer height
HOOK_L = 5.0;      // lip length along edge
SLOT_O = 1.6;      // flex room outside finger
S_SLOT = 23.5;     // slot end (flex root)
S_END  = 25.5;     // finger end (fixed into plate)
LIFT   = 0;        // fingers print straight up from the bed (keep glue out of the slots!)
$fn = 48;

W2 = BW/2;  H2 = BH/2;
Z_B   = BASE + PAD_H;
Z_T   = Z_B + T;
Z_W    = Z_T + CLR - G*tan(UND_ANG);   // underside height at finger face (lowest point of lip)
Z_TIPB = Z_W + LIP*tan(UND_ANG);       // underside height at lip tip
Z_TOP  = Z_TIPB + FRONT + RISE;
PEG_TOP = Z_T + 0.9;

// [name, rotation, translation, s_tip]
EDGES = [ [0,   [ W2, 0 ], 6.5],    // right
          [-90, [ 0, -H2], 6.5],    // bottom
          [180, [-W2, 0 ], 6.5],    // left
          [90,  [ 0,  H2], 9.0] ];  // top (shifted: keeps clear of 8-pin plug)

// Local frame: n = outward from board edge (x), s = along edge (y)
module edge_frame(e) { translate(e[1]) rotate([0,0,e[0]]) children(); }

module box(n0,n1,s0,s1,z0,z1) { translate([n0,s0,z0]) cube([n1-n0,s1-s0,z1-z0]); }

module finger(st) {
    // flexing wall + fixed end
    box(G, G+WALL, st, S_SLOT, LIFT, Z_TOP);
    box(G, G+WALL, S_SLOT-0.01, S_END, 0, Z_TOP);
    // lip with flat underside and lead-in chamfer
    translate([0, st+HOOK_L, 0]) rotate([90,0,0]) linear_extrude(HOOK_L)
        polygon([[G+0.01, Z_W], [G-LIP, Z_TIPB], [G-LIP, Z_TIPB+FRONT], [G+0.01, Z_TOP]]);
    // root fillet
    linear_extrude(Z_TOP)
        polygon([[G+WALL, S_SLOT-2.0], [G+WALL+1.2, S_SLOT], [G+WALL, S_SLOT]]);
}

module plate_base() {
    difference() {
        linear_extrude(BASE)
            offset(r=3.5) square([BW+2*MARGIN-7, BH+2*MARGIN-7], center=true);
        for (e = EDGES) edge_frame(e)
            box(-0.05, G+WALL+SLOT_O, e[2]-0.6, S_SLOT, -1, BASE+1);
    }
}

union() {
    plate_base();
    // support pads under the board edge at each lip
    for (e = EDGES) edge_frame(e) box(-3.0, -0.2, e[2], e[2]+HOOK_L, BASE-0.01, Z_B);
    // rings + pegs at the mounting holes
    for (h = HOLES) translate([h[0], h[1], 0]) {
        translate([0,0,BASE-0.01]) cylinder(r=2.7, h=PAD_H+0.01);
        translate([0,0,Z_B-0.01]) cylinder(d=PEG_D, h=PEG_TOP-Z_B-0.5);
        translate([0,0,PEG_TOP-0.5]) cylinder(d1=PEG_D, d2=PEG_D-1.0, h=0.5);
    }
    // snap fingers
    for (e = EDGES) edge_frame(e) finger(e[2]);
}
