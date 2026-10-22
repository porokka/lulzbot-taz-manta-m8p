// BTT Smart Filament Sensor V2.0 bracket - TAZ universal toolhead adapter
//
// Picks up THREE existing fixings on v2_aero_mount_for_taz6_no_switch.stl:
// two screws DOWN through the mid-height shelf, and one screw SIDEWAYS into the
// slot in the protruding top nose. Those two screw axes are perpendicular, so
// this cannot be a flat plate - it is a vertical web on an L-foot. The foot is
// the "3 mm ledge": measured, the shelf screw centres stand 3.72 mm off the
// nose face, so the foot has to reach at least that far.
//
// Three points beats two: bolted at three non-collinear points the plate cannot
// rotate or rock, and the sensor's 36 g is carried in shear through the screws
// rather than in bending through a cantilever.
//
// ---------------------------------------------------------------------------
// EVERY DIMENSION BELOW IS MEASURED FROM THE ADAPTER STL, NOT ESTIMATED.
//   python3 find_holes.py v2_aero_mount_for_taz6_no_switch.stl
// which reports, in the STL's own coordinates:
//   Y-axis  hole  d3.99  X -63.72  Y 43.25  Z  6.53   depth 3.75   shelf, left
//   Y-axis  hole  d3.99  X -63.72  Y 43.25  Z 54.53   depth 3.75   shelf, right
//   X-axis  slot  4.40 x 10.93     Y 94.57  Z 35.89   depth 6.14   nose
// STL axes map to the machine as: Y up, Z across, X front-back (14.64 thick).
//
// Beware the same file's four PERFECT circles at 50 nanometres depth - they are
// coincident-face seams in the mesh, not holes. They read as tidy M6/M5 fixings
// and the first version of this bracket was built on two of them.
// ---------------------------------------------------------------------------
//
// Sensor, from the BTT spec sheet:
//   body 53.1 x 30.3 x 27.3    weight 36 g
//   mounting holes 12.4 x 24.7 detection length 2.88 mm
//   working temperature -10 to +50 C
//
// TEMPERATURE: measured by hand at this location during a print - not even
// finger-warm, so comfortably inside the sensor's range. Revisit only if the
// machine gets enclosed; the bracket comes off with three screws.
//
// PRINT ORIENTATION: the flat BACK face - the one that beds against the
// adapter - down on the bed. Everything then grows upward off a solid first
// layer: the boss stands on solid web, the foot and gusset build straight up,
// and nothing needs support.
// It is also the strong orientation. Foot and web appear together in every
// layer from 0 to plate_t, so their junction is monolithic rather than a
// bond between layers - and that junction is the only place this part sees
// real bending. Stood on its foot instead, the boss becomes a 15 mm
// unsupported sideways overhang and the same junction becomes a peel joint.

/* [Measured from the adapter STL] */
// Shelf screw centres, Z 6.53 -> 54.53.
base_spacing   = 48.00;
// How far the shelf screw centres stand off the nose face (X -63.72 vs -60.00).
// This is what forces the foot to exist.
base_standoff  = 3.72;
// Nose slot centre above the shelf TOP surface (Y 94.57 vs 43.25 + 3.75/2).
top_height     = 49.45;
// Nose slot sideways from the midpoint of the shelf pair (Z 35.89 vs 30.53).
top_offset_x   = 5.36;

/* [Fixings] */
// Nominal M4 clearance is 4.3, and at 4.3 the printed hole came out too tight
// to pass a screw: a vertical hole loses 0.2-0.4 mm to elephant foot and to
// the inner perimeter being dragged inward on every layer, which lands it back
// at 4.0 - exactly nominal M4. These are clearance holes carrying nothing in
// bearing, so oversizing them costs nothing and a tight one costs a reprint.
base_screw_d   = 4.8;
// Driver access. A ROUND BORE DOES NOT WORK HERE and the first print proved
// it: the screw axis is only base_standoff (3.72) off the adapter face, so a
// coaxial bore wider than ~7.4 breaks out through the back - and 7.4 takes a
// hex key but not a screwdriver. The holes had to be opened up by hand.
// So the gusset is simply cut away above each screw instead, which leaves an
// unobstructed path of any width, and ribs either side still carry the joint.
// Only as wide as the screw needs: a wide notch eats the boss beside it.
access_side    = 2.5;     // clear space either side of the screw
base_access_w  = base_screw_d + 2 * access_side;
// Full gusset height, so a driver can get properly at the head. Kept as a
// literal because gusset_h is defined further down; the assert at the bottom
// catches it if the two ever disagree.
base_access_h  = 14;
// The right-hand notch steps narrower where it runs past the sensor boss, so
// a real wall is left between it and the lower-right sensor screw. Below the
// boss it stays full width, because nothing is in the way down there.
// Only the right side needs this - the left notch never reaches the boss.
access_top_w   = 6;

// Relief on the BACK face, behind each sensor screw. Without it a screw longer
// than plate_t + boss_h stands proud and holds the bracket off the adapter -
// on the first print that needed a hot iron to sink them.
//
// SCREW LENGTH IS CRITICAL - USE M3 x 16, NOT LONGER.
// Material from the relief floor to the sensor face is
//     plate_t + boss_h - back_relief_h = 5 + 14 - 4 = 15 mm
// so a 20 mm screw stands 5 mm proud into the sensor body. That is enough to
// reach the ENCODER WHEEL and jam it. The symptom is brutal to diagnose from
// the control board: the switch half keeps working, the motion half goes
// completely silent, and it looks exactly like dead encoder electronics.
// Cost us three plug positions and two wrong conclusions before the wheel was
// found binding only when the housing was closed.
// 16 mm leaves ~1 mm of engagement, which is all the sensor wants.
back_relief_d  = 8;
// 5 deep, which is the whole of plate_t: raising boss_h from 10 to 15 added
// 5 mm of material in front of these screws, and sinking the relief by the
// same 5 takes it back off behind them. Screws cut for the old 15 mm stack
// still reach. The relief breaks clean through the web, so each screw is
// carried by the boss alone - 15 mm of it, against the 5 mm of engagement
// these need.
back_relief_h  = 4;      // follows boss_h down, so the screw still lands 5 mm
                         // into the sensor rather than 1 mm deeper and bottoming
top_screw_d    = 4.3;     // the adapter's nose slot measures 4.40 wide
// The adapter's slot runs VERTICALLY, so this one runs ACROSS - together they
// give adjustment on both axes and the three holes need not line up perfectly.
top_slot_len   = 5;

/* [Sensor] */
sensor_hole_dx = 24.7;    // spec sheet
sensor_hole_dy = 12.4;    // spec sheet
// M3 CLEARANCE - the thread is in the sensor body, so these must pass freely.
// Not 3.2: a printed vertical hole loses 0.2-0.4 and lands back at nominal M3,
// which is what forced the lower screws. The head is captured by the back
// relief, so slop here costs nothing.
sensor_screw_d = 3.5;
sensor_body_w  = 53.1;
sensor_body_h  = 30.3;
// Centre height of the sensor on the web. The body is 30.3 tall, so a centre at
// 25 puts its underside ~10 mm above the shelf screws - the "1 cm up" figure.
sensor_y       = 25;
// Both of these came off the assembled bracket, not the drawing: offered up to
// the toolhead, the sensor sat 5 mm across and 5 mm short of where the
// filament path wants it. Flip the sign of sensor_x if it moves the wrong way.
sensor_x       = 5;       // sensor pattern across the web, + is toward base_r
boss_h         = 14;      // was 15 - measured 1 mm too far out on the fitted part
// Material around the sensor hole pattern. This also sets how far DOWN the
// boss reaches, which is what decides whether it fouls the shelf-screw
// notches - so it is not a free choice, see the assert at the bottom.
boss_margin    = 4.5;

/* [Structure] */
plate_t        = 5;       // web thickness, sits against the nose face at z=0
foot_t         = 5;       // shelf-to-underside of the foot
foot_depth     = 10;      // must exceed base_standoff + screw head + material
gusset_h       = 12;      // how far the web-to-foot wedge climbs the web
corner_r       = 14;      // material around each fixing centre

/* [LGX tension lever clearance] */
// The lever must stay reachable - it was needed once to diagnose whether the
// gears were gripping, and it will be needed again.
// VERIFIED on the fitted part: no cut needed. The sensor body is wider than
// the LGX Ace, so it stands clear of the lever on its own and the lever stays
// reachable. Left here as a parameter in case a narrower sensor is fitted.
lever_cut      = false;
lever_cut_w    = 16;
lever_cut_h    = 14;
lever_cut_x    = 0;
lever_cut_y    = 20;

$fn = 64;

// --------------------------------------------------------------- geometry
// Local frame: origin at the midpoint of the two shelf screws, on the shelf
// top surface and on the nose face.
//   x = across the machine   y = up   z = away from the adapter

base_l = [-base_spacing / 2, 0];
base_r = [ base_spacing / 2, 0];
apex   = [ top_offset_x,     top_height];
foot_w = base_spacing + 2 * corner_r;

// Triangular web: a hull of three discs, so every corner is filleted and there
// is real material around each screw. Clipped at y=0 where the foot takes over.
module web_profile() {
    intersection() {
        hull() {
            translate([base_l[0], corner_r]) circle(r = corner_r);
            translate([base_r[0], corner_r]) circle(r = corner_r);
            translate(apex) circle(r = corner_r);
        }
        translate([-foot_w, 0]) square([2 * foot_w, top_height + 2 * corner_r]);
    }
}

module web() {
    linear_extrude(height = plate_t) web_profile();
}

// The foot the shelf screws pass down through.
module foot() {
    translate([-foot_w / 2, 0, 0])
        cube([foot_w, foot_t, foot_depth]);
}

// Wedge across the web-to-foot joint - the only part of this bracket that sees
// bending. Driver access through it is cut in fixings().
module gusset() {
    hull() {
        translate([-foot_w / 2, foot_t + gusset_h, 0])
            cube([foot_w, 0.01, plate_t]);
        translate([-foot_w / 2, foot_t, 0])
            cube([foot_w, 0.01, foot_depth]);
    }
}

module rounded_sq(w, h, r) {
    offset(r = r) offset(delta = -r) square([w, h], center = true);
}

// The boss the sensor bolts to, standing it clear of the adapter and lining its
// bore up with the extruder inlet. Tapered so it does not meet the web at a
// sharp internal corner.
module boss() {
    bw = sensor_hole_dx + 2 * boss_margin;
    bh = sensor_hole_dy + 2 * boss_margin;
    // Rounded by offset(r) offset(-r), which radiuses the corners WITHOUT
    // growing the outline. The old offset(r=6) on an already-oversized square
    // inflated the base to 50.7 x 38.4 - far bigger than the 24.7 x 12.4 hole
    // pattern needs - and that overhang is what reached down over the shelf
    // screws and fouled them.
    translate([sensor_x, sensor_y, plate_t])
        hull() {
            linear_extrude(height = 0.01) rounded_sq(bw, bh, 5);
            translate([0, 0, boss_h])
                linear_extrude(height = 0.01) rounded_sq(bw - 4, bh - 4, 4);
        }
}

module fixings() {
    // Shelf screws: vertical, down through foot and gusset, with a bore above
    // each so a driver can actually reach the head.
    // cylinder() extrudes along Z, so rotate it to point up the Y axis - these
    // screws go DOWN through the foot, not through the web face.
    for (p = [base_l, base_r]) {
        translate([p[0], 0, base_standoff]) rotate([-90, 0, 0])
            translate([0, 0, -1])
                cylinder(d = base_screw_d, h = foot_t + gusset_h + 2);
        // L-shaped: full width up to the underside of the boss, then stepped
        // in. Below the boss the width costs nothing; above it, every extra
        // millimetre comes straight out of the sensor screw's wall.
        boss_bottom = sensor_y - (sensor_hole_dy / 2 + boss_margin);
        top_w = p[0] > 0 ? access_top_w : base_access_w;
        translate([p[0] - base_access_w / 2, foot_t, -1])
            cube([base_access_w, boss_bottom - foot_t, foot_depth + 2]);
        translate([p[0] - top_w / 2, boss_bottom, -1])
            cube([top_w, foot_t + base_access_h - boss_bottom, foot_depth + 2]);
    }

    // Nose slot: horizontal, through the web, running across to pair with the
    // adapter's vertical slot.
    translate([apex[0], apex[1], -1])
        hull() for (dx = [-top_slot_len / 2, top_slot_len / 2])
            translate([dx, 0, 0]) cylinder(d = top_screw_d, h = plate_t + 2);

    // Sensor holes, through web and boss.
    for (x = [-1, 1], y = [-1, 1])
        translate([sensor_x + x * sensor_hole_dx / 2,
                   sensor_y + y * sensor_hole_dy / 2,
                   -1])
            cylinder(d = sensor_screw_d, h = plate_t + boss_h + 2);

    // Relief behind each of them, on the face that beds against the adapter.
    for (x = [-1, 1], y = [-1, 1])
        translate([sensor_x + x * sensor_hole_dx / 2,
                   sensor_y + y * sensor_hole_dy / 2,
                   -1])
            cylinder(d = back_relief_d, h = back_relief_h + 1);

    if (lever_cut)
        translate([lever_cut_x - lever_cut_w / 2, lever_cut_y, -1])
            cube([lever_cut_w, lever_cut_h, plate_t + 2]);
}

difference() {
    union() { web(); foot(); gusset(); boss(); }
    fixings();
}

// --------------------------------------------------------------- sanity
assert(foot_depth > base_standoff + base_screw_d / 2 + 1,
       "foot is too shallow to contain the shelf screws");
assert(plate_t < foot_depth, "web must be thinner than the foot is deep");
// Gusset left between the two access notches, and outboard of them.
assert(base_access_h <= gusset_h + 2,
       "access notch is taller than the gusset it cuts through");

// The notch and the lower sensor screw hole creep toward each other as the
// sensor shifts across. This is the clearance that actually matters.
sensor_hole_edge = sensor_x + sensor_hole_dx / 2 + sensor_screw_d / 2;
// Measured against the STEPPED part, which is the bit that runs past the boss.
notch_inner_edge = base_spacing / 2 - access_top_w / 2;
notch_clear      = notch_inner_edge - sensor_hole_edge;
echo(str("wall between notch and sensor hole: ", notch_clear, " mm"));
// A wall thinner than about two extrusions is not printed at all - it just
// vanishes and the two openings become one. At a 0.6 nozzle that is ~1.2 mm,
// so this threshold is a printing limit, not a strength one.
assert(notch_clear > 1.2,
       "wall between notch and sensor hole is too thin to print - narrow access_top_w, or reduce sensor_x");
assert(base_spacing - base_access_w > 10,
       "access notches have eaten the gusset between the screws");
assert(foot_w / 2 - base_spacing / 2 - base_access_w / 2 > 3,
       "access notches have broken out of the side of the foot");

echo(str("shelf screws ", base_spacing, " apart, ", base_standoff,
         " mm off the nose face - foot reaches ", foot_depth));
echo(str("nose slot ", top_height, " mm up, ", top_offset_x, " mm across"));
echo(str("screw material from the sensor face: ",
         plate_t + boss_h - back_relief_h, " mm, then a ", back_relief_d,
         " x ", back_relief_h, " relief to the back"));
echo(str("sensor face sits ", plate_t + boss_h, " mm off the nose face, ",
         "centre ", sensor_y, " mm up (body spans ",
         sensor_y - sensor_body_h / 2, " to ", sensor_y + sensor_body_h / 2, ")"));
