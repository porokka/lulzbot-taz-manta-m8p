# Bed flatness study

Raw Klipper `bed_mesh` output from 2026-10-22, taken to answer one question:
**is the 0.8 mm dome in the bed, or in the machine?**

A mesh cannot tell you on its own. It measures `bed shape − gantry shape`, and
those are not separable from a single scan. All three meshes below use an
identical region so they can be subtracted from each other.

```
region   X 50..240  Y 50..240   (190 x 190, 11 x 11)   cold, no heating
```

| file | plate | sheet | range |
| --- | --- | --- | --- |
| `rot_a.json` | normal orientation | off | 0.604 |
| `rot_b.json` | rotated 90° | off | 0.724 |
| `rot_c.json` | normal orientation | on | 0.715 |

## What came out

**The sheet — clean result.** `rot_c − rot_a` differ only by the sheet, same
orientation and temperature:

```
mean offset  +2.307 mm      the sheet's thickness
shape        0.411 range, 0.077 rms after removing that offset
```

Across the middle it lies flat to ±0.05 — the plate's form carries straight
through it. But the right-hand column twists from −0.22 at the back to +0.19 at
the front. That 0.41 mm is the sheet alone, not the plate and not the machine.

**Plate vs machine — partial.** Rotating the plate 90° and differencing shows
both are imperfect:

```
plate asymmetric component    0.105 rms
machine asymmetric component  0.145 rms
```

Neither is flat. But the split of the *symmetric* component is unresolved, and
a single 90° rotation cannot resolve it: with `A = M + P` and `B = M + rot(P)`,
the rotationally symmetric part of `P` is algebraically indistinguishable from
`M`. A bowed plate's dome is mostly symmetric — precisely the case this test is
blind to.

Separating that needs a measurement that doesn't pass through the printer: a
straight edge on the bare plate, off the machine. The vendor spec is
**±0.1 mm across 300 mm**.

## Why the probed region is only 190 mm

The probe sits at `x_offset: -52`, so it cannot reach past X 248. A rotation
test needs a square region centred on the plate, which caps it near 200 mm. The
same offset leaves ~53 mm of the bed's right-hand edge unprobed in normal use.
