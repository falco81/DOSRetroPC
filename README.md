# DOS Retro PC — System Overview

**Machine:** Rhino 15 Socket 7
**CPU:** Pentium MMX
**RAM:** 256 MB (2x 128 MB DIMM)
**OS:** MS-DOS 6.22

---

## Hardware

| Component | Model | Interface |
|---|---|---|
| CPU | Pentium MMX | Socket 7 |
| RAM | 256 MB (2x 128 MB DIMM) | — |
| Video | ATI MACH64 (Rage Pro Turbo) | PCI |
| 3D Accelerator | 3dfx Voodoo2 | PCI |
| Sound Card | Creative Sound Blaster AWE32 CT3900 | ISA |
| GUS / MIDI Card | PicoGUS v2.0 | ISA |
| SF2 / GM Synth | Serdaco WP32 McCake (mt32-pi, CM4) | Waveblaster header |
| McCake Panel | Serdaco MT32Pi Drive Bay Panel 5.25 + OLED | 5.25" bay |
| CD-ROM | Samsung (SSCDROM.SYS) | IDE |
| Mouse | Serial mouse, auto-detected by CTMOUSE | COM2 |
| BIOS | Award Modular BIOS v4.51PG (09/18/97) | — |
| MIDI module 1 | Roland MT-32 | MIDI chain (first) |
| MIDI module 2 | Roland SC-55 | MIDI chain (THRU from MT-32) |
| Mixer | Behringer XENYX QX1222USB | USB |
| Headphones | Audio-Technica ATH-M50x | QX1222USB Phones jack |
| Audio Interface | Focusrite Scarlett 16i16 4th Gen | USB (modern PC) |

---

## BIOS Settings

### Integrated Peripherals

| Setting | Value | Reason |
|---|---|---|
| Serial Port 1 (COM1) | Enabled, 3F8h | unused but harmless |
| Serial Port 2 (COM2) | Enabled, 2F8h | serial mouse |
| Parallel Port (LPT1) | **Disabled** | frees IRQ 7 for PicoGUS |
| IDE Primary | Enabled | hard drives |
| IDE Secondary | Enabled | CD-ROM |
| Floppy Controller | Enabled | floppy drive |

### PnP/PCI Configuration

| IRQ | Setting | Reason |
|---|---|---|
| IRQ 3 | **Legacy ISA** | COM2 — serial mouse |
| IRQ 4 | Legacy ISA | COM1 |
| IRQ 5 | **Legacy ISA** | AWE32 CT3900 |
| IRQ 7 | **Legacy ISA** | PicoGUS v2.0 |
| IRQ 10 | PnP | free |
| IRQ 11 | PnP | free |
| IRQ 12 | PnP | free |
| IRQ 14 | Legacy ISA | Primary IDE |
| IRQ 15 | Legacy ISA | Secondary IDE |

| DMA | Setting | Reason |
|---|---|---|
| DMA 1 | **Legacy ISA** | AWE32 CT3900 (8-bit) |
| DMA 3 | **Legacy ISA** | PicoGUS v2.0 (8-bit) |
| DMA 5 | **Legacy ISA** | AWE32 CT3900 (16-bit) |
| DMA 6 | PnP | free |
| DMA 7 | PnP | free |

> IRQ 6 and DMA 2 are hardwired to floppy — do not appear in PnP/PCI Configuration.

---

## IRQ Map

| IRQ | Device | Notes |
|---|---|---|
| 0 | System Timer | reserved |
| 1 | Keyboard | reserved |
| 2 | Cascade (slave PIC) | reserved — cannot be used |
| 3 | COM2 — Serial Mouse | |
| 4 | COM1 | unused |
| 5 | AWE32 CT3900 | BLASTER=I5 |
| 6 | Floppy Drive | hardwired |
| **7** | **PicoGUS v2.0** | LPT1 disabled in BIOS |
| 8 | RTC Clock | reserved |
| 9 | Redirected IRQ2 | reserved |
| 10 | FREE | available |
| 11 | FREE | available |
| 12 | FREE | available |
| 13 | Math Coprocessor | internal |
| 14 | Primary IDE | |
| 15 | Secondary IDE | |

---

## DMA Map

| DMA | Device | Width | Notes |
|---|---|---|---|
| 0 | — | 8-bit | free |
| 1 | AWE32 CT3900 | 8-bit | BLASTER=D1 |
| 2 | Floppy Drive | 8-bit | hardwired |
| **3** | **PicoGUS v2.0** | **8-bit** | both jumpers marked "3" closed |
| 4 | Cascade | — | reserved |
| 5 | AWE32 CT3900 | 16-bit | BLASTER=H5 |
| 6 | FREE | 16-bit | available |
| 7 | FREE | 16-bit | available |

---

## AWE64 CT4380 → AWE32 CT3900 Upgrade Guide

**System:** Rhino 15 / Pentium MMX / MS-DOS 6.22
**Card being replaced:** Creative AWE64 CT4380
**Card being installed:** Creative AWE32 CT3900

---

### What you are replacing and why

| Feature | AWE64 CT4380 | AWE32 CT3900 |
|---|---|---|
| OPL3 FM | CQM emulation (fake) | **Real OPL3** (CT1747 w/ Yamaha license) |
| CSP/ASP chip | Not supported | CT1748A included |
| Waveblaster header | Not present | Present |
| RAM expansion | Proprietary only | Standard 30-pin SIMM slots |
| PnP | Yes (needs CTCM) | **Semi-PnP — simpler for DOS** |
| Hanging notes bug | Not present | Not present (CT1747) |
| EMU8000 synth | Yes, 512KB | Yes, 512KB |
| Polyphony | 64 voices | 32 voices |

The real OPL3 chip is the main reason for the upgrade — AdLib/FM games sound
exactly as intended, not through CQM emulation which has a harsher, more
metallic character.

### What this adds to the system

| Before CT3900 | After CT3900 |
|---|---|
| OPL3 FM via CQM emulation — metallic, incorrect timbre | **Real Yamaha OPL3** — authentic AdLib/FM sound |
| No waveblaster header | PicoGUS X16GS can be connected later |
| PnP — requires CTCM.EXE at boot | Semi-PnP — UNISOUND handles everything |
| Proprietary RAM expansion | Standard 30-pin SIMM slots — up to 28.5 MB |

---

### Before you start

- Back up CONFIG.SYS and AUTOEXEC.BAT to a floppy
- Note current AWE64 jumper settings for reference
- Prepare a grounded workspace (antistatic mat or wrist strap)
- Have a Phillips screwdriver ready
- No software downloads required — UNISOUND handles CT3900 automatically

---

### Step 1 — Set CT3900 jumpers

Set all jumpers before inserting the card into the PC.

**Audio I/O Address:**
```
JP17=Closed, JP18=Closed  →  port 220h
```

**MPU-401:**
```
JP15=Closed  →  MPU-401 enabled
JP16=Closed  →  port 330h
```

**Joystick / Gameport:**
```
JP14=Closed  →  enabled  (gameport carries MIDI OUT to MT-32/SC-55 chain)
```

**IDE port — must be DISABLED (conflicts with motherboard IDE):**
```
JP2=Closed, JP3=Closed  →  IDE Disabled
```

**IDE IRQ — irrelevant when IDE is disabled, leave at default:**
```
JP6=Closed  →  IRQ 11  (harmless when IDE is disabled)
```

**CSP/ASP chip (CT1748A):**
```
If CT1748A chip is present:  APSD=Open,   IFSD=Open   →  Enabled
If CT1748A chip is absent:   APSD=Closed, IFSD=Closed →  Disabled
```

**DRAM — SIMM slots:**
```
Without SIMMs:  JP2 Pins 2&3 closed  →  Memory upgrade disabled
With SIMMs:     JP2 Pins 1&2 closed  →  Memory upgrade enabled
```

### CT3900 — Semi-PnP Configuration

CT3900 is a **semi-PnP** card — I/O address and MPU-401 are set by jumpers,
IRQ and DMA are set by software from the BLASTER environment variable:

| Parameter | Method |
|---|---|
| I/O address (220/240/260/280h) | **Jumper** (IOS0, IOS1) |
| MPU-401 address (300/330h) | **Jumper** (MSEL) |
| **IRQ** | **Software** — UNISOUND reads BLASTER at boot |
| **Low DMA (8-bit)** | **Software** — UNISOUND reads BLASTER at boot |
| **High DMA (16-bit)** | **Software** — UNISOUND reads BLASTER at boot |

Available software-configurable values:
```
IRQ:      2, 5, 7, 10
Low DMA:  0, 1, 3
High DMA: 5, 6, 7
```

If a conflict occurs later, update BLASTER in AUTOEXEC.BAT — UNISOUND
reprograms the card on next boot. No jumper changes needed.

---

### Step 2 — Install SIMMs

CT3900 has two 30-pin SIMM slots. Both slots must always be populated
simultaneously — they form one bank. Always use identical modules in both slots.

**Required spec:** 30-pin SIMM, FPM (Fast Page Mode), 80ns or faster, 5V

**SoundFont format in DOS:** use .SBK (EMU8000 native). Modern .SF2 requires
conversion. Maximum usable SoundFont size: 28 MB (EMU8000 bus limit,
regardless of how much RAM is installed).

#### Phase 1 — Initial bring-up (now, modules already owned)

**Modules:** 2× Samsung KM41C1000CJ-6 (1MB, 60ns, 30-pin FPM)
**Result:** 2.5 MB total — card functional, AWEUTIL /S works

1. Power off PC, unplug power cable
2. Insert 2× Samsung KM41C1000CJ-6 into both SIMM slots
   (both slots must be populated — one slot alone will not work)
3. Set jumper JP2 **pins 1&2 closed** — memory upgrade enabled
4. Proceed to Step 3 (physical card installation)

**Unlocks:** basic AWE32 hardware init, EMU8000 responds to AWEUTIL /S,
reverb and chorus effects via CT1747 chip.
AWEUTIL /EM:* emulation modes require more RAM — available in Phase 2.

#### Phase 2 — eBay modules arriving

**Modules:** 2× 4MB 30-pin FPM (60ns or 70ns, parity or non-parity both OK)
**Result:** 8.5 MB total
**When:** when eBay order arrives

1. Power off PC, unplug power cable
2. Remove both Phase 1 SIMMs simultaneously
3. Insert 2× 4MB modules into both slots
4. Jumper JP2 pins 1&2 stays closed — no change needed
5. Boot and verify with `MEM /C` — Extended memory should show ~8 MB

**Unlocks:**
- `AWEUTIL /EM:GM` — General MIDI emulation (Synthgm.sbk)
- `AWEUTIL /EM:GS` — Roland GS emulation (Synthgs.sbk)
- `AWEUTIL /EM:MT32` — MT-32 software emulation (Synthmt.sbk)
- Larger .SBK soundfonts loadable via `AWEUTIL /SF:`

> Note: AWEUTIL /EM:* still conflicts with SoftMPU — use profile NOSOFTMPU.
> X16GS (PicoGUS) remains the better option for GM/GS once PicoGUS arrives.

#### Phase 3 — USA modules arriving (maximum)

**Modules:** 2× 16MB 30-pin FPM, 70ns, Parity
**Result:** 28.5 MB total
**When:** when USA order arrives (several months)

1. Power off PC, unplug power cable
2. Remove both Phase 2 SIMMs simultaneously
3. Insert 2× 16MB modules into both slots
4. Jumper JP2 pins 1&2 stays closed — no change needed
5. Boot and verify with `MEM /C` — Extended memory should show ~28 MB

**Unlocks:** maximum SoundFont capacity — up to 28 MB .SBK files.
No other behavioral difference vs Phase 2 for typical gaming.

#### SIMM rules summary

| Rule | Detail |
|---|---|
| Both slots always | One slot alone will not work — populate both simultaneously |
| Identical modules | Both SIMMs in a pair must be identical — same chip, same speed |
| JP2 pins 1&2 closed | Required for all three phases — do not change between phases |
| JP2 pins 2&3 closed | Factory default without SIMMs — only if removing all SIMMs |
| Speed | 80ns or faster (60ns or 70ns preferred) |
| Type | 30-pin FPM — not EDO, not 72-pin |

---

### Step 3 — Physical installation

1. Power off PC, unplug power cable
2. Remove AWE64 CT4380 from ISA slot
3. Insert CT3900 into the same ISA slot
   (SIMMs already installed in Step 2 — check clearance to adjacent slot)
4. Secure bracket screw
5. Connect MT-32/SC-55 MIDI chain to CT3900 gameport
   (same cable as before — gameport position is identical)
6. Power on

---

### Step 4 — First boot verification

No driver changes are needed. UNISOUND initializes CT3900 automatically
using the existing BLASTER variable.

At the DOS prompt after boot:

```bat
REM 1. Confirm BLASTER variable is set correctly:
SET BLASTER

REM Expected output:
REM   BLASTER=A220 I5 D1 H5 P330 E620 T6

REM 2. Check memory — UNISOUND should show no footprint:
MEM /C | MORE

REM 3. Quick OPL3 test — run any AdLib/FM game and listen
REM    Real OPL3 sounds warmer and more accurate than CQM

REM 4. Quick MIDI test — run a MT-32 game, check music plays
REM    through MT-32 via gameport on port 330h
```

If boot shows `DIGN9003` error or UNISOUND fails:
- Verify BLASTER variable is set in AUTOEXEC.BAT
- Verify `/E:1024` is set on the SHELL= line in CONFIG.SYS
- Verify jumpers JP17+JP18 are closed (port 220h must match A220 in BLASTER)

---

### Software changes after swap

**None required.** The BLASTER variable and all drivers remain identical:

```bat
SET BLASTER=A220 I5 D1 H5 P330 E620 T6
```

UNISOUND.COM replaces CTCM.EXE — CT3900 is initialized automatically at boot.
IRQ 5, DMA 1/5 are the card defaults and match this system perfectly.

---

### Post-Installation Checklist

#### Phase 1 — Initial installation (CT3900 + 2× 1MB Samsung)

- [ ] Jumper JP17+JP18 closed — I/O port 220h
- [ ] Jumper JP15+JP16 closed — MPU-401 enabled on 330h
- [ ] Jumper JP14 closed — gameport/joystick enabled
- [ ] Jumpers JP2+JP3 closed — IDE port disabled
- [ ] 2× Samsung KM41C1000CJ-6 installed — both slots, identical modules
- [ ] Jumper JP2 pins 1&2 closed — SIMM enabled
- [ ] CT3900 in ISA slot, bracket screw secured
- [ ] MT-32/SC-55 MIDI cable connected to CT3900 gameport
- [ ] First boot: no error messages, UNISOUND output visible
- [ ] `SET BLASTER` shows `A220 I5 D1 H5 P330 E620 T6`
- [ ] `MEM /C` shows Extended ~2 MB
- [ ] AdLib/FM game plays with correct OPL3 sound (warmer than AWE64 CQM)
- [ ] MT-32 game plays music correctly on port 330h

#### Phase 2 — SIMM swap to 2× 4MB (when eBay modules arrive)

- [ ] Power off, unplug power cable
- [ ] Remove both 1MB SIMMs simultaneously
- [ ] Insert 2× 4MB 30-pin FPM modules — both slots, identical modules
- [ ] JP2 pins 1&2 stays closed — no jumper change needed
- [ ] Boot and verify: `MEM /C` shows Extended ~8 MB
- [ ] Test: `LH C:\DRIVERS\SB16\AWEUTIL.COM /EM:GS` loads without error
  (profile NOSOFTMPU required — SoftMPU must not be active)
- [ ] Unload: `C:\DRIVERS\SB16\AWEUTIL.COM /U`

#### Phase 3 — SIMM swap to 2× 16MB (when USA modules arrive)

- [ ] Power off, unplug power cable
- [ ] Remove both 4MB SIMMs simultaneously
- [ ] Insert 2× 16MB 30-pin FPM 70ns Parity modules — both slots, identical
- [ ] JP2 pins 1&2 stays closed — no jumper change needed
- [ ] Boot and verify: `MEM /C` shows Extended ~28 MB
- [ ] Test: load a large .SBK soundfont via `AWEUTIL /SF:fontname.sbk`

---

## PicoGUS v2.0 + WP32 McCake — Installation Guide

**System:** Rhino 15 / Pentium MMX / AWE32 CT3900 already installed / MS-DOS 6.22
**Card being installed:** PicoGUS v2.0 + Serdaco WP32 McCake (mt32-pi, CM4)
**Panel:** Serdaco MT32Pi Drive Bay Panel 5.25" with OLED display and buttons
**Target slot:** free ISA slot (AWE32 in adjacent slot)

---

### What you are installing

**PicoGUS v2.0** is an ISA card based on a Raspberry Pi Pico microcontroller
that emulates a Gravis UltraSound (GUS) and provides a second MPU-401 MIDI interface independent of the AWE32.

**WP32 McCake** is a waveblaster-compatible card with a Raspberry Pi Compute Module 4
running mt32-pi software. Plays SF2 soundfonts via the FluidSynth engine.
Plugs directly into the PicoGUS waveblaster header — no external cable or power
required (powered from the header or optionally from a floppy connector).

McCake audio routes internally through PicoGUS and comes out via the PicoGUS line out —
jeden stereo kabel do QX1222USB CH 9+10.

### What this adds to the system

| Before | After |
|---|---|
| GM games require SC-55 or AWEUTIL /EM (conflicts with SoftMPU) | McCake on port 300h — GM via SF2, no conflict |
| GUS games (Doom, Duke3D) use SB music only | Native Gravis UltraSound music, superior quality |
| AWEUTIL /EM:GS wastes ~26 KB UMB | McCake uses 0 KB extra memory |
| AWEUTIL /EM:GS does not work with DOS extenders | McCake works with all games regardless of memory model |

---

### Why these resource values

| Resource | Value | Reason |
|---|---|---|
| IRQ 7 | PicoGUS | LPT1 disabled in BIOS — frees IRQ 7 |
| DMA 3 | PicoGUS | DMA 1 taken by AWE32 8-bit, DMA 3 is free |
| Port 240h | GUS base | 220h taken by AWE32 SB16 |
| Port 300h | MPU-401 | 330h taken by AWE32 MPU-401 (MT-32/SC-55 chain) |

---

### Before you start

- **AWE32 CT3900 must already be installed and working** — SoftMPU active,
  UNISOUND running, games working. PicoGUS adds on top of AWE32, it does not
  replace it.
- **LPT1 must be disabled in BIOS** before inserting PicoGUS — if you have
  not done this yet, do it before powering on with the card installed.
  Without this, IRQ 7 is claimed by LPT1 and PicoGUS will not initialize.
- **Prepare software in advance** — download the files below to the DOS PC
  via FTP from your modern PC before installing the card. You will need them
  immediately after first boot.
- Grounded workspace (antistatic mat or wrist strap).
- Phillips screwdriver.

### Software to download before installing

| File | Source | Destination on DOS PC |
|---|---|---|
| `ultrasnd.zip` — GUS v4.11 patch set | https://picog.us/ultrasnd.zip | `C:\DRIVERS\PICOGUS\` |
| `PGUSINIT.EXE` — latest release | https://github.com/polpo/picogus/releases | `C:\DRIVERS\PICOGUS\` |
| `DOSMID.EXE` + `DOSMID.CFG` | already in `C:\DRIVERS\PICOGUS\` | already present |
| `Slot1.mid` … `Slot7.mid`, `Next.mid`, `Previous.mid` | already in `C:\DRIVERS\PICOGUS\` | already present |

Transfer via FTP or copy to a floppy / CD-R before starting.

---

### Step 1 — BIOS settings

Enter BIOS setup at boot (DEL key on this system).

#### Integrated Peripherals

```
Parallel Port (LPT1) :  Disabled    ← CRITICAL
```

Without this change IRQ 7 is still used by LPT1 and PGUSINIT will fail.

#### PnP/PCI Configuration

Verify these are already set (they should be from AWE32 setup):

```
IRQ 7  :  Legacy ISA   ← must be Legacy ISA, not PnP
DMA 3  :  Legacy ISA   ← must be Legacy ISA, not PnP
```

Save and exit BIOS. Power off completely before proceeding.

---

### Step 2 — Install DreamBlaster X16GS onto PicoGUS

Do this before inserting PicoGUS into the PC.

The X16GS plugs into the **waveblaster header** on PicoGUS — a double-row
pin header typically labeled "WAVE" or "DB" near the top edge of the card.

1. Locate pin 1 on the PicoGUS waveblaster header (marked with a dot,
   triangle, or "1" printed on PCB)
2. Orient X16GS so its pin 1 matches the header pin 1
3. Press firmly and evenly — all pins must seat fully
4. The X16GS should sit flat and parallel to the PicoGUS PCB

The X16GS draws power directly from the header — no separate power cable.

---

### Step 3 — Set PicoGUS jumpers

PicoGUS v2.0 has two jumper banks on the card edge.

#### IRQ jumper bank

Positions available: 2, 3, 4, 5, 7

```
Place single jumper on position:  7
```

#### DMA jumper bank

Positions available: 1 and 3. DMA requires **two jumpers**, both must be set.

```
Close BOTH jumpers on position:  3
```

#### IO port

No jumper needed — set via PGUSINIT.EXE at boot.

---

### Step 4 — Physical installation

1. PC is powered off and unplugged
2. Choose a free ISA slot — not the one occupied by AWE32
3. Insert PicoGUS firmly and evenly into the ISA slot
   (X16GS is already mounted, it sits above the card — check clearance
   to adjacent slot bracket before pressing down)
4. Secure the bracket screw
5. Connect PicoGUS line out → QX1222USB **CH 9+10** (stereo 3.5mm or RCA,
   depending on PicoGUS output connector)
6. Do not power on yet

---

### Step 5 — Verify directory structure

Before booting, confirm these files exist on the DOS drive:

```
C:\DRIVERS\PICOGUS\
  PGUSINIT.EXE          ← from github.com/polpo/picogus/releases
  DOSMID.EXE
  DOSMID.CFG
  Slot1.mid
  Slot2.mid
  Slot3.mid
  Slot4.mid
  Slot5.mid
  Next.mid
  Previous.mid
  MIDI\                 ← extracted from ultrasnd.zip
    MIDI.CFG
    ACPIANO.PAT
    ... (all .PAT patch files)
```

> ULTRADIR must point to `C:\DRIVERS\PICOGUS` root — NOT to the MIDI
> subfolder. PGUSINIT reads MIDI.CFG from `MIDI\` automatically when
> ULTRADIR is set to the parent directory.

---

### Step 6 — First boot test

Power on. The PicoGUS lines in AUTOEXEC.BAT are still commented out — that
is intentional. Test manually first.

At the DOS prompt:

```bat
REM 1. Set environment variables temporarily for this session only:
SET ULTRASND=240,3,3,7,7
SET ULTRADIR=C:\DRIVERS\PICOGUS

REM 2. Initialize PicoGUS:
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 300 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1

REM Expected output:
REM   PicoGUS v2.x -- GUS mode
REM   GUS port: 240h  IRQ: 7  DMA: 3
REM   MPU-401: 300h
REM   Wavetable volume: 95

REM 3. Check for conflicts (should show no overlap with AWE32):
MEM /C | MORE

REM 4. Quick X16GS test via DOSMID:
C:\DRIVERS\PICOGUS\DOSMID.EXE /mpu=300 /preset=GS C:\DRIVERS\PICOGUS\Slot1.mid

REM 5. Quick GUS test — run Doom and check music in setup:
REM    SETUP.EXE -> Music: Gravis UltraSound (should auto-detect via ULTRASND)
```

**If PGUSINIT fails or hangs:**

Check in order:

1. Is IRQ 7 set to Legacy ISA in BIOS PnP/PCI Configuration?
2. Is LPT1 disabled in BIOS Integrated Peripherals?
3. Is DMA 3 set to Legacy ISA in BIOS?
4. Are both DMA jumpers closed on position 3 (not position 1)?
5. Is the IRQ jumper on position 7 (not another position)?
6. Is the card fully seated in the ISA slot (no partial insertion)?
7. Does any other device use IRQ 7 or DMA 3? Run `MSD.EXE` to check.

---

### Step 7 — AUTOEXEC.BAT — state after installation

PicoGUS is installed. These lines are active in AUTOEXEC.BAT:

```bat
SET ULTRASND=240,3,3,7,7
SET ULTRADIR=C:\DRIVERS\PICOGUS
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 300 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
```

ULTRASND and ULTRADIR are in the [COMMON] section — loaded in every profile.
PGUSINIT is in each profile separately (NOSOFTMPU, NOSOFTEMU, NORMAL, EMS).

Reboot and verify that the PGUSINIT output is visible during the boot sequence.

---

### Step 8 — Save settings to PicoGUS flash (optional)

After confirming everything works across a full reboot:

```bat
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 300 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1 /save
```

This writes the settings to the Pico's flash memory so they survive power
loss. After `/save` is used once, PGUSINIT at boot still reinitializes the
card state — `/save` just makes the card remember its mode if PGUSINIT is
not run.

> Use `/save` only once during initial setup. Do not run it repeatedly —
> flash has a finite write cycle count.

---

### PGUSINIT.EXE — Full Parameter Reference

```
PGUSINIT.EXE /mode gus /mpuport 300 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1 [/save]

/mode gus      GUS emulation mode — use this for all DOS gaming
               Other modes exist (sb, adlib, mpu, usb) but are not
               needed here as AWE32 handles SB16/OPL3 on port 220h/330h

/mpuport 300   MPU-401 on port 300h
               MUST differ from AWE32 MPU-401 on 330h
               X16GS bank switching and MIDI output use this port

/gusvol 85     GUS audio output volume (0–100)

/wtvol 85      DreamBlaster X16GS wavetable header volume (0–100)
               Hlasitost upravuj na QX1222USB CH 9+10, ne zde

/mpudelay 1    Zpomalit odeslani SysEx zprav
               Prevents SysEx buffer overflow on Roland-compatible synthesizers
               Pouzivat vzdy s X16GS

/save          Save settings to PicoGUS flash — use only once at setup

PGUSINIT /?    Help for current mode
PGUSINIT /??   Help for all modes
```

---

### PicoGUS Emulation Modes

| Mode | GUS | SB | OPL2 | MPU-401 | Notes |
|---|---|---|---|---|---|
| **gus** | Yes | No | No | Yes | **Use this** — AWE32 handles SB/OPL |
| sb | No | Yes | Yes | Yes | SB replacement — not needed here |
| adlib | No | No | Yes | Yes | AdLib replacement — not needed here |
| mpu | No | No | No | Yes (IRQ) | MIDI-only mode |
| usb | No | No | No | Yes | USB-MIDI bridge |

CD-ROM emulation in `sb` mode is not used — physical Samsung drive is used.

---

### WP32 McCake — SF2 Soundfonty

McCake runs mt32-pi (FluidSynth engine). SF2 files are copied to the micro SD card
into the `/soundfonts/` folder. Switching soundfonts is done via buttons on the drive bay panel
or through the mt32-pi command line utility.

#### Recommended SF2 soundfonts for DOS gaming

| Soundfont | Size | Style | Download | Notes |
|---|---|---|---|---|
| **GeneralUser GS** | ~30 MB | GM/GS | [schristiancollins.com](http://schristiancollins.com/generaluser.php) | **Default** — included with mt32-pi, good all-rounder |
| **Patch93 Roland SC-55 v1.9** | ~130 MB | SC-55 | [archive.org](https://archive.org/details/500-soundfonts-full-gm-sets) | Best SC-55 approximation for DOS games |
| **Timbres of Heaven** | ~300 MB | GM/GS/XG | [midkar.com](http://midkar.com/soundfonts/) | High quality, GM/GS/XG support |
| **Arachno SoundFont** | ~150 MB | GM | [arachnosoft.com](http://www.arachnosoft.com/main/soundfont.php) | Distinctive, modern sound |
| **SGM-V2.01** | ~260 MB | GM/GS | [archive.org](https://archive.org/details/SGM-V2.01) | Good all-rounder, balanced sound |
| **8mbgm_enhanced18** | ~8 MB | GM | [archive.org](https://archive.org/download/soundfonts_201910/8mbgm_enhanced18.sf2) | Small, retro style, fast loading |

> ⚠️ CM4 with 1 GB RAM can handle soundfonts up to ~500 MB. For soundfonts over 1 GB
> a CM4 with 2 GB or more RAM is required.

#### Recommended combination for your setup

Since you have a physical SC-55 and MT-32, McCake is only used for games where you
do not want to switch external modules:

- **Slot 0 (default):** GeneralUser GS — fast boot, good for most GM games
- **Slot 1:** Patch93 SC-55 v1.9 — best SC-55 approximation, for GS games
- **Slot 2:** Timbres of Heaven — backup option, XG support

#### SD card file layout

```
/soundfonts/
    GeneralUser_GS.sf2       ← slot 0 (default)
    SC-55_Patch93_v1.9.sf2   ← slot 1
    Timbres_of_Heaven.sf2    ← slot 2
/roms/                        ← MT-32 ROM files (for MT-32 mode — not needed,
                                 you have a physical MT-32)
mt32-pi.cfg                   ← konfigurace
```

#### mt32-pi.cfg — recommended settings for SF2 mode

```ini
[midi]
gpio_baud_rate = 31250

[audio]
output_device = i2s          # McCake has I2S DAC — better quality than PWM
i2s_dac_init = adafruit-i2s-stemma

[synth]
default_synth = soundfont    # Default mode: SF2 (not MT-32 — you have physical hardware)

[fluidsynth]
soundfont = GeneralUser_GS.sf2
gain = 0.8

[lcd]
type = ssd1306i2c            # OLED displej na drive bay panelu
width = 128
height = 32
```

---

### Game Setup — Key Configurations

#### GUS games (Doom, Duke3D, Heretic, Hexen…)

GUS is auto-detected via the ULTRASND environment variable in most games.

```bat
REM Doom / Doom 2 / Heretic / Hexen / Strife:
Sound Effects : Sound Blaster   port 220  IRQ 5  DMA 1
Music         : Gravis UltraSound   (select in SETUP, auto-detected)

REM Duke Nukem 3D / Shadow Warrior / Blood (SETUP.EXE):
Sound Card    : Sound Blaster 16
  Port 220  IRQ 5  DMA 1  DMA16 5
Music Card    : Gravis UltraSound
  Port 240  IRQ 7  DMA 3

REM Rise of the Triad / Terminal Velocity:
Sound Effects : SB  port 220  IRQ 5  DMA 1
Music         : Gravis UltraSound  port 240  IRQ 7  DMA 3
```

QX1222USB: **CH 9+10 (PicoGUS) UP** + CH 11+12 (AWE32) up for effects.

#### GM games via McCake SF2 (without SC-55)

```bat
REM V game setupu:
Sound Effects : Sound Blaster 16   port 220  IRQ 5  DMA 1
Music         : General MIDI
MIDI port     : 300
```

QX1222USB: **CH 9+10 (PicoGUS/McCake) UP** + CH 11+12 (AWE32) for effects.

#### MT-32 games (unchanged — PicoGUS does not affect this)

SoftMPU + AWE32 MPU-401 on 330h continues to handle MT-32 games exactly
as before. PicoGUS on port 300h does not interfere.

```bat
Sound Effects : Sound Blaster   port 220  IRQ 5  DMA 1
Music         : Roland MT-32
MIDI port     : 330
```

QX1222USB: **CH 3+4 (MT-32) UP** + CH 11+12 (AWE32) up for effects.

---

### McCake vs AWEUTIL /EM:GS — Comparison

Before PicoGUS, AWEUTIL /EM:GS was the only GM/GS option without a physical SC-55.
After installation, McCake is the preferred route.

| | McCake SF2 (port 300h) | AWEUTIL /EM:GS (port 330h) |
|---|---|---|
| Sound quality | Very good (depends on SF2) | Good (EMU8000 + Synthgs.sbk) |
| Extra memory | **0 KB** | ~26 KB UMB |
| Funguje s DOS extendery | **Ano** (DOS4GW, Doom, Quake) | Ne |
| SoftMPU conflict | **None** | Conflicts — use profile NOSOFTMPU |
| Preparation | Nothing (McCake always active) | `LH AWEUTIL.COM /EM:GS` before game |
| After game | Nothing | `AWEUTIL.COM /U` to unload |
| Requires PicoGUS | Yes | No |

**Practical rule:**
Use McCake for all GM games. AWEUTIL /EM:GS is now only a fallback
for cases when PicoGUS is not available.

---

### AWE32 CT3900 + PicoGUS v2.0 Coexistence — Full Resource Summary

| | AWE32 CT3900 | PicoGUS v2.0 |
|---|---|---|
| ISA slot | slot A | slot B |
| Base port | 220h (SB16) | 240h (GUS) |
| IRQ | 5 | 7 |
| DMA | 1 (8-bit) / 5 (16-bit) | 3 |
| MPU-401 | 330h → MT-32 → SC-55 | 300h → McCake SF2 |
| Audio output | QX1222USB CH 11+12 | QX1222USB CH 9+10 |
| Role | SB16 efekty, real OPL3 FM, EMU8000 wavetable, AWE32 native | GUS hudba, McCake GM/SF2 synth |

No IRQ, DMA, or port conflicts. Both cards operate fully independently.

---

### Firmware Update (if needed in the future)

PicoGUS firmware is flashed via USB from the modern PC.

1. Hold the **BOOTSEL** button on the Raspberry Pi Pico while connecting
   USB to the modern PC
2. The Pico appears as a USB mass storage drive (like a USB flash drive)
3. Drag `picogus.uf2` onto the drive
4. The Pico reboots automatically — eject drive first if OS prompts

**Firmware download:** https://github.com/polpo/picogus/releases

Use `picogus.uf2` — the unified all-modes firmware.
Do not use `pg-ne2k.uf2` (WiFi variant, v1.x only — not for v2.0).

After firmware update, run PGUSINIT again or use `/save` version to
re-initialize the card on the DOS PC.

---

### Post-Installation Checklist

- [ ] LPT1 disabled in BIOS Integrated Peripherals
- [ ] IRQ 7 = Legacy ISA in BIOS PnP/PCI Configuration
- [ ] DMA 3 = Legacy ISA in BIOS PnP/PCI Configuration
- [ ] X16GS firmly seated on PicoGUS waveblaster header (pin 1 aligned)
- [ ] PicoGUS in ISA slot, bracket screw secured
- [ ] PicoGUS line out connected to QX1222USB CH 9+10
- [ ] `C:\DRIVERS\PICOGUS\` contains PGUSINIT.EXE, DOSMID.EXE, MIDI\ subdirectory
- [ ] Manual test: `PGUSINIT /mode gus /mpuport 300 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1` prints GUS port 240 IRQ 7 DMA 3
- [ ] Manual test: `DOSMID Slot1.mid` plays through headphones on CH 9+10
- [ ] Manual test: Doom plays GUS music (not SB music)
- [x] AUTOEXEC.BAT: ULTRASND, ULTRADIR, PGUSINIT active in all profiles
- [ ] Reboot test: PGUSINIT message visible in boot sequence
- [ ] Optional: `/save` run once to persist settings to flash


---

## Audio Routing — Behringer QX1222USB

### Channel Assignment

| QX1222USB Channel | Source | Signal |
|---|---|---|
| CH 1 (MONO) | — | empty |
| CH 2 (MONO) | — | empty |
| CH 3 (MONO) | MT-32 Left | PAN fully left |
| CH 4 (MONO) | MT-32 Right | PAN fully right |
| CH 5+6 (STEREO) | Roland SC-55 | stereo |
| CH 7+8 (STEREO) | — | reserved — second PC (Windows XP) |
| CH 9+10 (STEREO) | PicoGUS | GUS music + X16GS synth |
| CH 11+12 (STEREO) | AWE32 CT3900 | SB16 sound effects + real OPL3 FM |
| PHONES | Audio-Technica ATH-M50x | headphone monitoring |
| MAIN OUT (XLR) | → Focusrite Scarlett 16i16 | → modern PC + studio monitors |

### Signal Flow

```
MT-32 L        ──────────────────────► CH 3 (PAN left)  ─┐
MT-32 R        ──────────────────────► CH 4 (PAN right) ─┤
SC-55 stereo   ──────────────────────► CH 5+6           ─┤
PicoGUS stereo ──────────────────────► CH 9+10          ─┼──► MAIN MIX ──► MAIN OUT (XLR)
AWE32 stereo   ──────────────────────► CH 11+12         ─┤         │
(second PC)    ──────────────────────► CH 7+8           ─┘         │
                                                                   │
                                                 ATH-M50x ◄── PHONES
                                                                   │
                                        Focusrite 16i16 ◄── MAIN OUT
                                        (studio monitors + recording)
```

### MIDI Hardware Chain

```
AWE32 gameport MIDI OUT (port 330h)
        │
        ▼
    MT-32 MIDI IN
    MT-32 MIDI THRU
        │
        ▼
    SC-55 MIDI IN
```

### Mixer Operation — which faders to raise

The QX1222USB has no mute buttons on stereo channels — use the faders.
AWE32 (CH11+12) is almost always up for sound effects.
Adjust the music source channel depending on the game.

| Game type | CH 3+4 MT-32 | CH 5+6 SC-55 | CH 9+10 PicoGUS | CH 11+12 AWE32 |
|---|---|---|---|---|
| MT-32 games | **UP** | down | down | up (effects) |
| GM/GS games — SC-55 | down | **UP** | down | up (effects) |
| GUS games | down | down | **UP** | up (effects) |
| AWE32 native games | down | down | down | **UP** (all) |
| GM/GS — X16GS (PicoGUS) | down | down | **UP** | up (effects) |
| OPL3/AdLib only | down | down | down | **UP** (all) |

---

## Sound Device Reference

| Device | Port | IRQ | DMA | Type |
|---|---|---|---|---|
| AWE32 SB16 | 220h | 5 | 1 / 5 | Sound effects, real OPL3 |
| AWE32 MPU-401 | 330h | 5 | — | MIDI out → MT-32 → SC-55 |
| PicoGUS GUS | 240h | 7 | 3 | GUS music |
| PicoGUS MPU-401 | 300h | 7 | — | MIDI → X16GS internal synth |

---

## CONFIG.SYS

```
;===========================================
; CONFIG.SYS - Boot menu
; Rhino 15 / Pentium MMX / AWE32 CT3900 / Voodoo2 / ATI MACH64
; MS-DOS 6.22
;===========================================

; Boot menu - displayed at startup with 10 second countdown
[MENU]
MENUITEM=NOSOFTMPU, No SoftMPU          - NOEMS 607KB (AWEUTIL /EM)
MENUITEM=NOSOFTEMU, No SoftMPU EMS      - RAM   595KB (AWEUTIL /EM + extenders)
MENUITEM=NORMAL,    SoftMPU             - NOEMS 607KB (SoftMPU, MT-32)
MENUITEM=EMS,       SoftMPU EMS         - RAM   595KB (SoftMPU + extenders)
MENUITEM=BARE,      Bare DOS            - no drivers
; Default profile if no key is pressed within timeout
MENUDEFAULT=NOSOFTMPU,10
; Menu colors: text color 11 (bright cyan), background 1 (blue)
;MENUCOLOR=11,1

; -----------------------------------------------
; Common settings loaded for ALL profiles
; -----------------------------------------------
[COMMON]

; 1) HIMEM.SYS - XMS memory manager, must always be first
;    /TESTMEM:OFF = skip memory test on boot (saves ~30 seconds on 256MB)
DEVICE=C:\DOS\HIMEM.SYS /TESTMEM:OFF

; 2) Load DOS into HMA (High Memory Area) and enable UMB
;    Must come before EMM386
DOS=HIGH,UMB

; 3) Larger environment block - prevents DIGN9003 error from AWE32
;    /E:1024 = 1024 bytes for SET variables
SHELL=C:\COMMAND.COM C:\ /E:1024 /P

; --- System settings ---
; FILES=30  - max open file handles (NC + MSCDEX need ~25)
FILES=30
; BUFFERS=4 - disk buffers (SmartDrive replaces DOS buffering)
BUFFERS=4,0
; LASTDRIVE=H - covers drives A,C,D,E,F,G + one spare
LASTDRIVE=H
; STACKS=9,256 - interrupt stack frames
STACKS=9,256
FCBS=1,0

; -----------------------------------------------
; Profile 1: NOSOFTMPU - NOEMS without SoftMPU (607KB conventional)
; Use for: AWEUTIL /EM:GM/GS/MT32 emulation (conflicts with SoftMPU)
;          GM/GS games via AWEUTIL without external MIDI modules
; -----------------------------------------------
[NOSOFTMPU]

; NOTE: HIGHSCAN must NOT be used - causes freeze on Award BIOS 4.51PG
DEVICE=C:\DOS\EMM386.EXE NOEMS

INSTALLHIGH=C:\DOS\SMARTDRV.EXE /X 2048 512
DEVICEHIGH=C:\DRIVERS\SAMSUNG\SSCDROM.SYS /D:SSCD000

; -----------------------------------------------
; Profile 2: NOSOFTEMU - RAM + EMS without SoftMPU (595KB conventional)
; Use for: AWEUTIL /EM + EMS memory
;          Note: AWEUTIL /EM does not work with DOS extenders - prefer profile 1
; -----------------------------------------------
[NOSOFTEMU]

DEVICE=C:\DOS\EMM386.EXE RAM

INSTALLHIGH=C:\DOS\SMARTDRV.EXE /X 2048 512
DEVICEHIGH=C:\DRIVERS\SAMSUNG\SSCDROM.SYS /D:SSCD000

; -----------------------------------------------
; Profile 3: NORMAL - NOEMS with SoftMPU (607KB conventional)
; Use for: MT-32 games (Sierra, LucasArts), GUS games, everyday use
;          AWE32 native games, SC-55, X16GS
; -----------------------------------------------
[NORMAL]

; EMM386 NOEMS = no EMS page frame
; Frees 64KB of UMB compared to RAM mode
; UNISOUND, CTMOUSE, SoftMPU do not require EMS
; NOTE: HIGHSCAN must NOT be used - causes freeze on Award BIOS 4.51PG
DEVICE=C:\DOS\EMM386.EXE NOEMS

; SmartDrive loaded first via INSTALLHIGH to claim largest free UMB block
; /X = disable write cache (safer for power loss)
; 2048KB read cache, 512KB write cache
INSTALLHIGH=C:\DOS\SMARTDRV.EXE /X 2048 512

; Samsung CD-ROM driver into UMB
DEVICEHIGH=C:\DRIVERS\SAMSUNG\SSCDROM.SYS /D:SSCD000

; -----------------------------------------------
; Profile 4: EMS/GAMES - RAM with SoftMPU (595KB conventional)
; Use for: DOS extender games (Tyrian, Magic Carpet), games requiring EMS
; Note: 12KB less conventional memory than NORMAL due to EMS page frame
; -----------------------------------------------
[EMS]

; EMM386 RAM = EMS + UMB both enabled
; EMS page frame uses 64KB of UMB but allows DOS extenders to work
DEVICE=C:\DOS\EMM386.EXE RAM

; SmartDrive loaded first to claim largest free UMB block
INSTALLHIGH=C:\DOS\SMARTDRV.EXE /X 2048 512

; Samsung CD-ROM driver into UMB
DEVICEHIGH=C:\DRIVERS\SAMSUNG\SSCDROM.SYS /D:SSCD000

; -----------------------------------------------
; Profile 5: BARE DOS - minimal (diagnostics, installation)
; No sound, no CD-ROM, no mouse - just basic DOS
; -----------------------------------------------
[BARE]

; Minimal EMM386 for XMS access only
DEVICE=C:\DOS\EMM386.EXE NOEMS
```

---

## AUTOEXEC.BAT

```bat
@ECHO OFF
PROMPT $P$G
PATH C:\DOS;C:\NC;C:\TOOLS\NU;C:\DRIVERS\PICOGUS;C:\DRIVERS\SB16

REM --- Environment variables ---
SET SYMANTEC=C:\SYMANTEC
SET NU=C:\TOOLS\NU
SET TEMP=C:\DOS\TMP
SET TMP=C:\DOS\TMP
SET TELIX=C:\TOOLS\TELIX

REM --- AWE32 CT3900 settings ---
REM A220=SB16 port, I5=IRQ, D1=DMA 8bit, H5=DMA 16bit
REM P330=MPU-401 port (MT-32/SC-55 chain), E620=EMU8000, T6=SB16/AWE type
REM CT3900 semi-PnP: UNISOUND programs IRQ/DMA from these values
REM Available values: IRQ 2/5/7/10, Low DMA 0/1/3, High DMA 5/6/7
SET SOUND=C:\DRIVERS\SB16
SET BLASTER=A220 I5 D1 H5 P330 E620 T6
SET MIDI=SYNTH:1 MAP:E MODE:0

REM --- PicoGUS / Gravis UltraSound settings ---
SET ULTRASND=240,3,3,7,7
SET ULTRADIR=C:\DRIVERS\PICOGUS

REM --- Route to profile-specific section ---
GOTO %CONFIG%

REM -----------------------------------------------
REM Profile 1: NOSOFTMPU - NOEMS without SoftMPU
REM Use for: AWEUTIL /EM:GM/GS/MT32 emulation without conflict
REM -----------------------------------------------
:NOSOFTMPU
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90
C:\DRIVERS\SB16\AWEUTIL.COM /S
REM SoftMPU NOT loaded - AWEUTIL /EM can run without conflict:
REM   LH C:\DRIVERS\SB16\AWEUTIL.COM /EM:GM
REM   LH C:\DRIVERS\SB16\AWEUTIL.COM /EM:GS
REM   LH C:\DRIVERS\SB16\AWEUTIL.COM /EM:MT32
REM   C:\DRIVERS\SB16\AWEUTIL.COM /U
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 300 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
LH C:\DOS\MSCDEX.EXE /D:SSCD000 /M:10
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END

REM -----------------------------------------------
REM Profile 2: NOSOFTEMU - EMS without SoftMPU
REM Use for: AWEUTIL /EM + EMS memory
REM Note: AWEUTIL /EM does not work with DOS extenders (DOS4GW)
REM -----------------------------------------------
:NOSOFTEMU
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90
C:\DRIVERS\SB16\AWEUTIL.COM /S
REM SoftMPU NOT loaded
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 300 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
LH C:\DOS\MSCDEX.EXE /D:SSCD000 /M:10
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END

REM -----------------------------------------------
REM Profile 3: NORMAL - NOEMS with SoftMPU
REM Use for: MT-32 games (Sierra, LucasArts), GUS, AWE32, SC-55, X16GS
REM WARNING: AWEUTIL /EM:* cannot be combined with SoftMPU
REM -----------------------------------------------
:NORMAL
REM --- AWE32 CT3900 hardware init (UNISOUND) ---
REM Initializes: IRQ, DMA, I/O ports, OPL3, mixer
REM /V70 = master volume 70, /VF90 = FM/OPL3 volume 90 (real OPL3 CT1747)
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90

REM --- AWEUTIL - EMU8000 wavetable synthesizer init ---
REM /S = hardware init only, 0KB memory
REM WARNING: AWEUTIL /EM:* conflicts with SoftMPU - use profile 1 (NOSOFTMPU)
C:\DRIVERS\SB16\AWEUTIL.COM /S

REM --- SoftMPU - intelligent mode MPU-401 emulation for MT-32 games ---
REM Required for: Monkey Island 1, Sierra games, Ultima Underworld
REM AWE32 supports UART mode only - SoftMPU adds intelligent mode
REM /MPU:330 = MPU-401 port (must match P330 in BLASTER)
REM /SB:220  = Sound Blaster base port (explicit, prevents autodetect failure)
REM /IRQ:5   = Sound Blaster IRQ for intelligent mode timing
REM WARNING: AWEUTIL /EM:* cannot be combined with SoftMPU!
LH C:\DRIVERS\SOFTMPU\SOFTMPU.EXE /MPU:330 /SB:220 /IRQ:5

REM --- PicoGUS ---
REM /mode gus    = Gravis UltraSound emulation
REM /mpuport 300 = MPU-401 on 300h (AWE32 uses 330h - must not conflict)
REM /mainvol 95  = master output 95% (headroom to prevent clipping)
 REM /gusvol 95   = GUS output 95%
 REM /wtvol 95    = wavetable header output 95% (lowered to prevent clipping)
REM /mpudelay 1  = slow down SysEx for Roland-compatible synthesizers
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 300 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1

REM --- CD-ROM ---
REM /M:10 = 10 sector lookahead cache in extended memory
LH C:\DOS\MSCDEX.EXE /D:SSCD000 /M:10

REM --- Mouse ---
REM /R2 = horizontal resolution 2 (movement sensitivity)
REM COM port is auto-detected by CTMOUSE
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END

REM -----------------------------------------------
REM Profile 4: EMS/GAMES - RAM with SoftMPU
REM Use for: DOS extender games (Tyrian, Magic Carpet), EMS memory
REM WARNING: AWEUTIL /EM:* does not work with DOS extenders or SoftMPU
REM -----------------------------------------------
:EMS
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90
C:\DRIVERS\SB16\AWEUTIL.COM /S
LH C:\DRIVERS\SOFTMPU\SOFTMPU.EXE /MPU:330 /SB:220 /IRQ:5
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 300 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
LH C:\DOS\MSCDEX.EXE /D:SSCD000 /M:10
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END

REM -----------------------------------------------
REM Profile 5: BARE DOS
REM -----------------------------------------------
:BARE
GOTO END

:END
REM --- Norton Commander ---
NC
```

---

## Environment Variables Reference

```bat
SET BLASTER=A220 I5 D1 H5 P330 E620 T6
  A220  = SB16 base port 220h
  I5    = IRQ 5
  D1    = DMA 1 (8-bit)
  H5    = DMA 5 (16-bit)
  P330  = MPU-401 port 330h (MT-32 / SC-55 chain)
  E620  = AWE32 EMU8000 port 620h
  T6    = card type SB16/AWE

SET ULTRASND=240,3,3,7,7
  240   = GUS base port 240h
  3,3   = DMA 3 (play and record - value repeated)
  7,7   = IRQ 7 (play and record - value repeated)

SET ULTRADIR=C:\DRIVERS\PICOGUS
  root directory of GUS software and MIDI patches
  must NOT point to the MIDI subfolder
```

---

## AWEUTIL — EMU8000 Wavetable Synthesizer

### UNISOUND vs AWEUTIL — what each does

| Function | UNISOUND | AWEUTIL |
|---|---|---|
| Hardware init (IRQ, DMA, ports) | **Yes** | No |
| OPL3 FM synthesis | **Yes** | No |
| Mixer (volume, balance) | **Yes** | No |
| EMU8000 wavetable init | No | **Yes** |
| MIDI emulation GM/GS/MT-32 | No | **Yes** |
| SoundFont loading (.SBK) | No | **Yes** |
| Reverb and chorus effects | No | **Yes** (via CT1747) |

**UNISOUND is not enough for full AWE32 features.** AWEUTIL is required
for wavetable synthesis and MIDI emulation via EMU8000.

### Files required for AWEUTIL

All files belong in `C:\DRIVERS\SB16\` (or wherever `SET SOUND=` points):

| File | Purpose |
|---|---|
| `AWEUTIL.COM` | Main utility — init, MIDI emulation, soundfonts |
| `Synthgm.sbk` | GM soundfont (required for `/EM:GM`) |
| `Synthgs.sbk` | GS soundfont (required for `/EM:GS`) |
| `Synthmt.sbk` | MT-32 soundfont (required for `/EM:MT32`) |

**Download — exact source:**

`AWEUTIL.COM` + all `.SBK` soundfonts are part of **Creative AWE32/SB32 DOS driver v2.00**:

```
archive.org → search: "Creative Sound Blaster AWE32 Drivers"
              file:    AWE32DRV.EXE  or  SB32V200.EXE
vogons.org  → Files section → Sound Blaster AWE32
```

After extracting, copy to `C:\DRIVERS\SB16\`:
- `AWEUTIL.COM`
- `SYNTHGM.SBK`  (rename to `Synthgm.sbk`)
- `SYNTHGS.SBK`  (rename to `Synthgs.sbk`)
- `SYNTHMT.SBK`  (rename to `Synthmt.sbk`)

> Each file is ~1 MB — transfer via FTP or CD-ROM.

### AWEUTIL commands

```bat
C:\DRIVERS\SB16\AWEUTIL.COM /S       ← init EMU8000 (reads BLASTER variable)
                                         run after UNISOUND at every boot

C:\DRIVERS\SB16\AWEUTIL.COM /EM:GM   ← General MIDI emulation (Synthgm.sbk)
C:\DRIVERS\SB16\AWEUTIL.COM /EM:GS   ← Roland GS emulation (Synthgs.sbk)
C:\DRIVERS\SB16\AWEUTIL.COM /EM:MT32 ← Roland MT-32 emulation (Synthmt.sbk)
C:\DRIVERS\SB16\AWEUTIL.COM /U       ← unload from memory (before switching mode)

C:\DRIVERS\SB16\AWEUTIL.COM /SF:font.sbk  ← load custom soundfont
C:\DRIVERS\SB16\AWEUTIL.COM /R:0          ← Reverb off
C:\DRIVERS\SB16\AWEUTIL.COM /R:5          ← Reverb level 5 (0-7)
C:\DRIVERS\SB16\AWEUTIL.COM /C:0          ← Chorus off
C:\DRIVERS\SB16\AWEUTIL.COM /C:3          ← Chorus level 3 (0-7)
```

### When to use AWEUTIL /EM vs. SC-55 or MT-32

| Situation | Recommendation |
|---|---|
| Game has native "AWE32" option in setup | AWEUTIL /S, select AWE32 in setup |
| Game has GM, no SC-55 connected | AWEUTIL /EM:GM or X16GS |
| Want MT-32 sound without physical MT-32 | AWEUTIL /EM:MT32 (worse than real HW) |
| SC-55 is connected | SC-55 >> AWEUTIL /EM:GS (SC-55 is better) |
| MT-32 is connected | MT-32 >> AWEUTIL /EM:MT32 (real HW always better) |

**AWEUTIL /EM limitations:**
- Does not work with DOS extenders (DOS4GW, DOS32A) — Doom, Quake, Duke3D
- **Cannot run simultaneously with SoftMPU** — see below
- Protected mode software does not support MIDI emulation

### ⚠️ Critical conflict: AWEUTIL /EM + SoftMPU

`AWEUTIL /EM:*` and `SoftMPU` **cannot run simultaneously** — both attempt
to control the MIDI interface and interfere with each other.

| Combination | Result |
|---|---|
| `AWEUTIL /S` + SoftMPU | ✓ OK — `/S` only initializes hardware, does not control MIDI |
| `AWEUTIL /EM:GS` + SoftMPU | ✗ **Conflict** — do not use! |
| `AWEUTIL /EM:MT32` + SoftMPU | ✗ **Conflict** — do not use! |

Practical rule: run `AWEUTIL /EM:*` **only for GM/GS games that do not
need intelligent mode** (i.e. games where SoftMPU is not needed).
MT-32 games and older Sierra/LucasArts titles require SoftMPU → never use AWEUTIL /EM.

### FixMPU — hanging note bug

FixMPU solves the hanging note bug (stuck MIDI notes) on cards with DSP 4.11–4.13.

**CT3900 with CT1747 chip does not have this bug** — FixMPU is not needed.
Listed here for completeness — in case the problem occurs on another card.

FixMPU is **not a TSR** — it works as a **launcher** around the game:

```bat
REM Instead of running directly:
DOOM.EXE

REM With FixMPU:
FIXMPU.COM DOOM.EXE
FIXMPU.COM DUKE3D.EXE /xargs
```

Requirements: correct BLASTER variable (A, I, P values), IRQ must be < 8.
Download: vogons.org → Files → FixMPU

### AWEUTIL and memory — key difference

| Command | Behavior | Memory after completion |
|---|---|---|
| `AWEUTIL /S` | initializes EMU8000, exits immediately | **0 KB** |
| `LH AWEUTIL /EM:GS` | loads TSR into UMB, stays resident | **~26 KB UMB** |
| `AWEUTIL /U` | unloads TSR from memory | 0 KB |

**`AWEUTIL /S` belongs in AUTOEXEC** — initializes hardware, uses no memory.

**`AWEUTIL /EM:*` does NOT belong in AUTOEXEC** — run manually before game with `LH`:

```bat
LH C:\DRIVERS\SB16\AWEUTIL.COM /EM:GS    ← TSR into UMB (~26 KB of free ~40 KB)
game.exe
C:\DRIVERS\SB16\AWEUTIL.COM /U           ← unload after game (required!)
```

Without `LH` the TSR would use ~26 KB of conventional memory instead of UMB.

**Why not load `/EM` at boot:**
- Different games need different modes (GM / GS / MT32) — you need to switch
- GUS games and DOS extender games ignore AWEUTIL /EM
- Conflict with SoftMPU — see above
- TSR would waste memory unnecessarily

### AWEUTIL — pre-game workflow

```bat
REM MT-32 game (Sierra, LucasArts floppy):
REM QX1222USB: CH 3+4 (MT-32) UP, CH 11+12 (AWE32) up for effects
REM SoftMPU active from AUTOEXEC, DO NOT run AWEUTIL /EM (conflicts with SoftMPU)
KQ5.EXE

REM GM/GS game with SC-55 connected:
REM QX1222USB: CH 5+6 (SC-55) UP, CH 11+12 (AWE32) up for effects
REM Do not run AWEUTIL /EM — SC-55 >> EMU8000, SoftMPU does not interfere here
MONKEY2.EXE

REM GUS game (Doom, Duke3D, Heretic):
REM QX1222USB: CH 9+10 (PicoGUS) UP, CH 11+12 (AWE32) up for effects
REM Do not run AWEUTIL, GUS is via PicoGUS
DOOM.EXE

REM AWE32 native game:
REM QX1222USB: CH 11+12 (AWE32) UP for everything
REM AWEUTIL /S ran at boot, just launch the game
FIFA95.EXE

REM GM/GS game WITHOUT SC-55, WITHOUT DOS extender:
REM QX1222USB: CH 9+10 (PicoGUS/X16GS) UP + CH 11+12 (AWE32) for effects
REM Prefer X16GS (port 300h) — no SoftMPU conflict
LH C:\DRIVERS\SB16\AWEUTIL.COM /EM:GS
game.exe
C:\DRIVERS\SB16\AWEUTIL.COM /U

REM Switching AWEUTIL mode between games:
C:\DRIVERS\SB16\AWEUTIL.COM /U              ← unload current mode first
LH C:\DRIVERS\SB16\AWEUTIL.COM /EM:MT32    ← then load new mode
```

> **Practical recommendation:** With SC-55 and MT-32 connected, AWEUTIL /EM
> is almost never needed. SC-55 > EMU8000, MT-32 > EMU8000.
> Use AWEUTIL /EM:GS only when travelling (no external modules) or for quick
> testing — always prefer X16GS (port 300h) to avoid SoftMPU conflict.

### AWEUTIL in AUTOEXEC.BAT — profile overview

| Profile | SoftMPU | AWEUTIL /EM | QX1222USB | Use for |
|---|---|---|---|---|
| **1 NOSOFTMPU** | No | **Yes** | CH 11+12 only | GM/GS games via AWEUTIL emulation |
| **2 NOSOFTEMU** | No | Yes (no extender) | CH 11+12 only | AWEUTIL /EM + EMS memory |
| **3 NORMAL** | Yes | No | per game table | MT-32 games, GUS, AWE32 native, SC-55 |
| **4 EMS** | Yes | No | per game table | DOS extender games + SoftMPU |
| **5 BARE** | No | No | — | diagnostics, installation |

```bat
REM Profile 3 NORMAL — order in AUTOEXEC:
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90
C:\DRIVERS\SB16\AWEUTIL.COM /S             ← hardware init only, 0 KB memory
LH C:\DRIVERS\SOFTMPU\SOFTMPU.EXE /MPU:330 /SB:220 /IRQ:5

REM Profile 1 NOSOFTMPU — order in AUTOEXEC:
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90
C:\DRIVERS\SB16\AWEUTIL.COM /S             ← hardware init only, 0 KB memory
REM (SoftMPU not loaded — AWEUTIL /EM can be run manually)
```

### Games with native AWE32 support (AWEUTIL /S only needed)

These games offer "Sound Blaster AWE32" or "AWE32" in their setup:
Civilization 2, Master of Orion 2, Warcraft 2, FIFA Soccer 95/96/97, NHL 96/97,
Need for Speed (DOS).
Setup: select AWE32, port 220, IRQ 5, DMA 1, DMA16 5.

---

## Game Setup Guide

### Sound device priority — general rule

```
Real MT-32 hardware  >  Real SC-55 hardware  >  PicoGUS GUS  >  X16GS  >  AWEUTIL EMU8000  >  OPL3
```

Physical hardware always sounds better than emulation. GUS has exceptional
quality in its supported games thanks to sampled patches. OPL3 is an
intentional retro sound.

---

### Category 1 — MT-32 games
**QX1222USB: CH 3+4 (MT-32) UP, CH 11+12 (AWE32) up for effects | Profile: NORMAL**

These games were composed specifically for the Roland MT-32. SC-55 and GM
emulation do not sound correct — specific MT-32 timbre sets and SysEx
initialization are missing.

**Sierra On-Line:**

| Game | Year | Setup | SoftMPU | EMS |
|---|---|---|---|---|
| King's Quest 4 | 1988 | Music: Roland MT-32, port 330 | Yes | No |
| King's Quest 5 | 1990 | Music: Roland MT-32 or MIDI, port 330 | Yes | No |
| Space Quest 3 | 1989 | Music: Roland MT-32, port 330 | Yes | No |
| Space Quest 4 | 1991 | Music: Roland MT-32 or MIDI, port 330 | Yes | No |
| Police Quest 2 | 1988 | Music: Roland MT-32, port 330 | Yes | No |
| Police Quest 3 | 1991 | Music: Roland MT-32 or MIDI, port 330 | Yes | No |
| Quest for Glory 1 (EGA/VGA) | 1989/1992 | Music: Roland MT-32, port 330 | Yes | No |
| Quest for Glory 2 | 1990 | Music: Roland MT-32, port 330 | Yes | No |
| Leisure Suit Larry 3 | 1989 | Music: Roland MT-32, port 330 | Yes | No |
| Leisure Suit Larry 5 | 1991 | Music: Roland MT-32 or MIDI, port 330 | Yes | No |
| Gabriel Knight 1 | 1993 | Music: Roland MT-32 or General MIDI | Yes | No |
| Conquests of Camelot | 1990 | Music: Roland MT-32, port 330 | Yes | No |
| Conquests of Longbow | 1991 | Music: Roland MT-32, port 330 | Yes | No |

**LucasArts (floppy versions — CD versions have GM):**

| Game | Year | Notes | SoftMPU | EMS |
|---|---|---|---|---|
| Maniac Mansion | 1987 | Music: Roland MT-32 | Yes | No |
| Zak McKracken | 1988 | Music: Roland MT-32 | Yes | No |
| Indiana Jones Last Crusade | 1989 | Music: Roland MT-32 — intelligent mode | Yes | No |
| Loom (floppy) | 1990 | Music: Roland MT-32 — intelligent mode | Yes | No |
| Monkey Island 1 (floppy) | 1990 | Music: Roland MT-32 — intelligent mode | Yes | No |
| Monkey Island 2 | 1991 | MT-32 or GM — GM on SC-55 sounds great | Yes | No |

**Origin / Wing Commander:**

| Game | Year | Setup | SoftMPU | EMS |
|---|---|---|---|---|
| Wing Commander 1 | 1990 | Music: Roland MT-32, port 330, Sound: SB | Yes | No |
| Wing Commander 2 | 1991 | Music: Roland MT-32, port 330, Sound: SB | Yes | No |
| Ultima VI | 1990 | Music: Roland MT-32, port 330 | Yes | No |
| Ultima Underworld 1 | 1992 | Music: General MIDI (SC-55) — intelligent mode | Yes | No |

**SSI / Westwood (dungeon/RPG):**

| Game | Year | Setup | SoftMPU | EMS |
|---|---|---|---|---|
| Eye of the Beholder 1 | 1991 | Music: Roland MT-32, port 330 | Yes | No |
| Eye of the Beholder 2 | 1991 | Music: Roland MT-32, port 330 | Yes | No |
| Pool of Radiance | 1988 | Music: Roland MT-32 | Yes | No |
| Champions of Krynn | 1990 | Music: Roland MT-32 | Yes | No |

```
Sound Effects : Sound Blaster   port 220  IRQ 5  DMA 1
Music         : Roland MT-32
MIDI port     : 330
```

> SoftMPU is loaded from AUTOEXEC — intelligent mode works automatically.
> SC-55 is in the MIDI chain after MT-32 (THRU) — it outputs nothing for MT-32 games.

---

### Category 2 — GM/GS games — SC-55
**QX1222USB: CH 5+6 (SC-55) UP, CH 11+12 (AWE32) up for effects | Profile: NORMAL**

These games were composed or optimized for the Roland SC-55/SC-88.
SC-55 sounds more authentic than any emulation — the music was typically
mixed directly on this hardware.

**LucasArts iMUSE engine:**

| Game | Year | Setup | SoftMPU | EMS |
|---|---|---|---|---|
| Monkey Island 2 | 1991 | General MIDI, port 330 — iMUSE dynamic music | No | No |
| Indiana Jones Fate of Atlantis | 1992 | General MIDI, port 330 | No | No |
| Day of the Tentacle | 1993 | General MIDI, port 330 — iMUSE | No | No |
| Sam & Max Hit the Road | 1993 | General MIDI, port 330 — iMUSE | No | No |
| Dark Forces | 1995 | General MIDI, port 330 — iMUSE | No | No |
| Full Throttle | 1995 | General MIDI, port 330 — iMUSE | No | No |
| The Dig | 1995 | General MIDI, port 330 — iMUSE | No | No |
| TIE Fighter | 1994 | General MIDI, port 330 — iMUSE | No | No |
| X-Wing | 1993 | General MIDI, port 330 — iMUSE | No | No |

**Westwood Studios:**

| Game | Year | Setup | SoftMPU | EMS |
|---|---|---|---|---|
| Legend of Kyrandia 1 | 1992 | General MIDI, port 330 | No | No |
| Legend of Kyrandia 2 | 1993 | General MIDI, port 330 | No | No |
| Legend of Kyrandia 3 | 1994 | General MIDI, port 330 | No | No |
| Command & Conquer | 1995 | General MIDI, port 330 — SC-55 sounds excellent | No | No |
| Red Alert | 1996 | General MIDI, port 330 | No | No |

**Origin Systems:**

| Game | Year | Setup | SoftMPU | EMS |
|---|---|---|---|---|
| Wing Commander 3 | 1994 | General MIDI, port 330, Sound: SB16 | No | No |
| Wing Commander 4 | 1996 | General MIDI, port 330, Sound: SB16 | No | No |
| Privateer | 1993 | General MIDI, port 330, Sound: SB | No | No |
| Ultima Underworld 1 | 1992 | General MIDI, port 330, Sound: SB16 | No | No |
| Ultima Underworld 2 | 1993 | General MIDI, port 330, Sound: SB16 | No | No |
| Ultima 7 Part 1+2 | 1992/1993 | General MIDI, port 330 | No | No |
| Ultima 8 | 1994 | General MIDI, port 330 | No | No |

**Microprose / Strategy:**

| Game | Year | Setup | SoftMPU | EMS |
|---|---|---|---|---|
| X-COM UFO Defense | 1994 | General MIDI, port 330, Sound: SB16 | No | No |
| X-COM Terror from the Deep | 1995 | General MIDI, port 330 | No | No |
| Civilization 2 | 1996 | AWE32 native or GM, port 330 — see Category 4 | No | No |
| Master of Orion 2 | 1996 | AWE32 native or GM — see Category 4 | No | No |

**Other:**

| Game | Year | Setup | SoftMPU | EMS |
|---|---|---|---|---|
| Crusader No Remorse | 1995 | General MIDI, port 330, Sound: SB16 | No | No |
| Crusader No Regret | 1996 | General MIDI, port 330, Sound: SB16 | No | No |
| Descent 1 | 1994 | GM or GUS — GUS recommended for music | No | No |
| Descent 2 | 1996 | GM or GUS — GUS recommended for music | No | No |
| Warcraft 2 | 1995 | AWE32 native or GM — see Category 4 | No | No |

```
Sound Effects : Sound Blaster 16   port 220  IRQ 5  DMA 1
Music         : General MIDI
MIDI port     : 330
```

> SC-55 must be in GS mode (default). Switch with: DOSMID /mpu=330 /preset=GS.
> MT-32 is in MIDI chain before SC-55 (THRU) — MIDI data pass through MT-32
> transparently and arrive at SC-55.
>
> **Warcraft 2 and Civilization 2** also offer a native AWE32 option —
> it sounds better than GM via SC-55. See Category 4.

---

### Category 3 — GUS games
**QX1222USB: CH 9+10 (PicoGUS) UP, CH 11+12 (AWE32) up for effects | Profile: NORMAL**

These games have native Gravis UltraSound support with their own sampled
patch sets. GUS sounds better in these games than SB16 due to wavetable
synthesis directly in hardware — no MIDI emulation needed.

**id Software:**

| Game | Year | Sound Effects | Music | SoftMPU | EMS |
|---|---|---|---|---|---|
| Doom | 1993 | SB port 220 IRQ 5 DMA 1 | Gravis UltraSound | No | No |
| Doom 2 | 1994 | SB port 220 IRQ 5 DMA 1 | Gravis UltraSound | No | No |
| Heretic | 1994 | SB port 220 IRQ 5 DMA 1 | Gravis UltraSound | No | No |
| Hexen | 1995 | SB port 220 IRQ 5 DMA 1 | Gravis UltraSound | No | No |
| Quake | 1996 | SB16 port 220 IRQ 5 DMA 1 | CD audio or GUS | No | No |

**Apogee / 3D Realms:**

| Game | Year | Sound Effects | Music | SoftMPU | EMS |
|---|---|---|---|---|---|
| Duke Nukem 3D | 1996 | SB16 port 220 IRQ 5 DMA 1 DMA16 5 | GUS port 240 IRQ 7 DMA 3 | No | No |
| Shadow Warrior | 1997 | SB16 port 220 IRQ 5 DMA 1 DMA16 5 | GUS port 240 IRQ 7 DMA 3 | No | No |
| Blood | 1997 | SB16 port 220 IRQ 5 DMA 1 DMA16 5 | GUS port 240 IRQ 7 DMA 3 | No | No |
| Rise of the Triad | 1994 | SB port 220 IRQ 5 DMA 1 | GUS port 240 IRQ 7 DMA 3 | No | No |
| Terminal Velocity | 1995 | SB16 port 220 IRQ 5 DMA 1 | GUS port 240 IRQ 7 DMA 3 | No | No |

**Other:**

| Game | Year | Notes | SoftMPU | EMS |
|---|---|---|---|---|
| Strife | 1996 | GUS music, SB effects | No | No |
| Descent 1 | 1994 | GUS preferred over GM | No | No |
| Descent 2 | 1996 | GUS preferred over GM | No | No |
| Raptor Call of Shadows | 1994 | GUS music | No | No |
| Blake Stone | 1993 | GUS music | No | No |

```bat
REM Doom / Doom 2 / Heretic / Hexen:
  Sound Effects : Sound Blaster   port 220  IRQ 5  DMA 1
  Music         : Gravis UltraSound
  (GUS is auto-detected via ULTRASND environment variable)

REM Duke Nukem 3D / Shadow Warrior / Blood (SETUP.EXE):
  Sound Card    : Sound Blaster 16
  Port          : 220   IRQ: 5   DMA: 1   DMA16: 5
  Music Card    : Gravis UltraSound
  Port          : 240   IRQ: 7   DMA: 3

REM Quake (GLQuake with Voodoo2):
  GLQUAKE.EXE -width 800 -height 600 -bpp 16 -nolan
```

#### ULTRAMID.EXE — required for some GUS games

Some games (notably **Tyrian**, **Raptor**) use the ULTRAMID TSR driver for GUS music
instead of direct hardware access. Without ULTRAMID loaded, the game reports
"UltraMid driver not found" or "no GUS device" even when PGUSINIT is active.

ULTRAMID.EXE is included in the GUS v4.11 software package (`picog.us/ultrasnd.zip`),
located at `C:\DRIVERS\PICOGUS\ULTRAMID.EXE`.

**Do NOT load ULTRAMID in AUTOEXEC** — it takes ~58 KB of UMB and is only needed
for specific games. Use **GUS.BAT** instead (see below).

#### GUS.BAT — universal launcher for ULTRAMID games

Place `GUS.BAT` in `C:\TOOLS\` (already in PATH). Run from the game directory:

```bat
REM First-time sound setup:
D:\GAMES\TYRIAN> GUS SETUP.EXE

REM Launch game:
D:\GAMES\TYRIAN> GUS TYRIAN.EXE
D:\GAMES\DOOM>   GUS DOOM.EXE
D:\GAMES\RAPTOR> GUS RAPTOR.EXE
D:\GAMES\DUKE3D> GUS DUKE3D.EXE -level 1
```

GUS.BAT loads ULTRAMID before the game, then unloads it automatically when the
game exits. Games that do NOT need ULTRAMID (Doom, Duke3D, Heretic, Hexen) work
fine with GUS.BAT too — ULTRAMID is harmless for those games.

| Game | Needs ULTRAMID | Notes |
|---|---|---|
| Doom / Doom 2 / Heretic / Hexen | No | Direct GUS hardware access |
| Duke Nukem 3D / Shadow Warrior / Blood | No | Direct GUS hardware access |
| **Tyrian** | **Yes** | GUS.BAT required |
| **Raptor Call of Shadows** | **Yes** | GUS.BAT required |
| Strife | No | Direct GUS hardware access |
| Descent 1/2 | No | Direct GUS hardware access |

> **Duke Nukem 3D / Shadow Warrior / Blood — MIDI lag on startup:**
> When music is set to General MIDI or Sound Canvas (SC-55 on port 330h), the game
> stutters for 1–2 seconds at map load. Cause: Creative SB16 ISA cards (AWE32/AWE64)
> cannot simultaneously handle DMA transfers for digital audio and MIDI initialization
> at higher sample rates — a known BUILD engine issue with all Creative ISA cards.
>
> **Fix now (before PicoGUS):** In SETUP.EXE set Sound Effects to **11025 Hz, 8-bit, 4 voices**.
> Duke 3D samples are originally 8-bit 11kHz — higher settings are just interpolation,
> no real quality is lost. Lag disappears.
>
> **Fix after PicoGUS installation:** Switch music to **Gravis UltraSound** —
> GUS runs on its own channel (port 240h IRQ 7 DMA 3), the SB16 MPU-401 is not used
> at all and the lag does not exist. Recommended permanent solution.

---

### Category 4 — AWE32 native games (EMU8000 wavetable)
**QX1222USB: CH 11+12 (AWE32) UP for all | Profile: NORMAL | AWEUTIL /S runs from AUTOEXEC**

These games access the EMU8000 synthesizer directly. AWEUTIL /S runs from
AUTOEXEC — no additional steps before launching. If the game offers both GM
and AWE32, always choose AWE32 (native wavetable, better quality).

| Game | Year | Select in setup | SoftMPU | EMS | Notes |
|---|---|---|---|---|---|
| FIFA Soccer 95 | 1994 | Sound Blaster AWE32 | No | No | port 220, IRQ 5, DMA 1 |
| FIFA Soccer 96 | 1995 | Sound Blaster AWE32 | No | No | port 220, IRQ 5, DMA 1 |
| FIFA Soccer 97 | 1996 | Sound Blaster AWE32 | No | No | port 220, IRQ 5, DMA 1 |
| NHL 96 | 1995 | Sound Blaster AWE32 | No | No | port 220, IRQ 5, DMA 1 |
| NHL 97 | 1996 | Sound Blaster AWE32 | No | No | port 220, IRQ 5, DMA 1 |
| Need for Speed (DOS) | 1994 | AWE32 or SB16 | No | No | prefer AWE32 |
| Warcraft 2 | 1995 | AWE32 or GM | No | No | AWE32: CH 11+12 only; GM: CH 5+6 + CH 11+12 |
| Civilization 2 | 1996 | Sound Blaster AWE32 | No | No | or GM via SC-55 |
| Master of Orion 2 | 1996 | AWE32 or GM | No | No | prefer AWE32 |

```
Sound Card    : Sound Blaster AWE32
Port          : 220   IRQ: 5   DMA: 1   DMA16: 5
EMU8000 Port  : 620

Before game: nothing — AWEUTIL /S runs from AUTOEXEC automatically
```

---

### Category 5 — GM/GS games without external modules
**QX1222USB: CH 9+10 (PicoGUS/McCake) UP + CH 11+12 (AWE32) for effects | Profile: NORMAL**

Use when SC-55 is not connected or you do not want to switch MIDI chain.
McCake on port 300h via PicoGUS — no preparation needed, always active.

| Game | Year | Setup | SoftMPU | EMS |
|---|---|---|---|---|
| Doom / Doom 2 | 1993/94 | GM port 300, SB port 220 | No | No |
| Duke Nukem 3D | 1996 | GM port 300, SB port 220 | No | No |
| Quake | 1996 | SB16 port 220 | No | No |
| Tyrian | 1995 | GM port 300 or **GUS** (use GUS.BAT) | No | **Yes** (EMS profile) |
| Magic Carpet | 1994 | SB16 port 220 | No | **Yes** (EMS profile) |
| Descent 1/2 | 1994/96 | GM port 300 or GUS | No | No |

```bat
Sound Effects : Sound Blaster 16   port 220  IRQ 5  DMA 1
Music         : General MIDI
MIDI port     : 300
```

> AWEUTIL /EM:GS remains available as fallback via profile NOSOFTMPU (port 330h),
> but McCake is preferred — no preparation, no memory cost, no SoftMPU conflict.

---

### Category 6 — OPL3 / AdLib / FM games
**QX1222USB: CH 11+12 (AWE32) UP — real OPL3 CT1747 | Profile: NORMAL**

CT3900 has a **real Yamaha OPL3** chip (CT1747) — unlike AWE64 which used
CQM emulation. These games sound authentically correct on CT3900.

| Game | Year | Best setup | SoftMPU | EMS |
|---|---|---|---|---|
| Wolfenstein 3D | 1992 | AdLib or SB, port 220 | No | No |
| Commander Keen 4/5/6 | 1991/92 | AdLib port 388 | No | No |
| Jazz Jackrabbit | 1994 | SB or AdLib, port 220 | No | No |
| Raptor Call of Shadows | 1994 | SB or AdLib (alternative to GUS) | No | No |
| Tyrian | 1995 | SB16 port 220 IRQ 5 DMA 1 | No | **Yes** (EMS profile) |
| Dune 2 | 1992 | AdLib or SB | No | No |
| Theme Park | 1994 | SB16, port 220 | No | No |
| Transport Tycoon | 1994 | SB16, port 220 | No | No |
| SimCity 2000 | 1993 | SB16, port 220 | No | No |
| Syndicate | 1993 | SB16, port 220 | No | No |
| Magic Carpet | 1994 | SB16, port 220, DMA 1 | No | **Yes** (EMS profile) |
| Populous | 1989 | AdLib | No | No |
| Lemmings | 1991 | AdLib or SB | No | No |

```
Sound Card : Sound Blaster  or  Ad Lib
Port       : 220   IRQ: 5   DMA: 1
FM Music   : OPL3 / AdLib   port 388 (automatic)
```

> Tyrian requires EMS memory — boot into profile 4 (SoftMPU EMS)

---

### Category 7 — 3dfx Voodoo2 games
**Mixer: per sound category above | Profile: NORMAL (or EMS for DOS4GW titles)**

Voodoo2 uses the Glide 2.x API. Always run the Glide/3dfx executable,
not the software renderer.

| Game | Year | Executable | Sound | SoftMPU | EMS |
|---|---|---|---|---|---|
| Quake | 1996 | GLQUAKE.EXE | SB16 | No | No |
| Quake 2 | 1997 | QUAKE2.EXE (GL version) | SB16 | No | No |
| Tomb Raider 2 | 1997 | TOMBRAID.EXE (Glide) | SB16 | No | No |
| Unreal | 1998 | UNREAL.EXE /glide | SB16 | No | **Yes** |
| Turok Dinosaur Hunter | 1997 | TUROK.EXE (Glide) | SB16 | No | No |
| Forsaken | 1998 | Glide version | SB16 | No | No |
| Carmageddon | 1997 | Glide version | SB16 | No | No |
| Need for Speed 2 SE | 1997 | Glide version | SB16 | No | No |
| Need for Speed 3 | 1998 | Glide version | SB16 | No | No |
| Interstate '76 | 1997 | Glide version | SB16 GM | No | No |
| Motorhead | 1998 | Glide version | SB16 | No | No |

```bat
REM Glide 2.x must be in game directory or PATH
REM (glide2x.ovl version 2.53 or 2.54)

REM Quake - GLQuake Voodoo2 (optimal settings):
REM -width 800 -height 600  = max resolution for single Voodoo2
REM -bpp 16                 = only supported color depth (hardware limit)
REM -nolan                  = disable Windows networking init (faster start, single player)
GLQUAKE.EXE -width 800 -height 600 -bpp 16 -nolan

REM id1\autoexec.cfg — quality tweaks (no FPS cost on Voodoo2):
REM   gl_texturemode GL_LINEAR_MIPMAP_LINEAR   (trilinear filtering)
REM   gl_picmip 0                              (full texture resolution)
REM   r_shadows 0                              (software shadows = CPU cost, disable)

REM Quake 2:
QUAKE2.EXE +set vid_ref gl
```

---

### Quick reference — QX1222USB fader positions

| Game / category | CH 3+4 MT-32 | CH 5+6 SC-55 | CH 9+10 PicoGUS | CH 11+12 AWE32 | AWEUTIL before game |
|---|---|---|---|---|---|
| MT-32 games | **UP** | down | down | up (effects) | — |
| GM/GS games — SC-55 | down | **UP** | down | up (effects) | — |
| GUS games (Doom, Duke3D) | down | down | **UP** | up (effects) | — |
| AWE32 native games | down | down | down | **UP** (all) | `/S` already in AUTOEXEC |
| GM/GS — McCake SF2 | down | down | **UP** | up (effects) | — |
| GM/GS — AWEUTIL /EM:GS | down | down | down | **UP** (all) | `LH AWEUTIL.COM /EM:GS` |
| OPL3/AdLib only | down | down | down | **UP** (all) | — |

### Quick reference — MIDI port

| Target device | Port | When to use |
|---|---|---|
| MT-32 (+ SC-55 after it) | **330h** | MT-32 games, GM games with SC-55 |
| McCake (WP32) via PicoGUS | **300h** | GM games via SF2 soundfont (without SC-55) |
| EMU8000 AWEUTIL emulation | **330h** | AWEUTIL /EM:GM, AWE32 native games |

### Switching SC-55 mode

```bat
REM GM mode (for General MIDI games):
DOSMID /mpu=330 /preset=GM /nosound /dontstop

REM GS mode (default, for GS games — C&C, LucasArts):
DOSMID /mpu=330 /preset=GS /nosound /dontstop
```

> SC-55 MT-32 mode is switched via the physical button on the front panel only.
> MT-32 must be first in MIDI chain — SC-55 receives data via MT-32 THRU.

---

## Memory Map (after optimization)

| Type | Total | Used | Free |
|---|---|---|---|
| Conventional | 640 KB | 33 KB | **607 KB** |
| Upper (UMB) | 138 KB | 98 KB | 40 KB |
| Extended (XMS) | 65,336 KB | 2,356 KB | 62,980 KB |

### UMB Contents

| Driver | Size | Location |
|---|---|---|
| SSCDROM.SYS | 28 KB | UMB |
| MSCDEX.EXE | 35 KB | UMB |
| SMARTDRV.EXE | 28 KB | UMB |
| CTMOUSE.EXE | 3 KB | UMB |
| UNISOUND.COM | 0 KB TSR | exits after init |

---

## Driver Locations

| Driver / File | Path |
|---|---|
| HIMEM.SYS | C:\DOS\HIMEM.SYS |
| EMM386.EXE | C:\DOS\EMM386.EXE |
| SMARTDRV.EXE | C:\DOS\SMARTDRV.EXE |
| MSCDEX.EXE | C:\DOS\MSCDEX.EXE |
| SSCDROM.SYS | C:\DRIVERS\SAMSUNG\SSCDROM.SYS |
| UNISOUND.COM | C:\DRIVERS\UNISOUND\UNISOUND.COM |
| AWEUTIL.COM | C:\DRIVERS\SB16\AWEUTIL.COM |
| Synthgm.sbk | C:\DRIVERS\SB16\Synthgm.sbk |
| Synthgs.sbk | C:\DRIVERS\SB16\Synthgs.sbk |
| Synthmt.sbk | C:\DRIVERS\SB16\Synthmt.sbk |
| SOFTMPU.EXE | C:\DRIVERS\SOFTMPU\SOFTMPU.EXE |
| PGUSINIT.EXE | C:\DRIVERS\PICOGUS\PGUSINIT.EXE |
| DOSMID.EXE | C:\DRIVERS\PICOGUS\DOSMID.EXE |
| DOSMID.CFG | C:\DRIVERS\PICOGUS\DOSMID.CFG |
| Slot1-7.mid | C:\DRIVERS\PICOGUS\Slot1.mid ... Slot7.mid |
| Next/Previous.mid | C:\DRIVERS\PICOGUS\Next.mid, Previous.mid |
| GUS software | C:\DRIVERS\PICOGUS\ (from picog.us/ultrasnd.zip) |
| GUS MIDI patches | C:\DRIVERS\PICOGUS\MIDI\ |
| ULTRAMID.EXE | C:\DRIVERS\PICOGUS\ULTRAMID.EXE |
| GUS.BAT | C:\TOOLS\GUS.BAT |
| CTMOUSE.EXE | C:\DRIVERS\CTMOUSE\CTMOUSE.EXE |

---

## Video

| Feature | Detail |
|---|---|
| 2D card | ATI MACH64 (Rage Pro Turbo PCI) |
| VESA | Native VESA 3.00 — UNIVBE not needed |
| 3D card | 3dfx Voodoo2 (PCI) |
| Voodoo2 frame buffer | 4 MB |
| Voodoo2 texture memory | 8 MB (2× TMU × 4 MB) |
| Voodoo2 max resolution | **800×600×16-bit** (single card) |
| Voodoo2 color depth | **16-bit only** — hardware limitation, 32-bit not supported |
| Voodoo2 SLI | Not present (Scanline Interleave: Not Detected) |
| WinGlide driver | 2.56.00.0459 (latest official 3Dfx) |
| DOS 3D API | Glide 2.x (glide2x.ovl v2.53 or 2.54) |

### Voodoo2 — hardware limits

- **Color depth** — 16-bit only in 3D. `-bpp 32` will crash or silently fall back to 16-bit.
- **Max resolution** — 800×600 with single card. 1024×768 requires SLI (two cards).
- **Performance** — Pentium MMX 200MHz is CPU-bound, not GPU-bound. 640×480 and 800×600 give nearly identical FPS in GLQuake — always use 800×600 for better image quality at no cost.
- **Frame buffer** — 4MB is tight for 800×600 with Z-buffer. For later Glide games (Tomb Raider 2, Unreal) 640×480 may be more stable if you encounter crashes or visual artefacts.

---

## Key Notes

- **HIGHSCAN** must NOT be used — Award BIOS 4.51PG freezes at boot
- **NOEMS** = more UMB space (profiles 1+3), **RAM** = EMS for DOS extender games (profiles 2+4)
- **UNISOUND** replaces all Creative drivers (CTCM, DIAGNOSE, MIXERSET)
- **AWEUTIL /S** initializes EMU8000 — required in addition to UNISOUND for full AWE32 features
- **MEMMAKER** must NOT be run — corrupts manual config
- **CT3900 has real OPL3** (CT1747 chip) — AWE64 used CQM emulation
- **CT3900 is semi-PnP**: I/O address and MPU-401 = jumpers; IRQ and DMA = software (UNISOUND)
- IRQ/DMA change: update BLASTER in AUTOEXEC.BAT, UNISOUND programs card at boot (IRQ: 2/5/7/10, Low DMA: 0/1/3, High DMA: 5/6/7)
- **AWEUTIL /EM:* conflicts with SoftMPU** — use profile 1 (NOSOFTMPU) for AWEUTIL emulation
- AWE32 MPU-401 → port 330h → MT-32 → SC-55 chain
- PicoGUS MPU-401 → port 300h → McCake (WP32) — SF2 soundfonty, GM hry
- LPT1 disabled in BIOS to free IRQ 7 for PicoGUS
- MT-32 must be first in MIDI chain, SC-55 on MT-32 MIDI THRU
- CTMOUSE /R2 = horizontal resolution 2, COM port auto-detected
- ULTRADIR must point to C:\DRIVERS\PICOGUS root (not MIDI subfolder)
- CT3900 IDE port must be DISABLED (JP2+JP3 closed) — conflicts with motherboard IDE
- CT3900 SIMM slots: both must be populated simultaneously with identical modules
- **ULTRAMID.EXE** required for Tyrian and Raptor GUS music — use `GUS.BAT` launcher, not AUTOEXEC
- **McCake power** — from waveblaster header (PicoGUS) or floppy connector

---

## DreamBlaster X16GS — Alternative (module currently under repair)

> ⚠️ X16GS was replaced by McCake due to a hardware defect (digital crackling when
> playing 2 or more notes simultaneously). This section is preserved in case the module
> is returned after repair or replacement.

### What it is

DreamBlaster X16GS is a waveblaster daughterboard by Serdaco with a Dream SAM5716B chip
with a preloaded licensed Roland GS bank. Plugs into the PicoGUS waveblaster header
just like McCake.

### Preloaded X16GS Banks

| Bank | Content | DIP switch |
|---|---|---|
| **1** | Dream/Roland GS (licensed ROM) | 0001 — default |
| 2 | Dream CleanWave | 0010 |
| 3 | Buran Bank | 0011 |
| 4 | OPL3-FM GM | 0100 |
| 5 | GXSCC Chiptune | 0101 |

### Bank switching (BAT files in C:\DRIVERS\PICOGUS\X16\)

```bat
BANK1.BAT   Bank 1: Roland GS (default)
BANK2.BAT   Bank 2: CleanWave
BANK3.BAT   Bank 3: Buran
BANK4.BAT   Bank 4: OPL3-FM
BANK5.BAT   Bank 5: Chiptune
BANKNEXT.BAT  Next bank
BANKPREV.BAT  Previous bank
```

### pgusinit settings for X16GS

```bat
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 300 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
```

### Reporting the defect to Serdaco

Description for support (serdashop.com/Contact or VOGONS user `dreamblaster`):

> X16GS digital noise/crackling when playing 2 or more notes simultaneously.
> Single notes play perfectly clean. Tested via USB-MIDI from modern PC,
> direct 3.5mm jack output, all soundbank slots, all presets.
> Problem is consistent and reproducible.
