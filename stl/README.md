# Printed parts

## `sfs_bracket` — BTT Smart Filament Sensor V2.0 mount

Mounts a BTT SFS V2.0 to the TAZ universal toolhead adapter
(`v2_aero_mount_for_taz6_no_switch`). Source is `sfs_bracket.scad`; every
dimension is parametric.

### Why it looks like this

The adapter's three usable fixings are on **perpendicular screw axes** — two
shelf screws run vertically, the nose slot runs horizontally — so a flat plate
physically cannot pick up both. Hence the L-foot and gusset.

Measured off the adapter STL rather than with calipers:

| fixing | measurement |
| --- | --- |
| shelf pair | 2 × M4, **48.00 mm** apart, **3.72 mm** off the nose face, axis vertical |
| nose slot | **4.40 × 10.93**, 6.14 deep, axis horizontal |
| sensor holes | **24.70 × 12.40** (BTT spec sheet) |

### Two traps in that adapter STL

- Its **stored facet normals are wrong** — 260 facets claim a normal
  perpendicular to X while all three vertices sit in one X plane. Any tool that
  trusts them will find holes that do not exist.
- It contains four geometrically perfect circles at **50 nanometres** depth.
  They are coincident-face seams, not fixings, and they read convincingly as
  tidy M5/M6 holes.

### Printing

Flat **back face down** — the face that beds against the adapter. Everything
grows upward off a solid first layer, nothing needs support, and the foot and
web share every layer up to `plate_t`, so their junction is solid rather than a
bond between layers. That junction is the only place the part sees real bending.

Hardware: **M3 × 20** for the sensor (threads into the sensor body, heads recess
into the Ø8 pockets on the back), M4 for the three adapter fixings.

### Fitted corrections

Numbers changed after offering the printed part up to the machine, not from the
drawing: sensor shifted 5 mm across (`sensor_x`), standoff set to 19 mm
(`boss_h`), driver access opened from a round bore to an L-shaped notch because
a bore wide enough for a screwdriver breaks out of the back of the foot.
