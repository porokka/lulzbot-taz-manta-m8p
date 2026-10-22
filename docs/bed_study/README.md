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

---

## 2026-10-22 (later) — the plate does not reseat repeatably

After the rotation test the plate was returned to its normal orientation and the
sheet refitted. `mesh60` was then re-probed under identical conditions — bed 60,
soaked, homed and levelled hot, same 15×15 region:

```
                   range    min      max      centre
before (21 Oct)    0.674   -0.156   +0.518   +0.448
after  (22 Oct)    0.978   -0.377   +0.601   +0.528
```

**0.3 mm worse, purely from taking the plate off and putting it back.** That is
larger than the plate's entire published tolerance band of ±0.1 mm.

### The change is a tilt, not more dome

```
        X10    X44    X77    X111   X144   X178   X211   X245
  Y 275  -0.38  -0.07  +0.08  +0.18  +0.22  +0.18  +0.09  -0.24
  Y 129  -0.08  +0.22  +0.43  +0.55  +0.57  +0.55  +0.44  +0.08
  Y  20  +0.09  +0.32  +0.48  +0.57  +0.58  +0.53  +0.44  +0.18
```

The back dropped ~0.39 mm relative to the front. X10 and X245 read the same
(+0.08) at mid-bed, so there is **zero X tilt** — it is purely front-to-back.

That matters because **the machine cannot correct it**: both Z motors sit at
`y=145`, so `Z_TILT_ADJUST` levels left-to-right only. A Y tilt has nothing
acting on it but mesh compensation.

### How much to lift

Applying the correction as a linear ramp, front to back:

```
lift   min      max     range
0.00   -0.377  +0.601   0.978
0.30   -0.077  +0.740   0.817
0.40   +0.017  +0.804   0.787   <- optimum
0.50   +0.024  +0.868   0.844
```

At 0.40 mm the front and back rows coincide and the tilt is gone. Per turn:
M3 ≈ 4/5, M4 ≈ 4/7, M5 ≈ 1/2 — **both back corners equally**.

### What tilting cannot fix

The best reachable by levelling is 0.787, not the previous 0.674, because the
**X bow worsened too** — 0.48 across the centre before, 0.65 after. Reseating
changed both the tilt and the bow.

### Consequences

- **Re-mesh after any handling of the bed.** This is not optional on this
  machine; a 0.3 mm shift is most of a first layer.
- For the vendor conversation, this is stronger evidence than any single mesh:
  it is a *difference* measured on one machine with nothing else changed, so
  the gantry cancels out. A plate that measures 0.3 mm differently depending on
  how it is put down is its own complaint, independent of the ±0.1 mm claim.
