# lulzbot-taz-manta-m8p

Klipper configuration for a **LulzBot TAZ** running a **BigTreeTech Manta M8P V2.0**,
replacing the stock RAMBo.

Built and commissioned on a TAZ 5 with a universal toolhead adapter (also fits a TAZ 6),
a Meteor 175 hotend, an LGX Ace extruder and a CM4 host.

> **Full conversion guide:** wiring, commissioning order, diagnostics and the traps —
> see [`docs/`](docs/) or the online version linked in the repo description.

---

## Why this exists

Klipper ships **no generic config for the Manta M8P V2.0** — only `v1.0` and `v1.1`,
which are a **different MCU** (STM32G0B1 vs STM32H723) with a **completely different pin map**:

| | V1.1 | V2.0 |
| --- | --- | --- |
| MCU | STM32G0B1 | STM32H723 |
| Motor1 step/dir/enable | PE2 / PB4 / PC11 | PE6 / PE5 / PC14 |
| Hotend heater | PE3 | PA0 |
| Hotend thermistor | PA1 | PB0 |

A V1.x config on a V2.0 board fails in the worst way: Klipper starts, the pins exist,
and nothing works for reasons that look like wiring faults.

Confirm your board before anything else:

```
/printer/info  ->  "mcu": "stm32h723xx"
```

The authoritative V2.0 pin source is BigTreeTech's own repository, not Klipper's:
`bigtreetech/Manta-M8P` → `V2.0/Firmware/generic-bigtreetech-manta-m8p-V2_0.cfg`

---

## Pin map (M8P V2.0)

Motors are numbered **from 1**, fans **from 0**, on the same silkscreen.

### Steppers

| port | step | dir | enable | uart | DIAG / STOP |
| --- | --- | --- | --- | --- | --- |
| Motor1 | PE6 | PE5 | !PC14 | PC13 | PF4 |
| Motor2 | PE2 | PE1 | !PE4 | PE3 | PF3 |
| Motor3 | PB8 | PB7 | !PE0 | PB9 | PF2 |
| Motor4 | PB4 | PB3 | !PB6 | PB5 | PF1 |
| Motor5 | PG13 | PG12 | !PG15 | PG14 | PF0 |
| Motor6 | PG9 | PD7 | !PG11 | PG10 | PC15 |
| Motor7 | PD4 | PD3 | !PD6 | PD5 | — |
| Motor8 | PC7 | PC8 | !PD2 | PC6 | — |

A driver's **DIAG pin is the same net as its STOP pin**. Leave a DIAG jumper fitted and
the TMC's sensorless output fights your physical endstop. Pull them all unless you want
sensorless homing.

### Everything else

| function | pin |
| --- | --- |
| Endstops M1–M6 | PF4, PF3, PF2, PF1, PF0, PC15 |
| Hotend heater / thermistor | PA0 / PB0 |
| Bed heater / thermistor | PF5 / PB1 |
| BLTouch sensor / control | PD13 / PD12 |
| Proximity probe | PD8 |
| Fan0–Fan6 | PF7, PF9, PF6, PF8, PA4, PA6, PA2 |
| ADXL345 SPI | PG7 MISO, PG8 SCK, PG6 MOSI, + CS |

Endstop ports are **3-pin, `SIG / G / +5V`** — ground is the **middle** pin.
Fan5/Fan6 have tachometer inputs (PC2, PC1).

---

## TAZ-specific settings

**X homes to a negative position** — this is correct, not a bug:

```ini
[stepper_x]
position_endstop: -20.1
position_min: -20.1
position_max: 300.1
```

A stock TAZ parks the carriage left of the bed. Normalising it to 0 shifts the whole
coordinate system underneath your probe offsets and stored mesh.

**Endstops are inverted.** Marlin's `ENDSTOPPULLUPS` + `*_ENDSTOP_INVERTING true` means
triggered = LOW, so Klipper needs both pull-up and invert: `endstop_pin: ^!PF4`.
Without the `!`, `G28` stops instantly on every axis **while reporting success**.

**steps/mm → rotation_distance:** `full_steps * microsteps / steps_per_mm`.
From a TAZ's `M92` at 16 microsteps: X/Y 100 → **32**, Z 1600 → **2**, E 410 → **7.805**.
Re-measure E rather than converting it.

**Dual Z:** a stock TAZ runs both Z motors from **one driver through two connectors** —
on the RAMBo and the Manta alike. `z_tilt` requires them on separate drivers, which is a
change from stock on either board.

---

## Four traps worth knowing before you start

**1. More connectors than drivers.** Some boards wire two connectors to one driver for
dual-Z, so counting slot positions disagrees with the pin map. Map ports by driving one
pin set at a time and watching, never by counting.

**2. Endstop tests that pass while wrong.** Press switches in a *stated order* and check
the names come back in that order. Verifying each line goes `0 → 1 → 0` proves the
switches work and nothing about which port each is on.

**3. Fan voltage belongs to your print head.** A Meteor 175 brings a 5 V heat sink fan
and a 24 V blower; other hotends differ. Too much voltage kills a fan; too little leaves
it spinning and looking fine while causing heat creep. Read the label on the part.

**4. TMC open-load detection lies.** `ola`/`olb` are only valid **during motion**, and
are unreliable in StealthChop — two identically-empty ports can give opposite readings.

---

## Repo contents

```
config/
  printer.cfg        working Klipper config
  moonraker.conf
  crowsnest.conf     webcam (crowsnest + ustreamer)
  mainsail.cfg
docs/                full conversion guide
```

---

## Status

Commissioned and printing. Extruder calibration (`rotation_distance` for the LGX Ace)
is still being measured — the value in `printer.cfg` is converted from Marlin's `M92 E410`
and has not yet been verified with a 100 mm extrude test.

## Licence

Configuration files: use them however you like. The pin data comes from BigTreeTech's
published V2.0 config; the TAZ values from LulzBot's Marlin source.
