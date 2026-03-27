# New Disk Installation Guide
## Verbatim Vi560 256GB — MS-DOS 7.1 + Windows 98SE
### Rhino 15 / Pentium MMX / PIIX4 / AWE32 CT3900

---

## Hardware chain

```
Verbatim Vi560 256GB M.2 SATA III
    ↓ AXAGON RSS-M2SD (M.2 SATA → 2.5" SATA)
    ↓ Ableconn IDE40-SAT (SATA → 40-pin IDE, Marvell 88SA8052)
    ↓ 80-conductor IDE cable
    ↓ Rhino 15 IDE controller (PIIX4, UDMA/33 max)
```

---

## Partition plan

| Drive | Size | Type | Filesystem | Contents |
|---|---|---|---|---|
| C: | 8 GB | Primary | FAT32 | MS-DOS 7.1 system, Windows 98SE, all drivers, tools |
| D: | ~230 GB | Logical | FAT32 | Games + Data |

**Why 8 GB for C:**
The Rhino 15 Award BIOS (09/18/97) detects the disk as 8 GB due to BIOS LBA limits.
C: must lie entirely within that 8 GB window — using the full 8 GB is safe and
gives comfortable space for DOS + Win98SE + all drivers and tools.

D: is inside an Extended partition — Win98SE and DOS 7.1 access it via their own
32-bit drivers that bypass the BIOS limit entirely. Full ~230 GB capacity is
available regardless of what BIOS reports.

---

## Disk layout diagram

```
Verbatim Vi560 238 GB (256 GB nominal)
┌─────────────────────────────────────────────────────┐
│ C: Primary  FAT32  8 GB  [Active]  <- DOS + Win98SE │
├─────────────────────────────────────────────────────┤
│ Extended partition (~230 GB)                        │
│  ┌───────────────────────────────────────────────┐  │
│  │  D:  Logical  FAT32  ~230 GB  <- Games + Data │  │
│  └───────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────┘
```

---

## What you need before starting

- MS-DOS 7.1 CDU bootable ISO (on USB or CD)
- Windows 98SE installation CD
- Old disk (keep connected as secondary or available for file copy)
- 80-conductor IDE cable already installed
- Modern PC with USB port
- USB-to-SATA adapter (e.g. the AXAGON box itself connected via USB)
- MiniTool Partition Wizard Professional 9.1.0 (on modern PC)

---

## Phase 1 — SSD alignment on modern PC (before retro PC install)

> ⚠️ **Do this first, before touching the retro PC.**
> Partitioning on the modern PC ensures correct 4K sector alignment for the SSD.
> If FDISK were used on DOS and MiniTool applied afterwards, it would overwrite
> the boot sector and break the DOS boot — requiring `SYS C:` repair.
> Doing it in this order avoids that problem entirely.

### Step 1 — Connect SSD to modern PC via USB

Connect the full adapter chain to your modern PC via USB:

```
Vi560 M.2 → AXAGON RSS-M2SD → USB cable → modern PC
```

Windows will detect the disk. Do NOT let it auto-format.

### Step 2 — Open MiniTool Partition Wizard 9.1.0

Launch as Administrator.

### Step 3 — Delete all existing partitions

In the disk map, right-click each partition → Delete. Apply.

The disk should show as entirely unallocated.

### Step 4 — Create C: partition (8 GB, Primary, FAT32, aligned)

Right-click the unallocated space → Create:

| Setting | Value |
|---|---|
| Partition Label | SYSTEM |
| File System | FAT32 |
| Size | **8192 MB** |
| Align to | **2048 sectors** (= 1 MB boundary — correct for SSD) |
| Partition Type | **Primary** |

Click OK.

### Step 5 — Create Extended partition (all remaining space)

Right-click the remaining unallocated space → Create:

| Setting | Value |
|---|---|
| File System | **Unformatted** (container only, no filesystem) |
| Size | all remaining (leave default) |
| Align to | **2048 sectors** |
| Partition Type | **Extended** |

Click OK.

### Step 6 — Create D: partition (all logical space, FAT32, aligned)

Right-click the free space inside the Extended partition → Create:

| Setting | Value |
|---|---|
| Partition Label | GAMES |
| File System | FAT32 |
| Size | all remaining (leave default) |
| Align to | **2048 sectors** |
| Partition Type | Logical (automatic — inside Extended) |

Click OK.

### Step 7 — Set C: as Active

Right-click the C: (SYSTEM, 8 GB Primary) partition → Set Active.

### Step 8 — Apply

Click Apply → Yes. MiniTool writes the partition table with correct alignment.

### Step 9 — Disconnect and move to retro PC

Safely eject the disk. Reconnect the full adapter chain to the retro PC
via the 80-conductor IDE cable.

> FDISK is **not needed** — partitions are already created and correctly aligned.

---

## Phase 2 — Format and install MS-DOS 7.1

### Step 10 — Boot from MS-DOS 7.1 CDU ISO

Set BIOS boot order to boot from your CDU media (USB or CD).
Boot to DOS prompt (e.g. `A:\>` or `X:\>`).

### Step 11 — Format both partitions

> Partitions already exist from MiniTool — only FORMAT is needed, not FDISK.

```bat
FORMAT C: /S /V:SYSTEM
```

`/S` copies MS-DOS 7.1 system files (IO.SYS, MSDOS.SYS, COMMAND.COM).
`/V:SYSTEM` sets volume label.

When done:

```bat
FORMAT D: /V:GAMES
```

D: does not need `/S` — data drive only.

### Step 12 — Verify

```bat
C:
DIR
```

You should see IO.SYS, MSDOS.SYS, COMMAND.COM (system files, may be hidden).
Confirm DOS boots from the new drive.

---

## Phase 3 — Install MS-DOS 7.1 base system

### Step 13 — Create directory structure on C:

```bat
C:
MD DOS
MD DRIVERS
MD TOOLS
MD NC
MD DOS\TMP
```

### Step 14 — Copy DOS 7.1 files from CDU media

The CDU disc typically has a `\DOS` folder with all utilities.

```bat
XCOPY X:\DOS\*.* C:\DOS\ /S
```

(Replace `X:` with your CDU drive letter — check with `DIR X:` first.)

### Step 15 — Write CONFIG.SYS (temporary — for DOS-only boot)

```bat
EDIT C:\CONFIG.SYS
```

Enter this minimal config to get DOS working — full multi-boot config
comes after Windows 98SE is installed:

```
[MENU]
MENUITEM=NORMAL, MS-DOS 7.1 Normal
MENUITEM=BARE,   Bare DOS
MENUDEFAULT=NORMAL,10

[COMMON]
DEVICE=C:\DOS\HIMEM.SYS /TESTMEM:OFF
DOS=HIGH,UMB
SHELL=C:\COMMAND.COM C:\ /E:1024 /P
FILES=30
BUFFERS=4,0
LASTDRIVE=Z
STACKS=9,256
FCBS=1,0

[NORMAL]
DEVICE=C:\DOS\EMM386.EXE NOEMS
DEVICEHIGH=C:\DRIVERS\SAMSUNG\SSCDROM.SYS /D:SSCD000

[BARE]
DEVICE=C:\DOS\EMM386.EXE NOEMS
```

Save (Alt+F → S), exit (Alt+F → X).

### Step 16 — Write AUTOEXEC.BAT (temporary)

```bat
EDIT C:\AUTOEXEC.BAT
```

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
REM Valid values: IRQ 2/5/7/10, Low DMA 0/1/3, High DMA 5/6/7
SET SOUND=C:\DRIVERS\SB16
SET BLASTER=A220 I5 D1 H5 P330 E620 T6
SET MIDI=SYNTH:1 MAP:E MODE:0

REM --- PicoGUS / Gravis UltraSound settings ---
REM Format: port,DMA play,DMA rec,IRQ play,IRQ rec (DMA and IRQ are repeated)
REM IRQ 7 = LPT1 must be disabled in BIOS to free this IRQ
SET ULTRASND=240,3,3,7,7
REM ULTRADIR must point to the GUS software root (not the MIDI subfolder)
SET ULTRADIR=C:\DRIVERS\PICOGUS

REM --- Route to profile-specific section ---
GOTO %CONFIG%

REM -----------------------------------------------
REM Profile: WINDOWS - launch Windows 98SE
REM Use for: Windows 98SE gaming, modern software, Win32 applications
REM Note: AWE32 and mouse are initialized by Windows 32-bit PnP drivers
REM       UNISOUND and AWEUTIL are NOT loaded - Windows handles AWE32 itself
REM       SoftMPU is NOT loaded - Windows MIDI uses its own MPU-401 driver
REM -----------------------------------------------
:WINDOWS
REM --- PicoGUS initialization ---
REM Required: Windows has no PicoGUS driver - hardware must be init before WIN.COM
REM /mode gus    = Gravis UltraSound emulation (GUS not usable in Windows)
REM /mpuport 300 = MPU-401 on port 300h - needed for McCake under Windows
REM /mainvol 95  = master output 95% (headroom to prevent clipping)
REM /gusvol 95   = GUS output 95%
REM /wtvol 95    = wavetable header output 95%
REM /mpudelay 1  = slow down SysEx for Roland-compatible synthesizers
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 300 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
ECHO.
ECHO  [SOUND ENVIRONMENT]
ECHO  BLASTER : %BLASTER%
ECHO  MIDI    : %MIDI%
ECHO  SOUND   : %SOUND%
ECHO  ULTRASND: %ULTRASND%
ECHO  ULTRADIR: %ULTRADIR%
ECHO.

REM --- CD-ROM ---
REM /M:10 = 10 sector lookahead cache in extended memory
LH C:\DOS\MSCDEX.EXE /D:SSCD000 /M:10

REM --- Mouse ---
REM /R2 = horizontal resolution 2 (movement sensitivity)
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2

REM --- Launch Windows 98SE ---
WIN.COM
GOTO END

REM -----------------------------------------------
REM Profile: NOSOFTMPU - NOEMS without SoftMPU
REM Use for: AWEUTIL /EM:GM/GS/MT32 emulation
REM -----------------------------------------------
:NOSOFTMPU
REM --- AWE32 CT3900 hardware init (UNISOUND) ---
REM /V70 = master volume 70, /VF90 = FM/OPL3 volume 90 (real OPL3 CT1747)
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90

REM --- AWEUTIL - EMU8000 wavetable synthesizer init ---
REM /S = hardware init only, 0KB memory resident
REM Note: AWEUTIL /EM:* does NOT work with DOS extenders (DOS4GW) - only /S init
REM This profile has no SoftMPU - AWEUTIL /EM:* can run without conflict
REM   LH C:\DRIVERS\SB16\AWEUTIL.COM /EM:GM    General MIDI emulation
REM   LH C:\DRIVERS\SB16\AWEUTIL.COM /EM:GS    Roland GS emulation
REM   LH C:\DRIVERS\SB16\AWEUTIL.COM /EM:MT32  Roland MT-32 emulation
REM   C:\DRIVERS\SB16\AWEUTIL.COM /U           unload from memory
C:\DRIVERS\SB16\AWEUTIL.COM /S

REM --- SoftMPU NOT loaded - AWEUTIL /EM:* can run without conflict ---

REM --- PicoGUS initialization ---
REM /mode gus    = Gravis UltraSound emulation
REM /mpuport 300 = MPU-401 on port 300h (AWE32 uses 330h - must not conflict)
REM /mainvol 95  = master output 95% (headroom to prevent clipping)
REM /gusvol 95   = GUS output 95%
REM /wtvol 95    = wavetable header output 95%
REM /mpudelay 1  = slow down SysEx for Roland-compatible synthesizers
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 300 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
ECHO.
ECHO  [SOUND ENVIRONMENT]
ECHO  BLASTER : %BLASTER%
ECHO  MIDI    : %MIDI%
ECHO  SOUND   : %SOUND%
ECHO  ULTRASND: %ULTRASND%
ECHO  ULTRADIR: %ULTRADIR%
ECHO.

REM --- CD-ROM ---
LH C:\DOS\MSCDEX.EXE /D:SSCD000 /M:10

REM --- Mouse ---
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END

REM -----------------------------------------------
REM Profile: NOSOFTEMU - EMS without SoftMPU
REM Use for: AWEUTIL /EM + EMS memory
REM -----------------------------------------------
:NOSOFTEMU
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90
C:\DRIVERS\SB16\AWEUTIL.COM /S
REM --- SoftMPU NOT loaded ---
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 300 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
ECHO.
ECHO  [SOUND ENVIRONMENT]
ECHO  BLASTER : %BLASTER%
ECHO  MIDI    : %MIDI%
ECHO  SOUND   : %SOUND%
ECHO  ULTRASND: %ULTRASND%
ECHO  ULTRADIR: %ULTRADIR%
ECHO.
LH C:\DOS\MSCDEX.EXE /D:SSCD000 /M:10
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END

REM -----------------------------------------------
REM Profile: NORMAL - NOEMS with SoftMPU
REM Use for: MT-32 games (Sierra, LucasArts), GUS games, everyday use
REM          AWE32 native games, SC-55, McCake SF2
REM -----------------------------------------------
:NORMAL
REM --- AWE32 CT3900 hardware init (UNISOUND) ---
REM Initializes: IRQ, DMA, I/O ports, OPL3, mixer
REM CT3900 semi-PnP: UNISOUND programs IRQ/DMA from BLASTER variable
REM /V70 = master volume 70 (range 0-100)
REM /VF90 = FM/OPL3 volume 90 - real Yamaha OPL3 chip (CT1747) on CT3900
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90

REM --- AWEUTIL - EMU8000 wavetable synthesizer init ---
REM UNISOUND does not init EMU8000 - AWEUTIL required for AWE32 wavetable features
REM /S = init EMU8000 from BLASTER variable (E620 = EMU8000 port)
REM Required for: AWE32 games, GM/GS/MT-32 MIDI emulation
REM Files: C:\DRIVERS\SB16\AWEUTIL.COM + Synthgm.sbk + Synthgs.sbk + Synthmt.sbk
REM Note: AWEUTIL /EM:* conflicts with SoftMPU - use profile NOSOFTMPU
C:\DRIVERS\SB16\AWEUTIL.COM /S

REM --- SoftMPU - intelligent mode MPU-401 emulation for MT-32 games ---
REM Required for: Monkey Island 1, Sierra games, Ultima Underworld
REM AWE32 supports UART mode only - SoftMPU adds intelligent mode
REM /MPU:330 = MPU-401 port (must match P330 in BLASTER)
REM /SB:220  = Sound Blaster base port (explicit, prevents autodetect failure)
REM /IRQ:5   = Sound Blaster IRQ for intelligent mode timing
REM WARNING: AWEUTIL /EM:* cannot be combined with SoftMPU!
LH C:\DRIVERS\SOFTMPU\SOFTMPU.EXE /MPU:330 /SB:220 /IRQ:5

REM --- PicoGUS initialization ---
REM /mode gus    = Gravis UltraSound emulation
REM /mpuport 300 = MPU-401 on port 300h (AWE32 uses 330h - must not conflict)
REM /mainvol 95  = master output 95% (headroom to prevent clipping)
REM /gusvol 95   = GUS output 95%
REM /wtvol 95    = wavetable header output 95%
REM /mpudelay 1  = slow down SysEx for Roland-compatible synthesizers
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 300 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
ECHO.
ECHO  [SOUND ENVIRONMENT]
ECHO  BLASTER : %BLASTER%
ECHO  MIDI    : %MIDI%
ECHO  SOUND   : %SOUND%
ECHO  ULTRASND: %ULTRASND%
ECHO  ULTRADIR: %ULTRADIR%
ECHO.

REM --- CD-ROM ---
REM /M:10 = 10 sector lookahead cache in extended memory
LH C:\DOS\MSCDEX.EXE /D:SSCD000 /M:10

REM --- Mouse ---
REM /R2 = horizontal resolution 2 (movement sensitivity)
REM COM port is auto-detected by CTMOUSE
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END

REM -----------------------------------------------
REM Profile: EMS - RAM with SoftMPU
REM Use for: DOS extender games (Tyrian, Magic Carpet, Unreal)
REM          Games requiring EMS memory
REM -----------------------------------------------
:EMS
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90
REM Note: AWEUTIL /EM:* does NOT work with DOS extenders (DOS4GW) - only /S init
C:\DRIVERS\SB16\AWEUTIL.COM /S
LH C:\DRIVERS\SOFTMPU\SOFTMPU.EXE /MPU:330 /SB:220 /IRQ:5
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 300 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
ECHO.
ECHO  [SOUND ENVIRONMENT]
ECHO  BLASTER : %BLASTER%
ECHO  MIDI    : %MIDI%
ECHO  SOUND   : %SOUND%
ECHO  ULTRASND: %ULTRASND%
ECHO  ULTRADIR: %ULTRADIR%
ECHO.
LH C:\DOS\MSCDEX.EXE /D:SSCD000 /M:10
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END

REM -----------------------------------------------
REM Profile: BARE DOS
REM -----------------------------------------------
:BARE
GOTO END

:END
REM --- Norton Commander ---
NC
```

Save and exit.

### Step 17 — Copy Samsung CD-ROM driver

If your old disk is accessible (secondary IDE), copy the driver:

```bat
COPY E:\DRIVERS\SAMSUNG\SSCDROM.SYS C:\DRIVERS\SAMSUNG\SSCDROM.SYS
```

(Replace `E:` with actual letter of old disk.)

Otherwise copy from old disk later or proceed without CD-ROM until Win98SE install.

### Step 18 — Reboot and test DOS

Remove CDU media. System should boot from C:, show boot menu, load DOS 7.1.

```bat
VER
```

Should show: `MS-DOS Version 7.10`

```bat
DIR D:
```

Should show empty D: drive.

---

## Phase 4 — Install Windows 98SE

### Step 19 — Boot to DOS, insert Win98SE CD

With CD-ROM driver active (profile NORMAL), insert Windows 98SE CD.

```bat
D:
```

CD-ROM is typically the next letter after D: — check:

```bat
DIR E:
DIR F:
```

Find the drive with `WIN98\SETUP.EXE`.

### Step 20 — Run Setup

```bat
E:\WIN98\SETUP.EXE
```

(Replace E: with actual CD-ROM letter.)

When Setup asks for installation directory: **C:\WINDOWS**

When Setup asks about partition/disk setup: skip — partitions are already prepared.

Proceed through Setup normally. The system will reboot several times.

> ⚠️ During Setup, Windows may modify CONFIG.SYS and AUTOEXEC.BAT.
> This is expected — we will replace them with the full multi-boot config afterwards.

### Step 21 — Complete Windows 98SE installation

Let Windows finish first-boot setup (hardware detection, driver installation).
Install all Windows 98SE drivers as needed (video, etc.) before proceeding.

---

## Phase 5 — Configure multi-boot menu

### Step 22 — Edit MSDOS.SYS to disable auto-GUI

Windows 98SE normally boots directly to Windows. We need it to show the
boot menu first.

MSDOS.SYS is a hidden system read-only file in C:\

```bat
ATTRIB -S -H -R C:\MSDOS.SYS
EDIT C:\MSDOS.SYS
```

Find the `[Options]` section and set/add:

```ini
[Options]
BootGUI=0
BootMulti=1
Logo=0
```

- `BootGUI=0` — do not auto-load Windows; show boot menu from CONFIG.SYS instead
- `BootMulti=1` — allow F8 to show additional boot options
- `Logo=0` — skip the Windows 98 splash screen (optional, cleaner boot)

Save and restore attributes:

```bat
ATTRIB +S +H +R C:\MSDOS.SYS
```

### Step 23 — Replace CONFIG.SYS with full multi-boot version

```bat
EDIT C:\CONFIG.SYS
```

Replace with the full config (this restores all original DOS profiles
and adds the new WINDOWS entry):

```
;===========================================
; CONFIG.SYS - Boot menu
; Rhino 15 / Pentium MMX / AWE32 CT3900 / Voodoo2 / ATI MACH64
; MS-DOS 7.10 + Windows 98SE
;===========================================

; Boot menu - displayed at startup with 10 second countdown
; MENUDEFAULT=WINDOWS,10 = auto-boot Windows after 10 seconds if no key pressed
[MENU]
MENUITEM=WINDOWS,   Windows 98SE
MENUITEM=NORMAL,    MS-DOS  SoftMPU         - NOEMS 607KB (MT-32, GUS, everyday)
MENUITEM=EMS,       MS-DOS  SoftMPU EMS     - RAM   595KB (Tyrian, Magic Carpet, Unreal)
MENUITEM=NOSOFTMPU, MS-DOS  No SoftMPU      - NOEMS 607KB (AWEUTIL /EM)
MENUITEM=NOSOFTEMU, MS-DOS  No SoftMPU EMS  - RAM   595KB (AWEUTIL /EM + extenders)
MENUITEM=BARE,      MS-DOS  Bare            - no drivers
MENUDEFAULT=WINDOWS,10
;MENUCOLOR=11,1

; -----------------------------------------------
; Common settings loaded for ALL profiles
; -----------------------------------------------
[COMMON]

; HIMEM.SYS - XMS memory manager, must always be first
; Using Windows 98SE version (newer than MS-DOS 7.1 version)
; /TESTMEM:OFF = skip memory test on boot (saves ~30s on 256MB)
DEVICE=C:\WINDOWS\HIMEM.SYS /TESTMEM:OFF

; Load DOS into HMA (High Memory Area) and enable UMB
; Must come before EMM386
DOS=HIGH,UMB

; Larger environment block - prevents DIGN9003 error from AWE32
; /E:1024 = 1024 bytes for SET variables (BLASTER, ULTRASND etc.)
SHELL=C:\COMMAND.COM C:\ /E:1024 /P

; FILES=30 - max open file handles (NC + MSCDEX need ~25)
FILES=30
; BUFFERS=4 - disk buffers (SmartDrive replaces DOS buffering, keep low)
BUFFERS=4,0
; LASTDRIVE=Z - covers all drives A-Z including C: D: E: + CD-ROM
LASTDRIVE=Z
; STACKS=9,256 - interrupt stack frames (required for AWE32 IRQ handling)
STACKS=9,256
; FCBS=1,0 - file control blocks (legacy, minimal)
FCBS=1,0

; -----------------------------------------------
; WINDOWS - minimal DOS init, then launch Windows 98SE
; Windows 98SE handles all hardware via its own 32-bit PnP drivers
; Only HIMEM + EMM386 needed - Windows reinitializes everything else
; -----------------------------------------------
[WINDOWS]

; EMM386 NOEMS - Windows does not use EMS, only UMB needed
; Using Windows 98SE version (updated, supports larger drives)
DEVICE=C:\WINDOWS\EMM386.EXE NOEMS

; Samsung CD-ROM driver - needed so MSCDEX in AUTOEXEC.BAT can load
; Windows will replace this with its own 32-bit CD-ROM driver after boot
DEVICEHIGH=C:\DRIVERS\SAMSUNG\SSCDROM.SYS /D:SSCD000

; -----------------------------------------------
; Profile NORMAL - NOEMS with SoftMPU (607KB conventional)
; Use for: MT-32 games (Sierra, LucasArts), GUS games, everyday DOS use
;          AWE32 native games, SC-55, McCake SF2
; SoftMPU adds intelligent mode MPU-401 emulation for MT-32 games
; -----------------------------------------------
[NORMAL]

; EMM386 NOEMS = no EMS page frame
; Frees 64KB of UMB compared to RAM mode - more space for drivers
; NOTE: HIGHSCAN must NOT be used - causes freeze on Award BIOS 4.51PG
DEVICE=C:\WINDOWS\EMM386.EXE NOEMS

; SmartDrive loaded first via INSTALLHIGH to claim largest free UMB block
; /X = disable write cache (safer for unexpected power loss on SSD)
; 2048KB read cache, 512KB element size
INSTALLHIGH=C:\DOS\SMARTDRV.EXE /X 2048 512

; Samsung CD-ROM driver into UMB
DEVICEHIGH=C:\DRIVERS\SAMSUNG\SSCDROM.SYS /D:SSCD000

; -----------------------------------------------
; Profile EMS - RAM with SoftMPU (595KB conventional)
; Use for: DOS extender games (Tyrian, Magic Carpet, Unreal)
;          Games requiring EMS memory (DOS4GW, DOS/4G extenders)
; Note: 12KB less conventional memory than NORMAL due to EMS page frame
; Note: AWEUTIL /EM:* does NOT work with DOS extenders - use /S only
; -----------------------------------------------
[EMS]

; EMM386 RAM = EMS + UMB both enabled
; EMS page frame occupies 64KB of UMB but allows DOS extenders to work
DEVICE=C:\WINDOWS\EMM386.EXE RAM

; SmartDrive loaded first to claim largest free UMB block
INSTALLHIGH=C:\DOS\SMARTDRV.EXE /X 2048 512

; Samsung CD-ROM driver into UMB
DEVICEHIGH=C:\DRIVERS\SAMSUNG\SSCDROM.SYS /D:SSCD000

; -----------------------------------------------
; Profile NOSOFTMPU - NOEMS without SoftMPU (607KB conventional)
; Use for: AWEUTIL /EM:GM/GS/MT32 emulation
;          AWEUTIL /EM conflicts with SoftMPU - do not combine
;          GM/GS games via AWEUTIL without external MIDI modules
; -----------------------------------------------
[NOSOFTMPU]

; EMM386 NOEMS - no EMS, maximum UMB space
DEVICE=C:\WINDOWS\EMM386.EXE NOEMS
INSTALLHIGH=C:\DOS\SMARTDRV.EXE /X 2048 512
DEVICEHIGH=C:\DRIVERS\SAMSUNG\SSCDROM.SYS /D:SSCD000

; -----------------------------------------------
; Profile NOSOFTEMU - RAM without SoftMPU (595KB conventional)
; Use for: AWEUTIL /EM + EMS memory games
;          Note: AWEUTIL /EM does not work with DOS extenders (DOS4GW)
;          For DOS extender games without AWEUTIL use profile EMS instead
; -----------------------------------------------
[NOSOFTEMU]

; EMM386 RAM - EMS enabled for games that need it
DEVICE=C:\WINDOWS\EMM386.EXE RAM
INSTALLHIGH=C:\DOS\SMARTDRV.EXE /X 2048 512
DEVICEHIGH=C:\DRIVERS\SAMSUNG\SSCDROM.SYS /D:SSCD000

; -----------------------------------------------
; Profile BARE - minimal (diagnostics, installation, troubleshooting)
; No SmartDrive, no CD-ROM, no sound - just basic DOS with XMS
; -----------------------------------------------
[BARE]

; Minimal EMM386 for XMS access only
DEVICE=C:\WINDOWS\EMM386.EXE NOEMS
```

> Note: EMM386 and HIMEM now live in C:\WINDOWS\ (Win98SE install location),
> not C:\DOS\ — Win98SE replaces these with updated versions.

Save and exit.

### Step 24 — Replace AUTOEXEC.BAT with full multi-boot version

```bat
EDIT C:\AUTOEXEC.BAT
```

Replace with the full version. Key changes from original DOS-only config:
- Added `:WINDOWS` section: PGUSINIT + MSCDEX + mouse + WIN.COM
- PGUSINIT in every profile — initializes PicoGUS hardware before boot
- ECHO block in every profile — displays sound environment after PGUSINIT
- UNISOUND and AWEUTIL /S in DOS profiles — Win98SE handles AWE32 itself

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
REM Valid values: IRQ 2/5/7/10, Low DMA 0/1/3, High DMA 5/6/7
SET SOUND=C:\DRIVERS\SB16
SET BLASTER=A220 I5 D1 H5 P330 E620 T6
SET MIDI=SYNTH:1 MAP:E MODE:0

REM --- PicoGUS / Gravis UltraSound settings ---
REM Format: port,DMA play,DMA rec,IRQ play,IRQ rec
REM IRQ 7 = LPT1 must be disabled in BIOS to free this IRQ
SET ULTRASND=240,3,3,7,7
REM ULTRADIR must point to the GUS software root (not the MIDI subfolder)
SET ULTRADIR=C:\DRIVERS\PICOGUS

REM --- Route to profile-specific section ---
GOTO %CONFIG%

REM -----------------------------------------------
REM Profile: WINDOWS - launch Windows 98SE
REM Windows handles all hardware via its own 32-bit drivers
REM -----------------------------------------------
:WINDOWS
LH C:\DOS\MSCDEX.EXE /D:SSCD000 /M:10
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
WIN.COM
GOTO END

REM -----------------------------------------------
REM Profile 1: NOSOFTMPU - NOEMS without SoftMPU
REM Use for: AWEUTIL /EM:GM/GS/MT32 emulation
REM -----------------------------------------------
:NOSOFTMPU
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90
C:\DRIVERS\SB16\AWEUTIL.COM /S
REM --- SoftMPU NOT loaded - AWEUTIL /EM:* can run without conflict ---
REM   LH C:\DRIVERS\SB16\AWEUTIL.COM /EM:GM    General MIDI emulation
REM   LH C:\DRIVERS\SB16\AWEUTIL.COM /EM:GS    Roland GS emulation
REM   LH C:\DRIVERS\SB16\AWEUTIL.COM /EM:MT32  Roland MT-32 emulation
REM   C:\DRIVERS\SB16\AWEUTIL.COM /U           unload from memory
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 300 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
LH C:\DOS\MSCDEX.EXE /D:SSCD000 /M:10
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END

REM -----------------------------------------------
REM Profile 2: NOSOFTEMU - EMS without SoftMPU
REM Use for: AWEUTIL /EM + EMS memory
REM -----------------------------------------------
:NOSOFTEMU
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90
C:\DRIVERS\SB16\AWEUTIL.COM /S
REM --- SoftMPU NOT loaded ---
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 300 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
LH C:\DOS\MSCDEX.EXE /D:SSCD000 /M:10
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END

REM -----------------------------------------------
REM Profile 3: NORMAL - NOEMS with SoftMPU
REM Use for: MT-32 games (Sierra, LucasArts), GUS games, everyday use
REM -----------------------------------------------
:NORMAL
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90
C:\DRIVERS\SB16\AWEUTIL.COM /S
REM --- SoftMPU - intelligent mode MPU-401 emulation for MT-32 games ---
REM /MPU:330 = MPU-401 port (must match P330 in BLASTER)
REM /SB:220  = Sound Blaster base port (explicit, prevents autodetect failure)
REM /IRQ:5   = Sound Blaster IRQ for intelligent mode timing
REM WARNING: AWEUTIL /EM:* cannot be combined with SoftMPU!
LH C:\DRIVERS\SOFTMPU\SOFTMPU.EXE /MPU:330 /SB:220 /IRQ:5
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 300 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
LH C:\DOS\MSCDEX.EXE /D:SSCD000 /M:10
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END

REM -----------------------------------------------
REM Profile 4: EMS - RAM with SoftMPU
REM Use for: DOS extender games (Tyrian, Magic Carpet, Unreal)
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

Save and exit.

---

## Phase 6 — Copy drivers from old disk

### Step 25 — Connect old disk and copy C: drivers

Connect old disk as secondary IDE (or use it before swapping).
Old disk C: will appear as a different drive letter on the new system
(typically E: or F: — check with `DIR E:`, `DIR F:` etc.).

```bat
XCOPY E:\DRIVERS C:\DRIVERS /S /E /H /Y
XCOPY E:\TOOLS C:\TOOLS /S /E /H /Y
XCOPY E:\NC C:\NC /S /E /H /Y
XCOPY E:\DOS C:\DOS /S /E /H /Y
```

> Do NOT copy CONFIG.SYS, AUTOEXEC.BAT, IO.SYS, MSDOS.SYS, COMMAND.COM
> from the old disk — the new versions are already correct.

### Step 26 — Copy files to D:

```bat
XCOPY E:\D\*.* D:\ /S /E /H /Y
```


```bat
XCOPY E:\DATA\*.* E:\ /S /E /H /Y
```

(Adjust source drive letter to match the old disk's actual letter on the new system.)

---

## Phase 7 — First boot test

### Step 27 — Reboot and test boot menu

Reboot with no media in drives. You should see:

```
Microsoft Windows 98 Startup Menu
===================================
  1. Windows 98SE
  2. MS-DOS  SoftMPU         - NOEMS 607KB
  3. MS-DOS  SoftMPU EMS     - RAM   595KB
  4. MS-DOS  No SoftMPU      - NOEMS 607KB
  5. MS-DOS  No SoftMPU EMS  - RAM   595KB
  6. MS-DOS  Bare
```

Default: Windows 98SE (10 second countdown)

### Step 28 — Test each option

| Test | Expected result |
|---|---|
| Option 1 (Windows) | Windows 98SE loads, desktop appears |
| Option 2 (NORMAL) | DOS prompt, SoftMPU loaded, sound card active |
| Option 3 (EMS) | DOS prompt, SoftMPU loaded, EMS memory available |
| Option 4 (NOSOFTMPU) | DOS prompt, no SoftMPU, AWEUTIL /EM available |
| Option 6 (BARE) | Minimal DOS prompt, no drivers |

### Step 29 — Verify drive letters in DOS

```bat
DIR C:    (system, 8 GB)
DIR D:    (games, ~230 GB)
```

### Step 30 — Verify drive letters in Windows 98SE

Open My Computer. You should see:
- C: (8 GB, system)
- D: (~230 GB, games + data)
- CD-ROM on next available letter (E: or F:)

---

## Phase 8 — Windows 98SE driver installation

### Step 31 — Install Intel PIIX4 IDE Bus Master driver

This enables UDMA/33 in Windows 98SE. Without it Windows uses PIO mode.

Download: Intel INF Update Utility (inf8xxxx.exe) from Intel or VOGONS drivers.
Run from Windows, reboot. Device Manager → IDE controllers should show
"Intel 82371AB/EB PCI Bus Master IDE Controller" with DMA enabled.

### Step 32 — Install AWE32 CT3900 drivers for Windows

Install Creative Sound Blaster AWE32 drivers for Windows 98SE.
Configure: port 220, IRQ 5, DMA 1/5, EMU8000 port 620.

### Step 33 — Install PicoGUS Windows 98SE MPU-401

In Device Manager → Add hardware → manually add:
- Sound, video and game controllers
- MPU-401 Compatible, IRQ 9, port 300h

(GUS emulation is not supported in Windows — MPU-401 MIDI only.)

---

## Troubleshooting

| Problem | Solution |
|---|---|
| BIOS sees only 8 GB | Expected — BIOS limit; DOS 7.1 and Win98SE see full disk via 32-bit driver |
| D: not visible in DOS | LASTDRIVE=Z in CONFIG.SYS — already set in the config below |
| Windows boots directly without menu | MSDOS.SYS BootGUI=0 not saved correctly — redo Step 23 |
| SoftMPU not loaded | Check AUTOEXEC.BAT — profile must route to :NORMAL or :EMS |
| No sound in DOS | UNISOUND not found — verify C:\DRIVERS\UNISOUND\UNISOUND.COM |
| CD-ROM not found | SSCDROM.SYS path — must be C:\DRIVERS\SAMSUNG\SSCDROM.SYS |
| Games not on D: | Copy from old disk: XCOPY old_drive:\games D:\ /S /E |
| Win98 slow disk access | Install Intel PIIX4 Bus Master driver (see Step 31) |

---

## Summary — boot menu profiles

| Profile | SoftMPU | EMS | Use for |
|---|---|---|---|
| Windows 98SE | — | — | Windows gaming, modern software |
| NORMAL | Yes | No | MT-32 games, GUS, McCake, everyday DOS |
| EMS | Yes | Yes | Tyrian, Magic Carpet, Unreal, DOS extenders |
| NOSOFTMPU | No | No | AWEUTIL /EM emulation |
| NOSOFTEMU | No | Yes | AWEUTIL /EM + EMS games |
| BARE | No | No | Diagnostics, installation |
