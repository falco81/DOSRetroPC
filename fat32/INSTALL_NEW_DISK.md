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

| Drive | Size | Filesystem | Contents |
|---|---|---|---|
| C: | 20 GB | FAT32 | MS-DOS 7.1 system, Windows 98SE, all drivers, tools |
| D: | ~220 GB | FAT32 | All games (1:1 copy from old disk) |

**Why 20 GB for C:**
The Rhino 15 Award BIOS (09/18/97) safely handles LBA up to 32 GB for the boot
partition. 20 GB leaves headroom and fits DOS + Win98SE + all drivers comfortably.
D: at ~220 GB is within LBA28 (137 GB) if needed, but Win98SE accesses large
drives via its own 32-bit driver bypassing the BIOS limit — so D: can be larger.

> ⚠️ If the BIOS only sees 8.4 GB or 32 GB total, the adapter's own LBA
> translation should present the full 256 GB correctly to the OS. Test BIOS
> detection before partitioning.

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

### Step 4 — Create C: partition (20 GB, FAT32, aligned)

Right-click the unallocated space → Create:

| Setting | Value |
|---|---|
| Partition Label | SYSTEM |
| File System | FAT32 |
| Size | 20480 MB |
| Align to | **2048 sectors** (= 1 MB boundary — correct for SSD) |
| Partition Type | Primary |

Click OK.

### Step 5 — Create D: partition (remaining space, FAT32, aligned)

Right-click the remaining unallocated space → Create:

| Setting | Value |
|---|---|
| Partition Label | GAMES |
| File System | FAT32 |
| Size | all remaining (leave default) |
| Align to | **2048 sectors** |
| Partition Type | Logical |

Click OK.

### Step 6 — Set C: as Active

Right-click the C: (SYSTEM) partition → Set Active.

### Step 7 — Apply

Click Apply → Yes. MiniTool writes the partition table with correct alignment.

### Step 8 — Disconnect and move to retro PC

Safely eject the disk. Reconnect the full adapter chain to the retro PC
via the 80-conductor IDE cable.

> FDISK is **not needed** — partitions are already created and correctly aligned.

---

## Phase 2 — Format and install MS-DOS 7.1

### Step 9 — Boot from MS-DOS 7.1 CDU ISO

Set BIOS boot order to boot from your CDU media (USB or CD).
Boot to DOS prompt (e.g. `A:\>` or `X:\>`).

### Step 10 — Format both partitions

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

### Step 11 — Verify

```bat
C:
DIR
```

You should see IO.SYS, MSDOS.SYS, COMMAND.COM (system files, may be hidden).
Confirm DOS boots from the new drive.

---

## Phase 3 — Install MS-DOS 7.1 base system

### Step 12 — Create directory structure on C:

```bat
C:
MD DOS
MD DRIVERS
MD TOOLS
MD NC
MD DOS\TMP
```

### Step 13 — Copy DOS 7.1 files from CDU media

The CDU disc typically has a `\DOS` folder with all utilities.

```bat
XCOPY X:\DOS\*.* C:\DOS\ /S
```

(Replace `X:` with your CDU drive letter — check with `DIR X:` first.)

### Step 14 — Write CONFIG.SYS (temporary — for DOS-only boot)

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
LASTDRIVE=H
STACKS=9,256
FCBS=1,0

[NORMAL]
DEVICE=C:\DOS\EMM386.EXE NOEMS
DEVICEHIGH=C:\DRIVERS\SAMSUNG\SSCDROM.SYS /D:SSCD000

[BARE]
DEVICE=C:\DOS\EMM386.EXE NOEMS
```

Save (Alt+F → S), exit (Alt+F → X).

### Step 15 — Write AUTOEXEC.BAT (temporary)

```bat
EDIT C:\AUTOEXEC.BAT
```

```bat
@ECHO OFF
PROMPT $P$G
PATH C:\DOS;C:\NC;C:\TOOLS
SET TEMP=C:\DOS\TMP
SET TMP=C:\DOS\TMP
GOTO %CONFIG%

:NORMAL
LH C:\DOS\MSCDEX.EXE /D:SSCD000 /M:10
GOTO END

:BARE
GOTO END

:END
```

Save and exit.

### Step 16 — Copy Samsung CD-ROM driver

If your old disk is accessible (secondary IDE), copy the driver:

```bat
COPY E:\DRIVERS\SAMSUNG\SSCDROM.SYS C:\DRIVERS\SAMSUNG\SSCDROM.SYS
```

(Replace `E:` with actual letter of old disk.)

Otherwise copy from old disk later or proceed without CD-ROM until Win98SE install.

### Step 17 — Reboot and test DOS

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

### Step 18 — Boot to DOS, insert Win98SE CD

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

### Step 19 — Run Setup

```bat
E:\WIN98\SETUP.EXE
```

(Replace E: with actual CD-ROM letter.)

When Setup asks for installation directory: **C:\WINDOWS**

When Setup asks about partition/disk setup: skip — partitions are already prepared.

Proceed through Setup normally. The system will reboot several times.

> ⚠️ During Setup, Windows may modify CONFIG.SYS and AUTOEXEC.BAT.
> This is expected — we will replace them with the full multi-boot config afterwards.

### Step 20 — Complete Windows 98SE installation

Let Windows finish first-boot setup (hardware detection, driver installation).
Install all Windows 98SE drivers as needed (video, etc.) before proceeding.

---

## Phase 5 — Configure multi-boot menu

### Step 21 — Edit MSDOS.SYS to disable auto-GUI

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

### Step 22 — Replace CONFIG.SYS with full multi-boot version

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

; Top-level boot menu
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
; Common settings for ALL profiles
; -----------------------------------------------
[COMMON]
DEVICE=C:\WINDOWS\HIMEM.SYS /TESTMEM:OFF
DOS=HIGH,UMB
SHELL=C:\COMMAND.COM C:\ /E:1024 /P
FILES=30
BUFFERS=4,0
LASTDRIVE=H
STACKS=9,256
FCBS=1,0

; -----------------------------------------------
; WINDOWS profile - minimal DOS init, then launch Win98
; -----------------------------------------------
[WINDOWS]
DEVICE=C:\WINDOWS\EMM386.EXE NOEMS
DEVICEHIGH=C:\DRIVERS\SAMSUNG\SSCDROM.SYS /D:SSCD000

; -----------------------------------------------
; Profile 3: NORMAL - NOEMS with SoftMPU (607KB conventional)
; Use for: MT-32 games (Sierra, LucasArts), GUS games, everyday use
; -----------------------------------------------
[NORMAL]
DEVICE=C:\WINDOWS\EMM386.EXE NOEMS
INSTALLHIGH=C:\DOS\SMARTDRV.EXE /X 2048 512
DEVICEHIGH=C:\DRIVERS\SAMSUNG\SSCDROM.SYS /D:SSCD000

; -----------------------------------------------
; Profile 4: EMS - RAM with SoftMPU (595KB conventional)
; Use for: DOS extender games (Tyrian, Magic Carpet, Unreal)
; -----------------------------------------------
[EMS]
DEVICE=C:\WINDOWS\EMM386.EXE RAM
INSTALLHIGH=C:\DOS\SMARTDRV.EXE /X 2048 512
DEVICEHIGH=C:\DRIVERS\SAMSUNG\SSCDROM.SYS /D:SSCD000

; -----------------------------------------------
; Profile 1: NOSOFTMPU - NOEMS without SoftMPU (607KB conventional)
; Use for: AWEUTIL /EM:GM/GS/MT32 emulation
; -----------------------------------------------
[NOSOFTMPU]
DEVICE=C:\WINDOWS\EMM386.EXE NOEMS
INSTALLHIGH=C:\DOS\SMARTDRV.EXE /X 2048 512
DEVICEHIGH=C:\DRIVERS\SAMSUNG\SSCDROM.SYS /D:SSCD000

; -----------------------------------------------
; Profile 2: NOSOFTEMU - RAM without SoftMPU (595KB conventional)
; Use for: AWEUTIL /EM + EMS games
; -----------------------------------------------
[NOSOFTEMU]
DEVICE=C:\WINDOWS\EMM386.EXE RAM
INSTALLHIGH=C:\DOS\SMARTDRV.EXE /X 2048 512
DEVICEHIGH=C:\DRIVERS\SAMSUNG\SSCDROM.SYS /D:SSCD000

; -----------------------------------------------
; Profile 5: BARE - minimal (diagnostics, installation)
; -----------------------------------------------
[BARE]
DEVICE=C:\WINDOWS\EMM386.EXE NOEMS
```

> Note: EMM386 and HIMEM now live in C:\WINDOWS\ (Win98SE install location),
> not C:\DOS\ — Win98SE replaces these with updated versions.

Save and exit.

### Step 23 — Replace AUTOEXEC.BAT with full multi-boot version

```bat
EDIT C:\AUTOEXEC.BAT
```

Replace with the full version — identical to your original except:
- Added `:WINDOWS` section that launches WIN.COM
- WINDOWS profile skips all sound drivers (Win98 handles them itself)

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
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 300 /mainvol 85 /gusvol 85 /wtvol 85 /mpudelay 1
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
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 300 /mainvol 85 /gusvol 85 /wtvol 85 /mpudelay 1
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
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 300 /mainvol 85 /gusvol 85 /wtvol 85 /mpudelay 1
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
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 300 /mainvol 85 /gusvol 85 /wtvol 85 /mpudelay 1
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

### Step 24 — Connect old disk and copy C: drivers

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

### Step 25 — Copy games to D:

```bat
XCOPY E:\D\*.* D:\ /S /E /H /Y
```

(Assuming old games were on the old D: drive, which appears as a different
letter now — adjust accordingly.)

---

## Phase 7 — First boot test

### Step 26 — Reboot and test boot menu

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

### Step 27 — Test each option

| Test | Expected result |
|---|---|
| Option 1 (Windows) | Windows 98SE loads, desktop appears |
| Option 2 (NORMAL) | DOS prompt, SoftMPU loaded, sound card active |
| Option 3 (EMS) | DOS prompt, SoftMPU loaded, EMS memory available |
| Option 4 (NOSOFTMPU) | DOS prompt, no SoftMPU, AWEUTIL /EM available |
| Option 6 (BARE) | Minimal DOS prompt, no drivers |

### Step 28 — Verify drive letters in DOS

```bat
DIR C:    (system, ~20 GB)
DIR D:    (games, ~220 GB)
```

### Step 29 — Verify drive letters in Windows 98SE

Open My Computer. You should see:
- C: (20 GB, system)
- D: (games)
- CD-ROM on next available letter

---

## Phase 8 — Windows 98SE driver installation

### Step 30 — Install Intel PIIX4 IDE Bus Master driver

This enables UDMA/33 in Windows 98SE. Without it Windows uses PIO mode.

Download: Intel INF Update Utility (inf8xxxx.exe) from Intel or VOGONS drivers.
Run from Windows, reboot. Device Manager → IDE controllers should show
"Intel 82371AB/EB PCI Bus Master IDE Controller" with DMA enabled.

### Step 31 — Install AWE32 CT3900 drivers for Windows

Install Creative Sound Blaster AWE32 drivers for Windows 98SE.
Configure: port 220, IRQ 5, DMA 1/5, EMU8000 port 620.

### Step 32 — Install PicoGUS Windows 98SE MPU-401

In Device Manager → Add hardware → manually add:
- Sound, video and game controllers
- MPU-401 Compatible, IRQ 9, port 300h

(GUS emulation is not supported in Windows — MPU-401 MIDI only.)

---

## Troubleshooting

| Problem | Solution |
|---|---|
| BIOS sees less than 256 GB | Normal — adapter handles LBA; OS sees full size |
| D: drive not visible in DOS | LASTDRIVE=H in CONFIG.SYS — increase if needed |
| Windows boots directly without menu | MSDOS.SYS BootGUI=0 not saved correctly |
| SoftMPU not loaded | Check AUTOEXEC.BAT — profile must route to :NORMAL or :EMS |
| No sound in DOS | UNISOUND not found — verify C:\DRIVERS\UNISOUND\UNISOUND.COM |
| CD-ROM not found | SSCDROM.SYS path — must be C:\DRIVERS\SAMSUNG\SSCDROM.SYS |
| Games not on D: | Copy from old disk: XCOPY old_drive:\games D:\ /S /E |
| Win98 slow disk access | Install Intel PIIX4 Bus Master driver (see Step 23) |

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
