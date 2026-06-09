# Jetson ARK + QGroundControl (QGC) PX4 Configuration Guide

This document describes the **tested and working configuration** for running **PX4 on Jetson ARK** using **QGroundControl (QGC)**.

⚠️ **Strong Recommendation**
- Use **QGC < 5.0.4**
- Newer QGC versions are missing critical Actuator / Rotor UI features

📌 **Before You Start**
- Read this document fully before changing any configuration
- Prefer **QGC UI** over manual parameter edits
- If parameters must be changed manually, modify **all related parameters at once**, then reboot only once

---

## General

---

## RC Calibration

- Follow **QGC → Vehicle Setup → Radio** UI instructions
- Ask your drone pilot for **arm / trigger switch preference**
- Switch mapping depends on RC brand  
  - Example: *Reza’s preference with Futaba controller*
 
    - SG -> ARM
    - SD -> kill
    - SE -> flight mode
    - SA -> payload release

---

## Airframe Configuration
⚠️ **Issue remains**
- **M4 requires H-type motor geometry**
- PX4 **built-in H airframe fails pre-arm system health check** on Jetson ARK  
  (likely due to battery / power assumptions)

### Alternative Solution (Tested & Working)

1. Select airframe:
Generic Quadrotor (X configuration)


2. Configure motors and ESCs to be **equivalent to H geometry**

📌 **Note**
- The *only* difference between X and H is:
- Motor numbering
- Motor spin direction (CW / CCW)

---

## Sensor Calibration

### Board Orientation

Set board mounting using:
```bash
SENS_BOARD_ROT
```

Current setting:
- **Roll 180°, Yaw 270°**

This must match the physical mounting of the flight controller.

---

### Compass

Disable magnetometer， while transforming, the Dynamixel current will affect calibration:
```bash
SYS_HAS_MAG = 0
```

---

### Calibration Orientation (QGC UI)

- Set **Orientation** in QGC to match board mounting:
  - Roll 180°, Yaw 270°
- Use QGC UI to complete all sensor calibration steps

📌 Calibration orientation must match `SENS_BOARD_ROT` to ensure correct calibration behavior.

---

## ESC Configuration

---

### 1. Program ESC

- Configure ESC firmware to **DShot mode**,(

---

### 2. Motor / Actuator Configuration

#### Using **Old QGC (< 5.0.4)** (Recommended)

- QGC → **Actuators**
- Assign:
  - Motor 1–4
  - Select DShot protocol via UI

---

#### Using **New QGC**

Configure via parameters:

```bash
PWM_AUX_TIM0 = DShot150
PWM_AUX_FUNC1 = Motor1
PWM_AUX_FUNC2 = Motor2
PWM_AUX_FUNC3 = Motor3
PWM_AUX_FUNC4 = Motor4
```



---

### 3. Motor / Rotor Mapping

Verify motor number → physical position mapping.

---

### 4. Rotor Spin Direction (CW / CCW)

#### H-Equivalent Geometry
```bash
 {3}     {1}
    \   /
      O
    /   \
 {2}     {4}

Motors 1,2 : CCW
Motors 3,4 : CW
```

#### Old QGC (<5.0.4)

- Set rotor direction directly in **Actuators UI**

#### New QGC

Rotor spin direction is defined by:

CA_ROTOR

| Value | Meaning |
|-----|--------|
| Negative | CW |
| Positive | CCW |

⚠️ Multiple CA_ROTOR parameters exist  
Use **old QGC** for reliable configuration

---

### 5. Cancel Unintended PWM Output Reversal

After modifying geometry or rotor direction, PX4 may automatically reverse outputs.

Ensure all reversals are disabled:
```bash
PWM_AUX_REV1 = 0
PWM_AUX_REV2 = 0
PWM_AUX_REV3 = 0
PWM_AUX_REV4 = 0
```



📌 Motor command must satisfy:  
**Command increase → Motor speed increase**

---

## Parameter Quick Reference (Cheat Sheet)

### Orientation & Sensors

| Parameter | Purpose | Value |
|--------|--------|------|
| SENS_BOARD_ROT | Board mounting orientation | Roll 180, Yaw 270 |
| SYS_HAS_MAG | Enable compass | 0 |

---

### ESC & Motors

| Parameter | Purpose | Example |
|--------|--------|--------|
| MOT_PWM_TYPE | Output protocol | DShot150 |
| PWM_AUX_TIM0 | Timer protocol | DShot150 |
| PWM_AUX_FUNCx | Motor assignment | Motor1–4 |
| PWM_AUX_REVx | Output reversal | 0 |

---

### Rotor Direction (Control Allocation)

| Parameter | Meaning |
|--------|--------|
| CA_ROTORx_KM < 0 | CW |
| CA_ROTORx_KM > 0 | CCW |

---

## Validation Checklist (Before Flight)

- QGC attitude display correct (roll / pitch / yaw)
- Motor test:
  - Correct motor ↔ position
  - Correct spin direction
- Vehicle arms at **low throttle**
- No unintended PWM reversal
- DShot communication confirmed

---

## Summary

- Use **Generic Quad X** + **H-equivalent geometry**
- Prefer **QGC < 5.0.4**
- Define rotor direction via `CA_ROTORx_KM`
- Avoid relying on PWM reversal
- Always verify with motor test before flight


