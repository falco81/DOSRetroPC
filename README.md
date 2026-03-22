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
| GUS / MIDI Card | PicoGUS v2.0 + DreamBlaster X16GS | ISA |
| CD-ROM | Samsung (SSCDROM.SYS) | IDE |
| Mouse | Serial mouse, auto-detected by CTMOUSE | COM2 |
| BIOS | Award Modular BIOS v4.51PG (09/18/97) | — |
| MIDI module 1 | Roland MT-32 | MIDI chain (first) |
| MIDI module 2 | Roland SC-55 | MIDI chain (THRU from MT-32) |

---

## AWE64 CT4380 → AWE32 CT3900 Upgrade Guide

### Why upgrade?

| Feature | AWE64 CT4380 | AWE32 CT3900 |
|---|---|---|
| OPL3 FM | CQM emulation (fake) | **Real OPL3** (CT1747 w/ Yamaha license) |
| CSP/ASP chip | Not supported | CT1748A included |
| Waveblaster header | Not present | Present |
| RAM expansion | Proprietary only | Standard 30-pin SIMM slots |
| PnP | Yes (needs CTCM) | **No PnP — jumpers only** (simpler for DOS) |
| Hanging notes bug | Not present | Not present (CT1747) |
| EMU8000 synth | Yes, 512KB | Yes, 512KB |
| Polyphony | 64 voices | 32 voices |

The real OPL3 chip is the main reason for the upgrade — AdLib/FM games sound
exactly as intended, not through CQM emulation which has a harsher, more
metallic character.

### Before you start

- Back up CONFIG.SYS and AUTOEXEC.BAT
- Note all current jumper settings on AWE64 for reference
- Prepare a grounded workspace (antistatic mat or wrist strap)
- Have a Phillips screwdriver ready

### CT3900 Jumper Settings for this system

**Audio I/O Address:**
```
JP17=Closed, JP18=Closed  →  port 220h
```

**MPU-401:**
```
JP15=Closed  →  MPU-401 enabled
JP16=Closed  →  port 330h
```

**Joystick:**
```
JP14=Closed  →  enabled (gameport for MT-32/SC-55 MIDI out)
```

**IDE port — DISABLE (conflicts with motherboard IDE):**
```
JP2=Closed, JP3=Closed  →  IDE Disabled
```

**IDE IRQ — irrelevant when IDE is disabled, leave default:**
```
JP6=Closed  →  IRQ 11 (default, harmless when IDE disabled)
```

**CSP chip:**
```
If CT1748A chip is present:  APSD=Open,   IFSD=Open   →  Enabled
If CT1748A chip is absent:   APSD=Closed, IFSD=Closed →  Disabled
```

**DRAM (SIMM slots):**
```
Without SIMMs:  JP2 Pins 2&3 closed  →  Memory upgrade disabled
With SIMMs:     JP2 Pins 1&2 closed  →  Memory upgrade enabled
```

### SIMM Memory Upgrade

CT3900 has two 30-pin SIMM slots. Both slots must be populated simultaneously
(they form one bank). Always use identical modules in both slots.

**Required spec:** 30-pin SIMM, FPM (Fast Page Mode), 80ns or faster, 5V

| Configuration | Total RAM | Notes |
|---|---|---|
| No SIMMs | 512 KB | factory default |
| 2× 1MB SIMM | 2.5 MB | basic |
| **2× 4MB SIMM** | **8.5 MB** | **installed — odemkne GS/MT-32 emulaci a SoundFont editing** |
| 2× 16MB SIMM | 28.5 MB | maximum — 16MB 30-pin jsou vzácné a drahé |

**Instalované moduly: 2× 4MB 30-pin FPM SIMM**
Jumper JP2 pins 1&2 closed (Memory upgrade enabled).

**SIMMs záloha (vlastníš, 30-pin FPM kompatibilní):**

| Chips on module | Brand | Speed | Size | Poznámka |
|---|---|---|---|---|
| GM71C4400BJ70 | Goldstar | 70ns | 1MB | použitelné |
| KM41C1000CJ-6 | Samsung | 60ns | 1MB | nejrychlejší z trojice |
| HM511000AJP7 | Hitachi | 70ns | 1MB | použitelné |

### Co odemknou SIMM moduly (8,5 MB)

S 8 MB SIMM RAM jsou dostupné plné AWE32 funkce v DOS:

**AWEUTIL — EMU8000 MIDI emulace:**
```bat
AWEUTIL /EM:GM   ← General MIDI emulace (soubory Synthgm.sbk)
AWEUTIL /EM:GS   ← General Sound / Roland GS (Synthgs.sbk)
AWEUTIL /EM:MT32 ← Roland MT-32 emulace (Synthmt.sbk)
AWEUTIL /U       ← uvolnit z paměti
```

> AWEUTIL funguje pouze v real mode — nefunguje s DOS extendery
> (DOS4GW, DOS32A). Pro extender hry (Doom, Quake) použij GUS nebo
> externí MIDI moduly. AWEUTIL také nemůže emulovat MPU-401 intelligent
> mode — proto SoftMPU zůstává.

**SoundFont loading (DOS):**
Soundfonty lze nahrávat přes AWEUTIL i v DOS — soubory .SBK (starší
formát, kompatibilní s EMU8000). Moderní .SF2 fonty vyžadují konverzi.

**Maximální velikost SoundFontu:** 28 MB (limit EMU8000 sběrnice,
bez ohledu na kolik RAM je nainstalováno).

### Installation steps

1. Power off PC, unplug power cable
2. Remove AWE64 from ISA slot
3. Set all jumpers on CT3900 as listed above
4. Install SIMMs if upgrading (both slots, same modules)
5. Insert CT3900 into ISA slot (same slot as AWE64)
6. Secure bracket screw
7. Connect MT-32/SC-55 MIDI chain to gameport (same as before)
8. Power on — no driver changes needed, UNISOUND handles CT3900 automatically

### CT3900 — Semi-PnP konfigurace (důležité!)

CT3900 je **semi-PnP** karta — kombinace jumperů a softwarového nastavení:

| Parametr | Metoda nastavení |
|---|---|
| I/O adresa (220/240/260/280h) | **Jumper** (IOS0, IOS1) |
| MPU-401 adresa (300/330h) | **Jumper** (MSEL) |
| CD-ROM port | **Jumper** |
| **IRQ** | **Software** — DIAGNOSE.EXE /S nebo UNISOUND |
| **Low DMA (8-bit)** | **Software** — DIAGNOSE.EXE /S nebo UNISOUND |
| **High DMA (16-bit)** | **Software** — DIAGNOSE.EXE /S nebo UNISOUND |

**Jak to funguje:** DIAGNOSE.EXE /S přečte proměnnou BLASTER a naprogramuje kartu
podle ní. UNISOUND dělá totéž automaticky při každém bootu — proto u nás
není DIAGNOSE.EXE potřeba.

**Dostupné hodnoty (software-konfigurovatelné):**
```
IRQ:      2, 5, 7, 10
Low DMA:  0, 1, 3
High DMA: 5, 6, 7
```

Pokud by nastal IRQ/DMA konflikt s jinou kartou, stačí upravit BLASTER
proměnnou v AUTOEXEC.BAT a UNISOUND to při příštím bootu naprogramuje do karty.

### Software changes after swap

**None required.** UNISOUND.COM initializes CT3900 automatically.
The BLASTER environment variable remains exactly the same:
```
SET BLASTER=A220 I5 D1 H5 P330 E620 T6
```

CT3900 is non-PnP — no CTCM.EXE needed (UNISOUND replaces it).
IRQ 5, DMA 1/5 are default values and match our system perfectly.

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
MENUITEM=NORMAL,  1) Normal          - NOEMS 607KB
MENUITEM=EMS,     2) EMS/Games       - RAM   595KB (DOS extenders, old games)
MENUITEM=BARE,    3) Bare DOS        - no drivers
; Default profile if no key is pressed within timeout
MENUDEFAULT=NORMAL,10
; Menu colors: text color 11 (bright cyan), background 1 (blue)
MENUCOLOR=11,1

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
; Profile 1: NORMAL - NOEMS (max UMB space, 607KB conventional)
; Use for: everyday DOS, Norton Commander, GUS games, MIDI
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
; Profile 2: EMS/GAMES - RAM mode (EMS enabled, 595KB conventional)
; Use for: DOS extender games (Tyrian, etc.), programs requiring EMS memory
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
; Profile 3: BARE DOS - minimal (diagnostics, installation)
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
PATH C:\DOS;C:\NC;C:\TOOLS\NU

REM --- Environment variables ---
SET SYMANTEC=C:\SYMANTEC
SET NU=C:\TOOLS\NU
SET TEMP=C:\DOS\TMP
SET TMP=C:\DOS\TMP
SET TELIX=C:\TOOLS\TELIX

REM --- AWE32 CT3900 settings ---
REM A220=SB16 port, I5=IRQ, D1=DMA 8bit, H5=DMA 16bit
REM P330=MPU-401 port (MT-32/SC-55 chain), E620=EMU8000, T6=SB16/AWE type
SET SOUND=C:\DRIVERS\SB16
SET BLASTER=A220 I5 D1 H5 P330 E620 T6
SET MIDI=SYNTH:1 MAP:E MODE:0

REM --- PicoGUS / Gravis UltraSound settings (uncomment after card is installed) ---
REM Format: port,DMA play,DMA rec,IRQ play,IRQ rec (DMA and IRQ are repeated)
REM IRQ 7 = LPT1 must be disabled in BIOS to free this IRQ
REM SET ULTRASND=240,3,3,7,7
REM ULTRADIR must point to the GUS software root (not the MIDI subfolder)
REM SET ULTRADIR=C:\DRIVERS\PICOGUS

REM --- Route to profile-specific section ---
GOTO %CONFIG%

REM -----------------------------------------------
REM Profile 1: NORMAL
REM -----------------------------------------------
:NORMAL
REM --- AWE32 CT3900 initialization (UNISOUND) ---
REM Inicializace hardware: IRQ, DMA, porty, OPL3, mixer
REM CT3900 semi-PnP: UNISOUND naprogramuje IRQ/DMA dle BLASTER proměnné
REM /V70 = master volume 70 (range 0-100)
REM /VF90 = FM/OPL3 volume 90 - real OPL3 chip na CT3900 (CT1747)
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90

REM --- AWEUTIL - inicializace EMU8000 wavetable syntezátoru ---
REM UNISOUND NEŘEŠÍ EMU8000 - AWEUTIL je nutný pro AWE32 wavetable funkce
REM /S = inicializace EMU8000 dle BLASTER proměnné (E620 = port EMU8000)
REM Nutný pro: hry s AWE32 podporou, AWEUTIL /EM:GM/GS/MT32 MIDI emulaci
REM Soubory: C:\DRIVERS\SB16\AWEUTIL.EXE + Synthgm.sbk + Synthgs.sbk + Synthmt.sbk
AWEUTIL /S

REM --- SoftMPU - intelligent mode MPU-401 emulace pro MT-32 hry ---
REM Nutný pro: Monkey Island 1, Sierra hry, Ultima Underworld
REM AWE32 podporuje pouze UART mode - SoftMPU přidá intelligent mode
REM /MPU:330 = MPU-401 port (musí odpovídat P330 v BLASTER)
LH C:\DRIVERS\SOFTMPU\SOFTMPU.EXE /MPU:330

REM --- PicoGUS initialization (uncomment after card is installed) ---
REM /mode gus    = Gravis UltraSound emulation
REM /mpuport 300 = MPU-401 on port 300h (AWE32 uses 330h - must not conflict)
REM /v 95        = DreamBlaster X16GS wavetable volume (0-100)
REM C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 300 /v 95

REM --- CD-ROM ---
REM /M:10 = 10 sector lookahead cache in extended memory
LH C:\DOS\MSCDEX.EXE /D:SSCD000 /M:10

REM --- Mouse ---
REM /R2 = horizontal resolution 2 (movement sensitivity)
REM COM port is auto-detected by CTMOUSE
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END

REM -----------------------------------------------
REM Profile 2: EMS/GAMES
REM -----------------------------------------------
:EMS
REM --- AWE32 CT3900 initialization (UNISOUND) ---
REM /V70 = master volume 70, /VF90 = FM/OPL3 volume 90
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90

REM --- AWEUTIL - inicializace EMU8000 wavetable syntezátoru ---
REM Pozor: AWEUTIL /EM:* NEFUNGUJE s DOS extendery (DOS4GW) - pouze /S init
AWEUTIL /S

REM --- SoftMPU - intelligent mode MPU-401 emulace ---
REM /MPU:330 = MPU-401 port (musí odpovídat P330 v BLASTER)
LH C:\DRIVERS\SOFTMPU\SOFTMPU.EXE /MPU:330

REM --- PicoGUS initialization (uncomment after card is installed) ---
REM /mode gus    = Gravis UltraSound emulation
REM /mpuport 300 = MPU-401 on port 300h (AWE32 uses 330h - must not conflict)
REM /v 95        = DreamBlaster X16GS wavetable volume (0-100)
REM C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 300 /v 95

REM --- CD-ROM ---
REM /M:10 = 10 sector lookahead cache in extended memory
LH C:\DOS\MSCDEX.EXE /D:SSCD000 /M:10

REM --- Mouse ---
REM /R2 = horizontal resolution 2 (movement sensitivity)
REM COM port is auto-detected by CTMOUSE
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END

REM -----------------------------------------------
REM Profile 3: BARE DOS
REM -----------------------------------------------
:BARE
REM --- No drivers loaded in bare mode ---
GOTO END

:END
REM --- Norton Commander ---
NC
```

---

## Audio Routing

```
AWE32 line out   ──► Mixer CH1  (SB16 effects + real OPL3 FM music)
PicoGUS line out ──► Mixer CH2  (GUS music + X16GS Roland GS synth)
MT-32 line out   ──► Mixer CH3  (Roland MT-32 synth)
SC-55 line out   ──► Mixer CH4  (Roland SC-55 GS synth)
                          │
                     Hardware mixer main out
                          │
                    Speakers / headphones
```

> X16GS audio is routed back through the waveblaster header into PicoGUS
> and mixed with GUS audio — only one cable needed from PicoGUS line out.

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

### Mixer Channel Labels

| Channel | Source | Used for |
|---|---|---|
| CH1 | AWE32 | SB16 effects, real OPL3 FM music |
| CH2 | PicoGUS | GUS music, X16GS MIDI synth |
| CH3 | MT-32 | MT-32 music (Sierra, early LucasArts) |
| CH4 | SC-55 | GM/GS music (best quality external) |

---

## Sound Device Reference

| Device | Port | IRQ | DMA | Type |
|---|---|---|---|---|
| AWE32 SB16 | 220h | 5 | 1 / 5 | Sound effects, real OPL3 |
| AWE32 MPU-401 | 330h | 5 | — | MIDI out → MT-32 → SC-55 |
| PicoGUS GUS | 240h | 7 | 3 | GUS music |
| PicoGUS MPU-401 | 300h | 7 | — | MIDI → X16GS internal synth |

---

## DreamBlaster X16GS — Soundbanks and Bank Switching

### Preloaded Banks

| Bank | Name | Best used for |
|---|---|---|
| 1 | Dream/Roland GS Bank (licensed ROM) | GM/GS games, SC-55 replacement |
| 2 | Dream CleanWave Bank | General purpose GM |
| 3 | Buran Bank | Variety, alternative character |
| 4 | OPL3-FM General MIDI | Retro FM feel |
| 5 | GXSCC Chiptune | 8-bit / NES/SNES style |

### Bank switching commands

```bat
REM Switch to specific bank (DOSMID.CFG default: /mpu=300 /preset=GS /dontstop)
DOSMID Slot1.mid   ← Bank 1: Roland GS (default, best for games)
DOSMID Slot2.mid   ← Bank 2: CleanWave
DOSMID Slot3.mid   ← Bank 3: Buran
DOSMID Slot4.mid   ← Bank 4: OPL3-FM character
DOSMID Slot5.mid   ← Bank 5: Chiptune
DOSMID Next.mid    ← Next bank
DOSMID Previous.mid ← Previous bank
```

---

## AWEUTIL — EMU8000 Wavetable Synthesizer

### UNISOUND vs AWEUTIL — co dělá co

| Funkce | UNISOUND | AWEUTIL |
|---|---|---|
| Inicializace hardware (IRQ, DMA, porty) | **Ano** | Ne |
| OPL3 FM syntéza | **Ano** | Ne |
| Mixer (volume, balance) | **Ano** | Ne |
| EMU8000 wavetable init | Ne | **Ano** |
| MIDI emulace GM/GS/MT-32 | Ne | **Ano** |
| Načítání soundfontů (.SBK) | Ne | **Ano** |
| Reverb a chorus efekty | Ne | **Ano** (přes CT1747) |

**UNISOUND nestačí pro plné AWE32 funkce.** Pro wavetable syntézu a MIDI
emulaci přes EMU8000 je nutný AWEUTIL.

### Soubory potřebné pro AWEUTIL

Všechny soubory patří do `C:\DRIVERS\SB16\` (nebo kam ukazuje `SET SOUND=`):

| Soubor | Účel |
|---|---|
| `AWEUTIL.EXE` | Hlavní utility — init, MIDI emulace, soundfonty |
| `Synthgm.sbk` | GM soundfont (nutný pro `/EM:GM`) |
| `Synthgs.sbk` | GS soundfont (nutný pro `/EM:GS`) |
| `Synthmt.sbk` | MT-32 soundfont (nutný pro `/EM:MT32`) |

Stažení: Creative AWE32 driver package v2.0 obsahuje všechny tyto soubory.
Hledej `AWE32DRV.ZIP` nebo `SB16AWE32_DOS.ZIP` na archive.org nebo vogons.org.

### AWEUTIL příkazy

```bat
AWEUTIL /S              ← inicializace EMU8000 (čte BLASTER proměnnou)
                           spustit po UNISOUND při každém bootu

AWEUTIL /EM:GM          ← General MIDI emulace (Synthgm.sbk)
AWEUTIL /EM:GS          ← Roland GS emulace (Synthgs.sbk)
AWEUTIL /EM:MT32        ← Roland MT-32 emulace (Synthmt.sbk)
AWEUTIL /U              ← uvolnit z paměti (před přepnutím módu)

AWEUTIL /SF:myfont.sbk  ← načíst vlastní soundfont
AWEUTIL /R:0            ← Reverb off
AWEUTIL /R:5            ← Reverb level 5 (0-7)
AWEUTIL /C:0            ← Chorus off
AWEUTIL /C:3            ← Chorus level 3 (0-7)
```

### Kdy použít AWEUTIL /EM vs. SC-55 nebo MT-32

| Situace | Doporučení |
|---|---|
| Hra má nativní "AWE32" volbu v setupu | AWEUTIL /S, v setupu zvolit AWE32 |
| Hra má GM, nemáš připojený SC-55 | AWEUTIL /EM:GM nebo X16GS |
| Chceš MT-32 zvuk bez fyzického MT-32 | AWEUTIL /EM:MT32 (horší než real HW) |
| Máš SC-55 připojený | SC-55 >> AWEUTIL /EM:GS (SC-55 je lepší) |
| Máš MT-32 připojený | MT-32 >> AWEUTIL /EM:MT32 (real HW vždy lepší) |

**Omezení AWEUTIL:**
- Nefunguje s DOS extendery (DOS4GW, DOS32A) — hry jako Doom, Quake, Duke3D
- Nemůže emulovat MPU-401 intelligent mode (proto SoftMPU zůstává)
- Protected mode software nepodporuje MIDI emulaci

### AWEUTIL v AUTOEXEC.BAT

```bat
REM Pořadí musí být: UNISOUND → AWEUTIL /S
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90
LH C:\DRIVERS\SOFTMPU\SOFTMPU.EXE /MPU:330
AWEUTIL /S
REM Volitelně — výchozí MIDI emulace při bootu:
REM AWEUTIL /EM:GS
```

> AWEUTIL /EM se typicky spouští ručně před konkrétní hrou, ne při bootu,
> protože různé hry potřebují různé módy. Při přepínání vždy nejdřív
> AWEUTIL /U, pak AWEUTIL /EM:nový.

### Hry s nativní AWE32 podporou (AWEUTIL /S stačí)

V setupu tyto hry nabízí volbu "Sound Blaster AWE32" nebo "AWE32":
Civilization 2, Master of Orion 2, Warcraft 2, Starcraft (beta DOS verze),
FIFA Soccer 95/96/97, NHL series, Need for Speed (DOS).
Setup: zvolit AWE32, port 220, IRQ 5, DMA 1, DMA16 5.

---

## Game Setup Guide

### Priorita zvukových zařízení — obecné pravidlo

```
Real MT-32 hardware  >  Real SC-55 hardware  >  PicoGUS GUS  >  X16GS  >  AWEUTIL EMU8000  >  OPL3
```

Fyzický hardware vždy zní lépe než emulace. GUS má ve svých hrách
výjimečnou kvalitu díky vzorkovým patchům. OPL3 je záměrný retro zvuk.

---

### Kategorie 1 — MT-32 hry
**Mixer: CH1 (AWE32 efekty) + CH3 (MT-32) | SoftMPU aktivní**

Tyto hry byly komponovány přímo pro Roland MT-32. SC-55 ani GM emulace
nezní správně — chybí specifické MT-32 timbre sady a SysEx nastavení.

**Sierra On-Line:**

| Hra | Rok | Setup |
|---|---|---|
| King's Quest 4 | 1988 | Music: Roland MT-32, port 330 |
| King's Quest 5 | 1990 | Music: Roland MT-32 or MIDI, port 330 |
| Space Quest 3 | 1989 | Music: Roland MT-32, port 330 |
| Space Quest 4 | 1991 | Music: Roland MT-32 or MIDI, port 330 |
| Police Quest 2 | 1988 | Music: Roland MT-32, port 330 |
| Police Quest 3 | 1991 | Music: Roland MT-32 or MIDI, port 330 |
| Quest for Glory 1 (EGA/VGA) | 1989/1992 | Music: Roland MT-32, port 330 |
| Quest for Glory 2 | 1990 | Music: Roland MT-32, port 330 |
| Leisure Suit Larry 3 | 1989 | Music: Roland MT-32, port 330 |
| Leisure Suit Larry 5 | 1991 | Music: Roland MT-32 or MIDI, port 330 |
| Gabriel Knight 1 | 1993 | Music: Roland MT-32 or General MIDI |
| Conquests of Camelot | 1990 | Music: Roland MT-32, port 330 |
| Conquests of Longbow | 1991 | Music: Roland MT-32, port 330 |

**LucasArts (floppy verze — CD verze mají GM):**

| Hra | Rok | Poznámka |
|---|---|---|
| Maniac Mansion | 1987 | Music: Roland MT-32 |
| Zak McKracken | 1988 | Music: Roland MT-32 |
| Indiana Jones Last Crusade | 1989 | Music: Roland MT-32 — SoftMPU nutný (intelligent mode) |
| Loom (floppy) | 1990 | Music: Roland MT-32 — SoftMPU nutný |
| Monkey Island 1 (floppy) | 1990 | Music: Roland MT-32 — SoftMPU nutný |
| Monkey Island 2 | 1991 | MT-32 nebo GM — GM na SC-55 zní skvěle |

**Origin / Wing Commander:**

| Hra | Rok | Setup |
|---|---|---|
| Wing Commander 1 | 1990 | Music: Roland MT-32, port 330, Sound: SB |
| Wing Commander 2 | 1991 | Music: Roland MT-32, port 330, Sound: SB |
| Ultima VI | 1990 | Music: Roland MT-32, port 330 |
| Ultima Underworld 1 | 1992 | Music: General MIDI (SC-55) — SoftMPU nutný |

**SSI / Westwood (dungeon/RPG):**

| Hra | Rok | Setup |
|---|---|---|
| Eye of the Beholder 1 | 1991 | Music: Roland MT-32, port 330 |
| Eye of the Beholder 2 | 1991 | Music: Roland MT-32, port 330 |
| Pool of Radiance | 1988 | Music: Roland MT-32 |
| Champions of Krynn | 1990 | Music: Roland MT-32 |

```
Sound Effects : Sound Blaster   port 220  IRQ 5  DMA 1
Music         : Roland MT-32
MIDI port     : 330
```

> SoftMPU je načten v AUTOEXEC — intelligent mode funguje automaticky.
> SC-55 je v MIDI chain za MT-32 (THRU) — pro MT-32 hry SC-55 nic nevydává.

---

### Kategorie 2 — GM/GS hry — SC-55
**Mixer: CH1 (AWE32 efekty) + CH4 (SC-55)**

Tyto hry byly komponovány nebo optimalizovány pro Roland SC-55/SC-88.
SC-55 zní autentičtěji než jakákoli emulace — hudba byla většinou mixována
přímo na tomto hardware.

**LucasArts iMUSE engine:**

| Hra | Rok | Setup |
|---|---|---|
| Monkey Island 2 | 1991 | General MIDI, port 330 — iMUSE dynamická hudba |
| Indiana Jones Fate of Atlantis | 1992 | General MIDI, port 330 |
| Day of the Tentacle | 1993 | General MIDI, port 330 — iMUSE |
| Sam & Max Hit the Road | 1993 | General MIDI, port 330 — iMUSE |
| Dark Forces | 1995 | General MIDI, port 330 — iMUSE |
| Full Throttle | 1995 | General MIDI, port 330 — iMUSE |
| The Dig | 1995 | General MIDI, port 330 — iMUSE |
| Grim Fandango (DOS beta) | 1998 | General MIDI, port 330 |

**Westwood Studios:**

| Hra | Rok | Setup |
|---|---|---|
| Legend of Kyrandia 1 | 1992 | General MIDI, port 330 |
| Legend of Kyrandia 2 | 1993 | General MIDI, port 330 |
| Legend of Kyrandia 3 | 1994 | General MIDI, port 330 |
| Command & Conquer | 1995 | General MIDI, port 330 — SC-55 zní skvěle |
| Red Alert | 1996 | General MIDI, port 330 |

**Origin Systems:**

| Hra | Rok | Setup |
|---|---|---|
| Wing Commander 3 | 1994 | General MIDI, port 330, Sound: SB16 |
| Wing Commander 4 | 1996 | General MIDI, port 330, Sound: SB16 |
| Privateer | 1993 | General MIDI, port 330, Sound: SB |
| Ultima Underworld 1 | 1992 | General MIDI, port 330, Sound: SB16 |
| Ultima Underworld 2 | 1993 | General MIDI, port 330, Sound: SB16 |
| Ultima 7 Part 1+2 | 1992/1993 | General MIDI, port 330 |
| Ultima 8 | 1994 | General MIDI, port 330 |

**Microprose / Strategy:**

| Hra | Rok | Setup |
|---|---|---|
| X-COM UFO Defense | 1994 | General MIDI, port 330, Sound: SB16 |
| X-COM Terror from the Deep | 1995 | General MIDI, port 330 |
| Civilization 2 | 1996 | AWE32 nativně nebo GM, port 330 |
| Master of Orion 2 | 1996 | General MIDI, port 330 |

**Ostatní:**

| Hra | Rok | Setup |
|---|---|---|
| Crusader No Remorse | 1995 | General MIDI, port 330, Sound: SB16 |
| Crusader No Regret | 1996 | General MIDI, port 330, Sound: SB16 |
| Descent 1 | 1994 | GM nebo GUS — GUS pro hudbu doporučeno |
| Descent 2 | 1996 | GM nebo GUS — GUS pro hudbu doporučeno |
| TIE Fighter | 1994 | General MIDI, port 330 — iMUSE |
| X-Wing | 1993 | General MIDI, port 330 — iMUSE |
| Warcraft 2 | 1995 | General MIDI nebo AWE32 |

```
Sound Effects : Sound Blaster 16   port 220  IRQ 5  DMA 1
Music         : General MIDI
MIDI port     : 330
```

> SC-55 musí být v GS módu (výchozí). Přepnutí: DOSMID /mpu=330 /preset=GS.
> MT-32 je v MIDI chain před SC-55 (THRU) — MIDI data projdou přes MT-32
> transparentně a přijdou na SC-55.

---

### Kategorie 3 — GUS hry
**Mixer: CH1 (AWE32 efekty) + CH2 (PicoGUS GUS)**

Tyto hry mají nativní Gravis UltraSound podporu s vlastními vzorkovými
patchemi (patch sety). GUS zní v těchto hrách lépe než SB16 díky
wavetable syntéze přímo v hardware — žádná MIDI emulace.

**id Software:**

| Hra | Rok | Sound Effects | Music | GUS nastavení |
|---|---|---|---|---|
| Doom | 1993 | SB port 220 IRQ 5 DMA 1 | Gravis UltraSound | auto-detect nebo ruční |
| Doom 2 | 1994 | SB port 220 IRQ 5 DMA 1 | Gravis UltraSound | auto-detect |
| Heretic | 1994 | SB port 220 IRQ 5 DMA 1 | Gravis UltraSound | auto-detect |
| Hexen | 1995 | SB port 220 IRQ 5 DMA 1 | Gravis UltraSound | auto-detect |
| Quake | 1996 | SB16 port 220 IRQ 5 DMA 1 | CD audio nebo GUS | viz níže |

**Apogee / 3D Realms:**

| Hra | Rok | Sound Effects | Music |
|---|---|---|---|
| Duke Nukem 3D | 1996 | SB16 port 220 IRQ 5 DMA 1 DMA16 5 | GUS port 240 IRQ 7 DMA 3 |
| Shadow Warrior | 1997 | SB16 port 220 IRQ 5 DMA 1 DMA16 5 | GUS port 240 IRQ 7 DMA 3 |
| Blood | 1997 | SB16 port 220 IRQ 5 DMA 1 DMA16 5 | GUS port 240 IRQ 7 DMA 3 |
| Rise of the Triad | 1994 | SB port 220 IRQ 5 DMA 1 | GUS port 240 IRQ 7 DMA 3 |
| Terminal Velocity | 1995 | SB16 port 220 IRQ 5 DMA 1 | GUS port 240 IRQ 7 DMA 3 |

**Ostatní:**

| Hra | Rok | Poznámka |
|---|---|---|
| Strife | 1996 | GUS hudba, SB efekty |
| Descent 1 | 1994 | GUS doporučeno před GM |
| Descent 2 | 1996 | GUS doporučeno před GM |
| Raptor Call of Shadows | 1994 | GUS hudba |
| Blake Stone | 1993 | GUS hudba |

```bat
REM Doom / Doom 2 / Heretic / Hexen:
  Sound Effects : Sound Blaster   port 220  IRQ 5  DMA 1
  Music         : Gravis UltraSound
  (GUS je detekován automaticky přes ULTRASND proměnnou)

REM Duke Nukem 3D / Shadow Warrior / Blood (SETUP.EXE):
  Sound Card    : Sound Blaster 16
  Port          : 220   IRQ: 5   DMA: 1   DMA16: 5
  Music Card    : Gravis UltraSound
  Port          : 240   IRQ: 7   DMA: 3

REM Quake (GLQuake s Voodoo2):
  spustit: GLQUAKE.EXE -width 640 -height 480
  nebo:    GLQUAKE.EXE (výchozí 320x240 Glide)
  Sound: auto-detect SB16
```

---

### Kategorie 4 — AWE32 nativní hry (EMU8000 wavetable)
**Mixer: CH1 (AWE32 efekty + hudba) | AWEUTIL /S aktivní**

Tyto hry mají přímou AWE32 podporu — přistupují k EMU8000 syntezátoru
přímo a nevyžadují MIDI emulaci. AWEUTIL /S musí být spuštěn před hrou.

| Hra | Rok | Setup |
|---|---|---|
| FIFA Soccer 95 | 1994 | AWE32, port 220, IRQ 5, DMA 1 |
| FIFA Soccer 96 | 1995 | AWE32, port 220, IRQ 5, DMA 1 |
| FIFA Soccer 97 | 1996 | AWE32, port 220, IRQ 5, DMA 1 |
| NHL 96/97 | 1995/96 | AWE32, port 220, IRQ 5, DMA 1 |
| Need for Speed (DOS) | 1994 | AWE32 nebo SB16 |
| Warcraft 2 | 1995 | AWE32 nebo General MIDI |
| Civilization 2 | 1996 | AWE32, port 220 |
| Master of Orion 2 | 1996 | AWE32 nebo GM |

```
Sound Card    : Sound Blaster AWE32
Port          : 220   IRQ: 5   DMA: 1   DMA16: 5
EMU8000 Port  : 620
```

> Spustit před hrou: `AWEUTIL /S` (pokud není v AUTOEXEC)
> Pokud hra nabízí GM i AWE32 — AWE32 zní lépe (native wavetable)

---

### Kategorie 5 — GM/GS hry bez externích modulů (X16GS)
**Mixer: CH1 (AWE32 efekty) + CH2 (PicoGUS/X16GS)**

Použij když nechceš přepínat MIDI chain nebo SC-55 není dostupný.
X16GS Bank 1 (Roland GS) zní velmi dobře jako SC-55 náhrada.

```
Sound Effects : Sound Blaster 16   port 220  IRQ 5  DMA 1
Music         : General MIDI
MIDI port     : 300
```

Před spuštěním přepni X16GS na Bank 1 (Roland GS):
```bat
DOSMID Slot1.mid
```

---

### Kategorie 6 — OPL3 / AdLib / FM hry
**Mixer: CH1 (AWE32 real OPL3)**

CT3900 má **reálný Yamaha OPL3** čip (CT1747) — na rozdíl od AWE64
který používal CQM emulaci. Tyto hry zní na CT3900 autenticky správně.

| Hra | Rok | Nejlepší setup |
|---|---|---|
| Wolfenstein 3D | 1992 | AdLib nebo SB, port 220 |
| Commander Keen 4/5/6 | 1991/92 | AdLib port 388 |
| Jazz Jackrabbit | 1994 | SB nebo AdLib, port 220 |
| Raptor Call of Shadows | 1994 | SB nebo AdLib (alternativa ke GUS) |
| Tyrian | 1995 | SB16 port 220 IRQ 5 DMA 1 — EMS profil! |
| Dune 2 | 1992 | AdLib nebo SB |
| Theme Park | 1994 | SB16, port 220 |
| Transport Tycoon | 1994 | SB16, port 220 |
| SimCity 2000 | 1993 | SB16, port 220 |
| Syndicate | 1993 | SB16, port 220 |
| Magic Carpet | 1994 | SB16, port 220, DMA 1 |
| Populous | 1989 | AdLib |
| Lemmings | 1991 | AdLib nebo SB |

```
Sound Card : Sound Blaster  nebo  Ad Lib
Port       : 220   IRQ: 5   DMA: 1
FM Music   : OPL3 / AdLib   port 388 (automaticky)
```

> Tyrian vyžaduje EMS paměť — boot do profilu 2 (EMS/Games)

---

### Kategorie 7 — 3dfx Voodoo2 hry
**Mixer: dle kategorie zvuku výše**

Voodoo2 používá Glide 2.x API. Vždy spouštěj Glide/3dfx verzi spustitelného
souboru, ne softwarový renderer.

| Hra | Rok | Spustitelný soubor | Zvuk |
|---|---|---|---|
| Quake | 1996 | GLQUAKE.EXE | SB16 |
| Quake 2 | 1997 | QUAKE2.EXE (GL verze) | SB16 |
| Tomb Raider 2 | 1997 | TOMBRAID.EXE (Glide) | SB16 |
| Unreal | 1998 | UNREAL.EXE /glide | SB16 |
| Turok Dinosaur Hunter | 1997 | TUROK.EXE (Glide) | SB16 |
| Forsaken | 1998 | Glide verze | SB16 |
| Incoming | 1998 | Glide verze | SB16 |
| Carmageddon | 1997 | Glide verze | SB16 |
| Need for Speed 2 SE | 1997 | Glide verze | SB16 |
| Need for Speed 3 | 1998 | Glide verze | SB16 |
| Interstate '76 | 1997 | Glide verze | SB16 GM |
| Motorhead | 1998 | Glide verze | SB16 |
| GLQuake / WinQuake | 1997 | GLQUAKE.EXE | SB16 |

```bat
REM Glide 2.x musí být v adresáři hry nebo v PATH
REM (glide2x.ovl verze 2.53 nebo 2.54)

REM Quake - GLQuake Voodoo2:
GLQUAKE.EXE -width 640 -height 480 -bpp 16

REM Quake 2:
QUAKE2.EXE +set vid_ref gl

REM Tomb Raider 2 — Glide verze se spouští přímo
TOMBRAID.EXE
```

---

### Quick reference — co zapnout na mixeru

| Hra / kategorie | CH1 AWE32 | CH2 PicoGUS | CH3 MT-32 | CH4 SC-55 |
|---|---|---|---|---|
| MT-32 hry (Sierra, LucasArts floppy) | on (efekty) | off | **ON** | off |
| GM/GS hry — SC-55 | on (efekty) | off | off | **ON** |
| GUS hry (Doom, Duke3D) | on (efekty) | **ON** | off | off |
| AWE32 nativní hry | **ON** (vše) | off | off | off |
| GM/GS — X16GS (bez ext. modulů) | on (efekty) | **ON** | off | off |
| OPL3/AdLib only | **ON** (vše) | off | off | off |

### Quick reference — MIDI port

| Cílové zařízení | Port | Kdy použít |
|---|---|---|
| MT-32 (+ SC-55 za ním) | **330h** | MT-32 hry, GM hry se SC-55 |
| X16GS přes PicoGUS | **300h** | GM/GS hry bez ext. modulů |
| EMU8000 AWEUTIL emulace | **330h** | AWEUTIL /EM:GM, hry s AWE32 podporou |

### Přepnutí SC-55 módu

```bat
REM GM mód (pro General MIDI hry):
DOSMID /mpu=330 /preset=GM /nosound /dontstop

REM GS mód (výchozí, pro GS hry — C&C, LucasArts):
DOSMID /mpu=330 /preset=GS /nosound /dontstop
```

> MT-32 mód SC-55 se přepíná pouze fyzickým tlačítkem na přední straně.
> MT-32 musí být první v MIDI chain — SC-55 přijímá data přes MT-32 THRU.

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

## PicoGUS v2.0 Setup

### Jumper Settings

| Jumper | Setting |
|---|---|
| IRQ | **7** (single jumper on position 7) |
| DMA | **3** (both jumpers marked "3" must be closed) |
| IO port | no jumper — set via PGUSINIT.EXE |

Available IRQ positions on card: 2, 3, 4, 5, 7
Available DMA positions on card: 1 and 3

### GUS Software Installation

Download GUS v4.11 software from: https://picog.us/ultrasnd.zip
Extract contents to C:\DRIVERS\PICOGUS\
MIDI patches will be in C:\DRIVERS\PICOGUS\MIDI\
Place PGUSINIT.EXE in C:\DRIVERS\PICOGUS\

### PGUSINIT.EXE Parameters Used

```
PGUSINIT.EXE /mode gus /mpuport 300 /v 95
```

| Parameter | Meaning |
|---|---|
| /mode gus | Gravis UltraSound emulation |
| /mpuport 300 | MPU-401 on 300h (must differ from AWE32 on 330h) |
| /v 95 | DreamBlaster X16GS wavetable volume (0-100) |

> /save omitted — use only when you want to save settings to PicoGUS flash.
> Run PGUSINIT /? for options of current mode.
> Run PGUSINIT /?? for all modes.

### PicoGUS Emulation Modes

| Mode | GUS | SB | OPL2 | MPU-401 | CD-ROM | Serial mouse |
|---|---|---|---|---|---|---|
| **gus** | Yes | No | No | Yes | No | No |
| sb | No | Yes | Yes | Yes | Yes | No |
| adlib | No | No | Yes | Yes | No | Yes |
| mpu | No | No | No | Yes (IRQ) | No | No |
| usb | No | No | No | Yes | Yes | Yes |

Note: PicoGUS CD-ROM emulation is NOT used — physical Samsung drive is used.

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
| SOFTMPU.EXE | C:\DRIVERS\SOFTMPU\SOFTMPU.EXE |
| PGUSINIT.EXE | C:\DRIVERS\PICOGUS\PGUSINIT.EXE |
| DOSMID.EXE | C:\DRIVERS\PICOGUS\DOSMID.EXE |
| DOSMID.CFG | C:\DRIVERS\PICOGUS\DOSMID.CFG |
| Slot1-7.mid | C:\DRIVERS\PICOGUS\Slot1.mid ... Slot7.mid |
| Next/Previous.mid | C:\DRIVERS\PICOGUS\Next.mid, Previous.mid |
| GUS software | C:\DRIVERS\PICOGUS\ (from picog.us/ultrasnd.zip) |
| GUS MIDI patches | C:\DRIVERS\PICOGUS\MIDI\ |
| CTMOUSE.EXE | C:\DRIVERS\CTMOUSE\CTMOUSE.EXE |

---

## Video

| Feature | Detail |
|---|---|
| 2D card | ATI MACH64 (Rage Pro Turbo PCI) |
| VESA | Native VESA 3.00 — UNIVBE not needed |
| 3D card | 3dfx Voodoo2 (PCI) |
| DOS 3D API | Glide 2.x (glide2x.ovl v2.53 or 2.54) |

---

## Key Notes

- **HIGHSCAN** must NOT be used — Award BIOS 4.51PG freezes at boot
- **NOEMS** = more UMB space (profile 1), **RAM** = EMS for DOS extender games (profile 2)
- **UNISOUND** replaces all Creative drivers (CTCM, DIAGNOSE, AWEUTIL, MIXERSET)
- **MEMMAKER** must NOT be run — corrupts manual config
- **CT3900 has real OPL3** (CT1747 chip) — AWE64 used CQM emulation
- **CT3900 je semi-PnP**: I/O adresa a MPU-401 = jumper; IRQ a DMA = software (DIAGNOSE /S nebo UNISOUND)
- IRQ/DMA změna: upravit BLASTER v AUTOEXEC.BAT, UNISOUND naprogramuje kartu při bootu (IRQ: 2/5/7/10, Low DMA: 0/1/3, High DMA: 5/6/7)
- AWE32 MPU-401 → port 330h → MT-32 → SC-55 chain
- PicoGUS MPU-401 → port 300h → X16GS only
- LPT1 disabled in BIOS to free IRQ 7 for PicoGUS
- MT-32 must be first in MIDI chain, SC-55 on MT-32 MIDI THRU
- CTMOUSE /R2 = horizontal resolution 2, COM port auto-detected
- ULTRADIR must point to C:\DRIVERS\PICOGUS root (not MIDI subfolder)
- CT3900 IDE port must be DISABLED (JP2+JP3 closed) — conflicts with motherboard IDE
- CT3900 SIMM slots: both must be populated simultaneously with identical modules
