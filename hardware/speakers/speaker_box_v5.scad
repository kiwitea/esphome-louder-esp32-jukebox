// =============================================================
// Printed speaker box for a Visaton FRS 7 (8 ohm) behind a
// 60 x 60 mm window in a 5 mm plywood dollhouse wall.
//
// Two printed parts:
//   body = front plate with grille + spigot + 4 walls (open at the back)
//   lid  = rear lid with plug and a wire hole
//
// Coordinates: all parts are modelled in PRINT orientation.
//   body: front face (the grille) lies on the print bed, open end up.
//   lid:  flat face on the bed, plug pointing up.
// No supports needed.
//
// Suggested print settings (PETG): 0.2 mm layers, 4 perimeters,
// 100% flow, 235-245 C, fan low (30-50%) for good layer bonding.
// The body needs supports under the ring of the front plate around the
// spigot (only 4.5 mm tall). Use "support on build plate only", Z distance
// 0.25-0.3 mm, 2 interface layers. Nothing else needs support.
// Print one body, one lid and one leg per window (2 of each in total).
// =============================================================

/* [What to render] */
// print = body + lid + leg side by side, section = assembled half cut-away
part = "print"; // [print, body, lid, leg, section]

/* [Wall and window] */
// Square opening in the wood (mm)
window = 60;
// Plywood thickness (mm)
wall_t = 5;
// Gap per side between spigot and window (mm). Increase if you saw roughly.
spigot_clear = 0.3;
// How far the grille face stays behind the front surface of the wood (mm)
spigot_back = 0.5;

/* [Box] */
// Outer width and height of the box (mm), max about 80
box_w = 78;
// Depth from the BACK of the wooden wall to the back of the lid (mm), max 90
depth = 88;
// Side wall thickness (mm)
wall = 3;
// Front plate thickness behind the wall, without the spigot (mm)
plate_t = 4;
// Rounded outer corners (mm)
corner_r = 3;
// Lid plate thickness (mm)
lid_t = 3;
// How far the lid plug goes into the box (mm)
plug_h = 3;
// Gap per side between plug and inner wall (mm). Seal the seam with glue or silicone.
lid_clear = 0.2;
// Diameter of the wire hole in the lid (mm)
wire_d = 4;
// Distance of the wire hole from the bottom inner wall (mm)
wire_from_edge = 8;

/* [Driver] */
// Diameter of the circle through the centres of the 4 flange screw holes (mm)
screw_circle_d = 75.5;
// Angles of the screw holes (degrees, 45 = diagonal)
screw_angles = [45, 135, 225, 315];
// Pilot hole diameter (mm). About 2.6 for M3 self-tapping screws in PETG.
// For M3 heat-set inserts use about 4.0 instead.
screw_pilot_d = 2.6;
// Depth of the blind pilot holes, measured from the rear face of the plate (mm)
screw_depth = 5.5;
// Free cone opening that the grille must not cover (mm)
cone_clear_d = 56;
// Centring rim (recess) around the square flange: on / off
recess_on = true;
// Flange width, it is square (mm)
flange_w = 66.5;
// Total clearance between flange and rim (mm). Raise it if the driver is too tight.
flange_clear = 0.5;
// Corner radius of the recess (mm). Keep it at or below the flange's own corner
// radius (about 2): a smaller value is always safe.
recess_corner_r = 1;
// Wall thickness of the rim (mm)
recess_wall = 1.6;
// Height of the rim (mm), about the thickness of the flange
recess_h = 1.5;
// Approximate volume taken up by the driver's magnet and frame (litres)
driver_vol_l = 0.09;

/* [Grille] */
// Hexagonal hole width, across the flats (mm)
grille_hole_d = 5;
// Material between holes (mm)
grille_bar = 2.5;

/* [Support leg] */
// Height of the window's bottom edge above the dollhouse floor (mm)
window_bottom_height = 51;
// Thickness of the soft pad under the foot, e.g. self-adhesive felt or foam (mm)
pad_t = 2;
// How much the pad should be squeezed when installed (mm)
pad_squeeze = 0.5;
// Post size: width across the box and length along the box (mm)
leg_w = 14;
leg_d = 24;
// Top and foot plates stick out this far on every side of the post (mm)
leg_plate_extra = 4;
// Thickness of the top and foot plates (mm)
leg_plate_t = 2.5;
// Height of the flared transition (pyramid) under the top plate (mm).
// Equal to leg_plate_extra gives 45 degrees, which prints without support.
// Smaller values are steeper overhangs, so do not go below about 3.
leg_flare_h = 4;
// Distance from the back of the box to the rear edge of the leg (mm)
leg_from_back = 10;
// Raised frame on the bottom of the box that locates the leg: on / off
leg_seat_on = true;
// Total clearance between leg plate and frame (mm), so the plate drops in without force
leg_seat_clear = 0.3;
// Height of the frame (mm), about 1 mm is enough to stop any sliding
leg_seat_h = 1;
// Width of the frame wall (mm)
leg_seat_wall = 1.2;

/* [Quality] */
$fn = 64;

// -------------------------------------------------------------
// Derived values
// -------------------------------------------------------------
spigot_w   = window - 2 * spigot_clear;
spigot_h   = wall_t - spigot_back;
inner_w    = box_w - 2 * wall;
cavity_len = depth - plate_t - lid_t;
body_len   = spigot_h + plate_t + cavity_len;

// Gap between the bottom of the box and the floor, assuming the box is
// centred vertically on the window
floor_gap  = window_bottom_height - (box_w - window) / 2;
leg_h      = floor_gap - pad_t + pad_squeeze;
leg_plate_w = leg_w + 2 * leg_plate_extra;
leg_plate_d = leg_d + 2 * leg_plate_extra;
// Centre of the leg along the box depth, in body coordinates
leg_zc = body_len + lid_t - leg_from_back - leg_plate_d / 2;

assert(depth <= 90, "Depth is more than the 90 mm available.");
assert(box_w <= 80, "Box is wider than 80 mm.");
assert(box_w > window + 2 * 4, "Glue ring around the window is less than 4 mm.");
assert(screw_circle_d / 2 < inner_w / 2 * sqrt(2) - 4, "Screw holes collide with the box corners.");
assert(!leg_seat_on || leg_zc + leg_plate_d / 2 + leg_seat_clear / 2 + leg_seat_wall + leg_seat_h <= body_len,
       "Leg frame would run onto the lid. Increase leg_from_back.");
assert(!leg_seat_on || leg_plate_w + leg_seat_clear + 2 * leg_seat_wall + 2 * leg_seat_h < box_w - 2 * corner_r,
       "Leg frame is wider than the flat bottom of the box.");
assert(!recess_on || flange_w + flange_clear + 2 * recess_wall < inner_w - 0.5,
       "Recess rim is too wide for the box. Make the box wider or the rim thinner.");

echo(str("Inner size: ", inner_w, " x ", inner_w, " mm"));
echo(str("Free depth behind the plate (with lid plug): ", cavity_len - plug_h, " mm"));
echo(str("Air volume without driver: ",
         round(inner_w * inner_w * (cavity_len - plug_h) / 1000) / 1000, " L"));
echo(str("Air volume with driver (estimate): ",
         round((inner_w * inner_w * (cavity_len - plug_h) / 1e6 - driver_vol_l) * 1000) / 1000, " L"));

// -------------------------------------------------------------
// Helpers
// -------------------------------------------------------------
module rsquare(w, r) {
    offset(r = r) square(w - 2 * r, center = true);
}

// Honeycomb of hexagonal holes inside the cone opening.
// grille_hole_d is the width across the flats; the bars between
// neighbouring holes all have the same width (grille_bar).
module grille_holes(h) {
    p  = grille_hole_d + grille_bar;          // centre-to-centre distance
    dy = p * sqrt(3) / 2;
    rc = grille_hole_d / sqrt(3);             // corner radius of one hexagon
    n  = ceil(cone_clear_d / p) + 1;
    for (j = [-n : n]) for (i = [-n : n]) {
        x = i * p + (abs(j) % 2) * p / 2;
        y = j * dy;
        if (norm([x, y]) + rc <= cone_clear_d / 2)
            translate([x, y, -1])
                rotate(30) cylinder(r = rc, h = h + 2, $fn = 6);
    }
}

// -------------------------------------------------------------
// Part 1: body
// -------------------------------------------------------------
module body() {
    difference() {
        union() {
            // spigot that sits in the window
            linear_extrude(spigot_h) square(spigot_w, center = true);
            // plate + walls
            translate([0, 0, spigot_h])
                linear_extrude(plate_t + cavity_len) rsquare(box_w, corner_r);
        }
        // inner cavity, open to the back
        translate([0, 0, spigot_h + plate_t])
            linear_extrude(cavity_len + 1) square(inner_w, center = true);
        // grille
        grille_holes(spigot_h + plate_t);
        // blind pilot holes for the flange screws
        for (a = screw_angles)
            rotate(a)
                translate([screw_circle_d / 2, 0, spigot_h + plate_t - screw_depth])
                    cylinder(d = screw_pilot_d, h = screw_depth + 1);
    }
    // raised frame on the bottom of the box that locates the support leg
    // (outside faces slope at 45 degrees so it prints without support)
    if (leg_seat_on) {
        top_w  = leg_plate_w + leg_seat_clear + 2 * leg_seat_wall;
        top_d  = leg_plate_d + leg_seat_clear + 2 * leg_seat_wall;
        base_w = top_w + 2 * leg_seat_h;
        base_d = top_d + 2 * leg_seat_h;
        translate([0, -box_w / 2 + 0.01, leg_zc])
            rotate([90, 0, 0])
                difference() {
                    linear_extrude(leg_seat_h + 0.01,
                                   scale = [top_w / base_w, top_d / base_d])
                        square([base_w, base_d], center = true);
                    translate([0, 0, -1])
                        linear_extrude(leg_seat_h + 3)
                            square([leg_plate_w + leg_seat_clear,
                                    leg_plate_d + leg_seat_clear], center = true);
                }
    }
    // centring rim (recess) for the square flange
    if (recess_on)
        translate([0, 0, spigot_h + plate_t])
            linear_extrude(recess_h)
                difference() {
                    rsquare(flange_w + flange_clear + 2 * recess_wall,
                            recess_corner_r + recess_wall);
                    rsquare(flange_w + flange_clear, recess_corner_r);
                }
}

// -------------------------------------------------------------
// Part 2: lid (printed plate down, plug up)
// -------------------------------------------------------------
module lid() {
    wire_y = -(inner_w / 2 - wire_from_edge);
    difference() {
        union() {
            linear_extrude(lid_t) rsquare(box_w, corner_r);
            translate([0, 0, lid_t])
                linear_extrude(plug_h) square(inner_w - 2 * lid_clear, center = true);
        }
        translate([0, wire_y, -1]) cylinder(d = wire_d, h = lid_t + plug_h + 2);
    }
}

// Lid in its assembled position (plug pointing towards the front)
module lid_assembled() {
    translate([0, 0, body_len + lid_t]) mirror([0, 0, 1]) lid();
}

// -------------------------------------------------------------
// Part 3: support leg (printed standing on its foot plate)
// Glue the top plate to the bottom of the box. Put a soft pad
// (felt or foam, thickness pad_t) under the foot, do not glue the foot.
// -------------------------------------------------------------
module leg() {
    // foot plate
    linear_extrude(leg_plate_t) square([leg_plate_w, leg_plate_d], center = true);
    // post
    translate([0, 0, leg_plate_t - 0.01])
        linear_extrude(leg_h - 2 * leg_plate_t - leg_flare_h + 0.02)
            square([leg_w, leg_d], center = true);
    // flare: pyramid frustum from the post size up to the plate size,
    // so the top plate does not overhang abruptly
    translate([0, 0, leg_h - leg_plate_t - leg_flare_h])
        linear_extrude(leg_flare_h + 0.01,
                       scale = [leg_plate_w / leg_w, leg_plate_d / leg_d])
            square([leg_w, leg_d], center = true);
    // top plate
    translate([0, 0, leg_h - leg_plate_t])
        linear_extrude(leg_plate_t) square([leg_plate_w, leg_plate_d], center = true);
}

// Leg in its assembled position (box bottom = -y side)
module leg_assembled() {
    translate([0, -box_w / 2 - leg_h, leg_zc])
        rotate([-90, 0, 0]) leg();
}

echo(str("Gap box bottom to floor: ", floor_gap, " mm, leg height: ", leg_h, " mm"));
assert(leg_h > 2 * leg_plate_t + leg_flare_h + 2, "Leg is too short: check window_bottom_height.");
assert(leg_flare_h >= leg_plate_extra * 0.75, "Flare is too steep to print without support: raise leg_flare_h.");

// -------------------------------------------------------------
// Output
// -------------------------------------------------------------
if (part == "body") {
    body();
} else if (part == "lid") {
    lid();
} else if (part == "leg") {
    leg();
} else if (part == "section") {
    difference() {
        union() { body(); lid_assembled(); leg_assembled(); }
        translate([0, -200, -10]) cube([200, 400, 300]);
    }
} else {
    body();
    translate([box_w + 10, 0, 0]) lid();
    translate([1.5 * box_w + 20 + leg_plate_w / 2, 0, 0]) leg();
}
