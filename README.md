# DOS Retro PC — Rhino 15 · Pentium MMX · AWE32 CT3900 · PicoGUS v2.0 · WP32 McCake · Voodoo2

> **Unified setup documentation** — FAT32 (MS-DOS 7.1 + Windows 98SE) and DOS 6.22 configurations,
> hardware reference, game compatibility guide and all scripts.

---

## Table of Contents

**Shared**
- [Hardware](#hardware)
- [BIOS Settings](#bios-settings)
- [IRQ Map](#irq-map)
- [DMA Map](#dma-map)
- [AWE32 CT3900 Upgrade Guide](#awe64-ct4380-awe32-ct3900-upgrade-guide)
- [PicoGUS v2.0 + WP32 McCake](#picogus-v20-wp32-mccake-installation-guide)
- [Audio Routing](#audio-routing-behringer-qx1222usb)
- [Sound Device Reference](#sound-device-reference)

**FAT32 — MS-DOS 7.1 + Windows 98SE**
- [Disk Installation](#fat32-disk-installation)
- [Boot Menu Profiles](#fat32-boot-menu-profiles)
- [CONFIG.SYS](#fat32-configsys)
- [AUTOEXEC.BAT](#fat32-autoexecbat)
- [MSDOS.SYS](#step-22-edit-msdossys-to-disable-auto-gui)

**DOS 6.22**
- [Boot Menu Profiles](#dos-622-boot-menu-profiles)
- [CONFIG.SYS](#dos-622-configsys)
- [AUTOEXEC.BAT](#dos-622-autoexecbat)

**Scripts — C:\DRIVERS\SCRIPTS\**
- [GUS.BAT](#gusbat-gus-game-launcher)
- [MPU.BAT](#mpubat-picogus-mpu-401-game-launcher)
- [ISO.BAT](#isobat-virtual-cd-rom-switcher)
- [USBMNT.BAT](#usbmntbat-mount-usb-drive)
- [USBCHCK.BAT](#usbchckbat-check-usb-devices)
- [USBUMNT.BAT](#usbumntbat-safe-usb-unplug)

**Peripherals**
- [USBODE — USB CD-ROM / Storage](#usbode-usb-optical-drive-emulator)
- [PicoIDE Deluxe](#picoide-deluxe-pending-delivery)
- [Gotek SFR1M44-U100K](#gotek-sfr1m44-u100k-usb-floppy-emulator)
- [BLE Keyboard + Mouse Bridge](#ble-keyboard-mouse-bridge)

**Reference**
- [Environment Variables](#environment-variables-reference)
- [AWEUTIL Reference](#aweutil-emu8000-wavetable-synthesizer)
- [Game Setup Guide](#game-setup-guide)
- [Memory Map](#memory-map-after-optimization)
- [Driver Locations](#driver-locations)
- [Video](#video)
- [Key Notes](#key-notes)
- [X16GS Alternative](#dreamblaster-x16gs-alternative-module-currently-under-repair)

**MIDI Synthesizer Reference**
- [Roland MT-32 original](#roland-mt-32-original)
- [Roland SC-55 MK2](#roland-sc-55-mk2)
- [Roland SC-88 Pro](#roland-sc-88-pro)
- [MT32-pi SF2 (Serdashop)](#serdashop-sf2-external-midi-synth)
- [McCake WP32 (interní wavetable)](#mccake-wp32-interní-wavetable)

---

## Hardware

| Component | Model | Interface | Notes |
|---|---|---|---|
| Motherboard | Octek Aristo Rhino 15 | Baby AT | — |
| CPU | Intel Pentium MMX 200 MHz (P55C, stepping xB1) | Socket 7 | CPUID 00000543, 66 MHz FSB, 3.3V |
| RAM | 256 MB (2× 128 MB SDRAM DIMM) | — | CAS latency 3, BIOS: Slower RAS |
| North Bridge | Intel 82439TX MTXC (430TX) | — | L2: 512 KB Dual-Bank Pipelined Burst |
| South Bridge | Intel 82371AB PIIX4 rev B-0 | — | UDMA/33 max |
| BIOS | Award Modular BIOS v4.51PG | — | 09/18/97 |
| Super IO | ITE8679/8680 | — | — |
| Video | ATI Rage 3D Pro (Rage PRO) | PCI | 4 MB DRAM, BIOS BK3.9.0/3.081, VBE 2.0 |
| 3D Accelerator | 3dfx Voodoo2 | PCI | FBI Rev4, 4 MB FB + 2×4 MB TMU |
| Sound Card | Creative Sound Blaster AWE32 CT3900 | ISA | DSP 4.16, port 220h, IRQ 5, DMA 1/5, MPU-401 300h, 512 KB DRAM |
| GUS / MIDI Card | PicoGUS v2.0 | ISA | port 240h, IRQ 7, DMA 3, MPU-401 330h |
| SF2 / GM Synth | Serdaco WP32 McCake (mt32-pi, CM4) | Waveblaster header | port 330h (via PicoGUS) |
| McCake Panel | Serdaco MT32Pi Drive Bay Panel 5.25" + OLED | 5.25" bay | **pending delivery** |
| SSD | Verbatim Vi560 S3 256 GB | IDE (via Ableconn IDE40-SAT) | FW: SN21794, S/N: 493626018370372 |
| CD-ROM | LG HL-DT-ST DVDRAM GH22NS40 | IDE secondary master | FW: NL01, driver: SSCDROM.SYS |
| PicoIDE Deluxe | polpo PicoIDE (RP2350) | IDE | **pending delivery** — will be added alongside LG drive |
| NIC | 3Com 3C905C-TX EtherLink XL 10/100 | **PCI** | — |
| Floppy A: | Gotek SFR1M44-U100K (USB floppy emulator) | 3.5" floppy konektor | 2 buttons + LED numeric display, FlashFloppy firmware |
| Floppy B: | Physical 3.5" 1.44 MB drive | 3.5" floppy connector | instalováno |
| Mouse + Keyboard | Modern BLE mouse + BLE keyboard via ESP32 BLE bridge | PS/2 or RS232 | see BLE Bridge section |
| Monitor | Fujitsu-Siemens (w9/2009) | VGA | 38×30 cm, H: 30–83 kHz, V: 56–75 Hz |
| MIDI module 1 | Roland MT-32 original | MIDI splitter (from PicoGUS) | CH 7+8 on mixer |
| MIDI module 2 | Roland SC-55 MK2 original | MIDI splitter (from PicoGUS) | CH 9+10 on mixer |
| MIDI module 3 | Roland SC-88 Pro original | MIDI splitter (from PicoGUS) | CH 11+12 on mixer |
| GM Synth (ext.) | MT32-pi (SF2) — Serdashop | MIDI splitter (from PicoGUS) | CH 5+6 on mixer |
| MIDI Splitter | CME WIDI Thru6 BT | MIDI (1-in / 5-out wired + BT) | napájení USB-C |
| Mixer | Behringer XENYX QX1222USB | USB | — |
| Headphones | Audio-Technica ATH-M50x | QX1222USB Phones jack | — |
| Second PC | Windows XP PC | QX1222USB 2-TR input | — |

---


---

---

## BIOS Settings

> Award Modular BIOS v4.51PG · ROM ID: 2A59IO09 · Date: 09/18/97
> DEL při bootu pro vstup do setupu.

---

### BIOS Features Setup

| Položka | Nastavení | Popis |
|---|---|---|
| Virus Warning | Disabled | Ochrana boot sektoru — vypnuto, jinak blokuje instalaci OS a bootloadery |
| CPU Internal Cache | Enabled | L1 cache procesoru — musí být zapnuto |
| External Cache | Enabled | L2 cache (512 KB Dual-Bank) — musí být zapnuto |
| Quick Power On Self Test | Enabled | Zkrácený POST — rychlejší boot |
| Boot Sequence | C, CDROM, A | Pořadí bootování — C: první, pak CD-ROM, pak A: |
| Swap Floppy Drive | Disabled | Prohození A:/B: — vypnuto, Gotek je A:, fyzická mechanika B: |
| Boot Up Floppy Seek | Disabled | Test floppy při bootu — vypnuto, ušetří ~2s |
| Boot Up NumLock Status | On | NumLock zapnutý při startu |
| Boot Up System Speed | High | Rychlost systému při bootu — vždy High |
| Typematic Rate Setting | Disabled | Vlastní rychlost opakování kláves — vypnuto (systémová výchozí) |
| Security Option | Setup | Heslo jen pro vstup do BIOSu, ne pro boot |
| PCI/VGA Palette Snoop | Enabled | Nutné pro 3dfx Voodoo2 — bez tohoto jsou barvy v DOS špatně |
| OS Select For DRAM >64MB | Non-OS2 | Non-OS2 pro Windows/DOS — OS2 jen pro IBM OS/2 |
| Report No FDD For WIN95 | No | Hlásit floppy Windows 95/98 — No (mechaniky jsou přítomny) |
| Video BIOS Shadow | Enabled | Zkopíruje ATI Rage Video BIOS do RAM — zrychlí BIOS volání videa |
| C8000-DFFFF Shadow | Disabled | Shadow dalších ROM oblastí — vypnuto, uvolní UMB pro DOS drivery |

---

### Chipset Features Setup

| Položka | Nastavení | Popis |
|---|---|---|
| Auto Configuration | Disabled | Vypnuto — umožňuje ruční nastavení paměťových timingů |
| DRAM Timing | 60ns | Rychlost DRAM — odpovídá nainstalovaným 60ns SDRAM modulům |
| DRAM Leadoff Timing | 10/6/3 | První přístup do paměti — nejrychlejší dostupná hodnota |
| DRAM Read Burst (EDO/FP) | x222/x333 | Rychlost burst čtení — nejrychlejší nastavení |
| DRAM Write Burst Timing | x222 | Rychlost burst zápisu — nejrychlejší nastavení |
| Fast EDO Lead Off | Enabled | Zrychlení EDO — nemá vliv na SDRAM, neškodí |
| Refresh RAS# Assertion | 4 Clks | Délka refresh cyklu — 4 takty je standard |
| Fast RAS To CAS Delay | 2 | Zpoždění RAS→CAS — 2 je nejrychlejší stabilní hodnota |
| DRAM Page Idle Timer | 2 Clks | Jak dlouho držet stránku otevřenou — 2 takty, nejrychlejší |
| DRAM Enhanced Paging | Enabled | Vylepšené page-mode přístupy — zapnuto pro výkon |
| Fast MA to RAS# Delay | 1 Clks | Zpoždění adres→RAS — 1 takt, nejrychlejší |
| SDRAM CAS Lat/RAS-to-CAS | 2/2 | CAS latence a RAS-to-CAS delay — 2/2 nejrychlejší, 60ns SDRAM to unese |
| SDRAM Speculative Read | Disabled | Intel 430TX errata — MUSÍ být Disabled, jinak nestabilita paměti |
| System BIOS Cacheable | Disabled | Cache systémového BIOSu — vypnuto kvůli kompatibilitě s K6-III+ |
| Video BIOS Cacheable | Enabled | Cache Video BIOSu do L2 — zrychlí grafické BIOS volání |
| 8 Bit I/O Recovery Time | 1 | Zotavení 8-bit ISA sběrnice — 1 takt, minimum |
| 16 Bit I/O Recovery Time | 2 | Zotavení 16-bit ISA sběrnice — 2 takty, minimum |
| Memory Hole At 15M-16M | Disabled | Díra v paměti pro ISA karty — nepotřebné, vypnuto |
| PCI 2.1 Compliance | Enabled | PCI 2.1 standard — zapnuto pro správnou funkci PCI karet |

---

### Power Management Setup

| Položka | Nastavení | Popis |
|---|---|---|
| Power Management | Min Saving | Minimální úspora — nutné pro správný Win98SE shutdown na Rhino 15 |
| PM Control by APM | Yes | Řízení spotřeby přes APM — zapnuto pro Win98SE |
| Video Off Method | V/H SYNC+Blank | Metoda vypnutí monitoru při idle |
| Video Off After | Standby | Monitor se vypne při přechodu do Standby |
| MODEM Use IRQ | 3 | IRQ pro wake-up z modemu — bez efektu (Resume by Ring Disabled) |
| Doze Mode | Disabled | První stupeň úspory — vypnuto, Min Saving má velmi dlouhé timeouty |
| Standby Mode | Disabled | Druhý stupeň úspory — vypnuto |
| Suspend Mode | Disabled | Třetí stupeň úspory — vypnuto |
| HDD Power Down | Disabled | Automatické vypnutí disku — vypnuto |
| Throttle Duty Cycle | 62.5% | Škrcení CPU v Doze módu — bez efektu (Doze Disabled) |
| ZZ Active in Suspend | Disabled | CPU ZZ signál v Suspend — vypnuto |
| VGA Active Monitor | Disabled | Monitor jako wake-up zdroj — vypnuto |
| Soft-Off by PWR-BTTN | Instant-Off | Vypínač — okamžité vypnutí |
| CPUFAN Off In Suspend | Enabled | Vypnutí CPU ventilátoru v Suspend — zapnuto |
| Resume by Ring | Disabled | Wake-up přes modem — vypnuto |
| IRQ 8 Break Suspend | Disabled | RTC jako wake-up — vypnuto |
| **Reload Global Timer Events** | | Události které resetují časovač úspory: |
| IRQ[3-7,9-15],NMI | Enabled | Jakýkoliv IRQ (myš, klávesnice, zvuk) resetuje časovač |
| Primary IDE 0 | Enabled | Disková aktivita resetuje časovač |
| Primary IDE 1 | Disabled | |
| Secondary IDE 0 | Enabled | CD-ROM aktivita resetuje časovač |
| Secondary IDE 1 | Disabled | |
| Floppy Disk | Disabled | |
| Serial Port | Enabled | Serial mouse aktivita resetuje časovač |
| Parallel Port | Disabled | LPT vypnuto |

---

### PnP/PCI Configuration

| Položka | Nastavení | Popis |
|---|---|---|
| PNP OS Installed | No | OS neřídí PnP — BIOS přiděluje zdroje (správné pro DOS + Win98SE) |
| Resources Controlled By | Manual | Ruční přidělení IRQ a DMA — nutné pro ISA karty AWE32 a PicoGUS |
| Reset Configuration Data | Disabled | Neresetovat PnP data při bootu |
| IRQ-3 | Legacy ISA | COM2 — serial mouse |
| IRQ-4 | PCI/ISA PnP | COM1 — volný |
| IRQ-5 | Legacy ISA | AWE32 CT3900 |
| IRQ-7 | Legacy ISA | PicoGUS v2.0 (LPT1 vypnut v Integrated Peripherals) |
| IRQ-9 | PCI/ISA PnP | Volný |
| IRQ-10 | PCI/ISA PnP | Volný — pro PCI karty |
| IRQ-11 | Legacy ISA | PIIX4 USB Host Controller |
| IRQ-12 | Legacy ISA | PS/2 myš |
| IRQ-14 | PCI/ISA PnP | Primary IDE |
| IRQ-15 | PCI/ISA PnP | Secondary IDE |
| DMA-0 | PCI/ISA PnP | Volný |
| DMA-1 | Legacy ISA | AWE32 CT3900 (8-bit) |
| DMA-3 | Legacy ISA | PicoGUS v2.0 |
| DMA-5 | Legacy ISA | AWE32 CT3900 (16-bit) |
| DMA-6 | PCI/ISA PnP | Volný |
| DMA-7 | PCI/ISA PnP | Volný |
| PCI IDE IRQ Map To | PCI-AUTO | Automatické mapování PCI IDE IRQ |
| Primary IDE INT# | A | PCI interrupt pro primary IDE |
| Secondary IDE INT# | B | PCI interrupt pro secondary IDE |
| Used MEM Base Addr | N/A | Žádná ISA karta nepotřebuje vyhrazený paměťový region |

---

### Integrated Peripherals

| Položka | Nastavení | Popis |
|---|---|---|
| IDE HDD Block Mode | Enabled | Přenos více sektorů najednou — zrychlí disk, vždy zapnout |
| IDE Primary Master PIO | Auto | PIO mód pro SSD (přes JM20330 adaptér) — Auto |
| IDE Primary Slave PIO | Auto | Slave není připojen |
| IDE Secondary Master PIO | Auto | CD-ROM LG GH22NS40 |
| IDE Secondary Slave PIO | Auto | Slave není připojen |
| IDE Primary Master UDMA | Disabled | JM20330 adaptér má problémy s UDMA na PIIX4 — Disabled vynutí MWDMA/2 |
| IDE Primary Slave UDMA | Auto | Slave není připojen |
| IDE Secondary Master UDMA | Auto | CD-ROM — Auto |
| IDE Secondary Slave UDMA | Auto | Slave není připojen |
| On-Chip Primary PCI IDE | Enabled | Primární IDE řadič — zapnuto |
| On-Chip Secondary PCI IDE | Enabled | Sekundární IDE řadič — zapnuto |
| KBC Input Clock | 8 MHz | Takt klávesnicového řadiče — 8 MHz standard |
| Onboard FDC Controller | Enabled | Floppy řadič — zapnuto (Gotek + fyzická mechanika) |
| Onboard Serial Port 1 | 3F8/IRQ4 | COM1 — standardní adresa |
| Onboard Serial Port 2 | 2F8/IRQ3 | COM2 — standardní adresa, serial mouse |
| UR2 Mode | Standard | Režim druhého serial portu — Standard (ne IrDA) |
| Onboard Parallel Port | Disabled | LPT1 vypnuto — uvolní IRQ7 pro PicoGUS |
| USB Keyboard Support | Enabled | USB klávesnice přes BIOS emulaci — zapnuto |

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
| 11 | PIIX4 USB Host Controller | PCI |
| 12 | Logitech PS/2 Mouse | — |
| 13 | Math Coprocessor | internal |
| 14 | Primary IDE | |
| 15 | Secondary IDE | |

---


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
JP16=Open    →  port 300h
```

**Joystick / Gameport:**
```
JP14=Closed  →  enabled  (gameport/joystick port — MIDI OUT not connected)
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
5. MIDI výstup je nyní na PicoGUS (port 330h) → CME WIDI Thru6 BT splitter
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
REM   BLASTER=A220 I5 D1 H5 P300 E620 T6

REM 2. Check memory — UNISOUND should show no footprint:
MEM /C | MORE

REM 3. Quick OPL3 test — run any AdLib/FM game and listen
REM    Real OPL3 sounds warmer and more accurate than CQM

REM 4. Quick MIDI test — run a MT-32 game, check music plays
REM    through MT-32 via PicoGUS MIDI OUT → CME WIDI Thru6 BT → MT-32
```

If boot shows `DIGN9003` error or UNISOUND fails:
- Verify BLASTER variable is set in AUTOEXEC.BAT
- Verify `/E:1024` is set on the SHELL= line in CONFIG.SYS
- Verify jumpers JP17+JP18 are closed (port 220h must match A220 in BLASTER)

---

### Software changes after swap

**None required.** The BLASTER variable and all drivers remain identical:

```bat
SET BLASTER=A220 I5 D1 H5 P300 E620 T6
```

UNISOUND.COM replaces CTCM.EXE — CT3900 is initialized automatically at boot.
IRQ 5, DMA 1/5 are the card defaults and match this system perfectly.

---

### Post-Installation Checklist

#### Phase 1 — Initial installation (CT3900 + 2× 1MB Samsung)

- [ ] Jumper JP17+JP18 closed — I/O port 220h
- [ ] Jumper JP15 closed — MPU-401 enabled
- [ ] Jumper JP16 open — MPU-401 port 300h
- [ ] Jumper JP14 closed — gameport/joystick enabled
- [ ] Jumpers JP2+JP3 closed — IDE port disabled
- [ ] 2× Samsung KM41C1000CJ-6 installed — both slots, identical modules
- [ ] Jumper JP2 pins 1&2 closed — SIMM enabled
- [ ] CT3900 in ISA slot, bracket screw secured
- [ ] MIDI OUT from PicoGUS connected to CME WIDI Thru6 BT
- [ ] First boot: no error messages, UNISOUND output visible
- [ ] `SET BLASTER` shows `A220 I5 D1 H5 P300 E620 T6`
- [ ] `MEM /C` shows Extended ~2 MB
- [ ] AdLib/FM game plays with correct OPL3 sound (warmer than AWE64 CQM)
- [ ] MT-32 game plays music correctly on port 330h (via PicoGUS → WIDI Thru6 BT)

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
PicoGUS line out (stereo) → QX1222USB CH 1 (L, PAN left) + CH 2 (R, PAN right).

### What this adds to the system

| Before | After |
|---|---|
| GM games require SC-55 or AWEUTIL /EM (conflicts with SoftMPU) | McCake on port 330h — GM via SF2, no conflict |
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
| Port 330h | MPU-401 | 300h taken by AWE32 MPU-401 (unused/gameport not connected) |

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

### Step 2 — Install WP32 McCake onto PicoGUS

Do this before inserting PicoGUS into the PC.

McCake plugs into the **waveblaster header** on PicoGUS — a double-row
pin header typically labeled "WAVE" or "DB" near the top edge of the card.

1. Locate pin 1 on the PicoGUS waveblaster header (marked with a dot,
   triangle, or "1" printed on PCB)
2. Orient McCake so its pin 1 matches the header pin 1
3. Press firmly and evenly — all pins must seat fully
4. McCake should sit flat and parallel to the PicoGUS PCB

McCake draws power from the header — no separate power cable required.
Optionally connect a floppy Molex for additional current headroom.

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
5. Connect PicoGUS line out → QX1222USB **CH 1** (L) + **CH 2** (R)
   (two mono cables or Y-splitter from PicoGUS stereo output)
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
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 330 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1

REM Expected output:
REM   PicoGUS v2.x -- GUS mode
REM   GUS port: 240h  IRQ: 7  DMA: 3
REM   MPU-401: 330h
REM   Wavetable volume: 95

REM 3. Check for conflicts (should show no overlap with AWE32):
MEM /C | MORE

REM 4. Quick X16GS test via DOSMID:
C:\DRIVERS\PICOGUS\DOSMID.EXE /mpu=300 /preset=GS C:\DRIVERS\PICOGUS\Slot1.mid

REM 5. Quick GUS test — run Doom and check music in setup:
REM    SETUP.EXE - Music: Gravis UltraSound (should auto-detect via ULTRASND)
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
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 330 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
```

ULTRASND and ULTRADIR are in the [COMMON] section — loaded in every profile.
PGUSINIT is in each profile separately (NOSOFTMPU, NOSOFTEMU, NORMAL, EMS).

Reboot and verify that the PGUSINIT output is visible during the boot sequence.

---

### Step 8 — Save settings to PicoGUS flash (optional)

After confirming everything works across a full reboot:

```bat
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 330 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1 /save
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
PGUSINIT.EXE /mode gus /mpuport 330 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1 [/save]

/mode gus      GUS emulation mode — use this for all DOS gaming
               Other modes exist (sb, adlib, mpu, usb) but are not
               needed here as AWE32 handles SB16/OPL3 on port 220h — MPU-401 on 300h (gameport, unused)

/mpuport 330   MPU-401 on port 330h
               AWE32 MPU-401 is on 300h (gameport, not connected to MIDI)
               PicoGUS MPU-401 on 330h → WIDI Thru6 BT → MT-32/SC-55/SC-88/MT32-pi

/gusvol 85     GUS audio output volume (0–100)

/wtvol 85      DreamBlaster X16GS wavetable header volume (0–100)
               Hlasitost upravuj na QX1222USB CH 1+2, ne zde

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

QX1222USB: **CH 1+2 (PicoGUS) UP** + CH 3+4 (AWE32) up for effects.

#### GM games via McCake SF2 (without SC-55)

```bat
REM V game setupu:
Sound Effects : Sound Blaster 16   port 220  IRQ 5  DMA 1
Music         : General MIDI
MIDI port     : 330
```

QX1222USB: **CH 1+2 (PicoGUS/McCake) UP** + CH 3+4 (AWE32) for effects.

#### MT-32 games (unchanged — PicoGUS does not affect this)

MT-32 games use port 330h — PicoGUS MPU-401 on 330h → WIDI Thru6 BT → MT-32.
SoftMPU on AWE32 port 300h provides intelligent mode emulation.

```bat
Sound Effects : Sound Blaster   port 220  IRQ 5  DMA 1
Music         : Roland MT-32
MIDI port     : 330
```

QX1222USB: **CH 7+8 (MT-32) UP** + CH 3+4 (AWE32) up for effects.

---

### McCake vs AWEUTIL /EM:GS — Comparison

Before PicoGUS, AWEUTIL /EM:GS was the only GM/GS option without a physical SC-55.
After installation, McCake is the preferred route.

| | McCake SF2 (port 330h) | AWEUTIL /EM:GS (port 300h) |
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
| MPU-401 | 300h (gameport, nepřipojeno) | 330h → WIDI Thru6 BT → MT-32/SC-55/SC-88/MT32-pi + McCake |
| Audio output | QX1222USB CH 3+4 | QX1222USB CH 1+2 |
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
- [ ] McCake (WP32) firmly seated on PicoGUS waveblaster header (pin 1 aligned)
- [ ] PicoGUS in ISA slot, bracket screw secured
- [ ] PicoGUS line out connected to QX1222USB CH 1 (L) + CH 2 (R)
- [ ] `C:\DRIVERS\PICOGUS\` contains PGUSINIT.EXE, DOSMID.EXE, MIDI\ subdirectory
- [ ] Manual test: `PGUSINIT /mode gus /mpuport 330 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1` prints GUS port 240 IRQ 7 DMA 3
- [ ] Manual test: `DOSMID Slot1.mid` plays through headphones on CH 1+2
- [ ] Manual test: Doom plays GUS music (not SB music)
- [x] AUTOEXEC.BAT: ULTRASND, ULTRADIR, PGUSINIT active in all profiles
- [ ] Reboot test: PGUSINIT message visible in boot sequence
- [ ] Optional: `/save` run once to persist settings to flash

---

## WP32 McCake — Installation Guide

**Status:** PicoGUS v2.0 installed and working. McCake pending installation.
**Hardware:** Serdaco WP32 McCake (CM4 Lite), Serdaco MT32Pi Drive Bay Panel 5.25" with OLED display and buttons.
**Connection:** Waveblaster header on PicoGUS + 10-pin cable to drive bay panel.

---

### What you are installing

**WP32 McCake** is a waveblaster-compatible card with a Raspberry Pi Compute Module 4 (CM4 Lite)
running mt32-pi firmware. Plays SF2 soundfonts via the FluidSynth engine and optionally emulates MT-32.

**Serdaco MT32Pi Drive Bay Panel** is a 5.25" bay panel with OLED display (128×32 px),
buttons for switching soundfonts/modes and a volume encoder. Connects to McCake via a 10-pin flat cable.

---

### Before you start

- [ ] Download McCake config: `https://serdaco.com/downloads/?dir=WP32McCake`
      → ZIP contains `mt32-pi.cfg`, `soundfonts/` folder with GeneralUser GS and documentation
- [ ] Download SF2 soundfonts (see SF2 Soundfonts section above)
- [ ] Prepare micro SD card (FAT32 format, 8–32 GB recommended)
- [ ] PC must be powered off and disconnected from mains

---

### Step 1 — Prepare the micro SD card

**On a modern PC:**

1. Format micro SD card as FAT32
2. Download and extract the config ZIP from serdaco.com
3. Copy to the SD card:

```
/ (SD card root)
  mt32-pi.cfg          ← configuration (see below)
  soundfonts/
    GeneralUser_GS.sf2          ← default soundfont (slot 0)
    SC-55_Patch93_v1.9.sf2      ← slot 1
    Timbres_of_Heaven.sf2       ← slot 2 (optional)
  roms/                ← empty folder (MT-32 ROM — not needed, you have a physical MT-32)
```

4. Edit `mt32-pi.cfg` according to settings below

#### mt32-pi.cfg pro tento setup

```ini
[midi]
gpio_baud_rate = 31250

[audio]
output_device = i2s
i2s_dac_init = adafruit-i2s-stemma

[synth]
default_synth = soundfont

[fluidsynth]
soundfont = soundfonts/GeneralUser_GS.sf2
gain = 0.8

[lcd]
type = ssd1306i2c
width = 128
height = 32
```

5. Safely eject the SD card and insert it into McCake (slot on the underside of the board)

---

### Step 2 — Physical installation of McCake onto PicoGUS

**PC must be powered off and disconnected.**

1. Remove PicoGUS from ISA slot (for easier handling)
2. Locate the waveblaster header on PicoGUS — dual-row pin header, labelled "WAVE" or "DB"
3. Orient McCake so that pin 1 aligns with pin 1 of the header (marked on PCB)
4. Press McCake firmly and evenly — all pins must seat properly
5. McCake must sit parallel to the PicoGUS PCB
6. Reinsert PicoGUS into the ISA slot and secure with screw

> ⚠️ McCake is powered from the waveblaster header (5V). No extra power cable is needed
> if the header provides sufficient current. Alternatively, connect a floppy Molex connector
> directly to McCake.

---

### Krok 3 — Instalace drive bay panelu

Mount the drive bay panel in a free **5.25" bay**.

1. Slide the panel into the 5.25" bay and secure with screws
2. Connect the panel to McCake via the **10-pin flat cable** (supplied with the Serdaco panel)
   - Cable goes into the connector labelled "PANEL" or "OLED" on the McCake PCB
   - Ensure pin 1 is aligned (coloured stripe on cable = pin 1)
3. OLED display and buttons are now accessible from the front of the case

> The panel requires the cable to be connected before powering on the PC — do not power on
> without the panel connected unless McCake is running in headless mode.

---

### Step 4 — First boot

1. Zapni PC — bootuj do profilu **NORMAL** nebo **BARE**
2. McCake boots independently — OLED display should show:
   ```
   mt32-pi
   FluidSynth
   GeneralUser GS
   ```
   (or similar status text — depends on mt32-pi version)
3. If OLED is blank or shows garbage — check panel cable and `mt32-pi.cfg`
4. Wait ~10–15 seconds for mt32-pi to load the soundfont — longer for larger SF2 files

---

### Krok 5 — Test z DOSu

McCake responds on port 330h (PicoGUS MPU-401 header). Test:

```bat
REM Download MT32-PI.EXE from https://github.com/gmcn42/mt32-pi-control
REM Save to C:\DRIVERS\PICOGUS\

REM Test mode switching:
MT32-PI.EXE -p 330 -g         ← switch to GM/SF2 mode
MT32-PI.EXE -p 330 -m         ← switch to MT-32 emulation mode
MT32-PI.EXE -p 330 -r         ← reset (bez restartu Pi)
MT32-PI.EXE -p 330 -f 0       ← switch to soundfont slot 0
MT32-PI.EXE -p 330 -f 1       ← switch to soundfont slot 1

REM Test playback — launch a game with MPU profile:
MPU DOOM.EXE                  ← MIDI na port 330h (PicoGUS MPU mode), GM soundfont
```

Or use DOSMID via PicoGUS (GUS mode, not McCake):
```bat
CD C:\DRIVERS\PICOGUS
DOSMID Slot1.mid
```

---

### Step 6 — Switching soundfonts and modes

**Z drive bay panelu:**
- Button **S** — toggles between SF2 and MT-32 emulation
- Button **▲/▼** — switches soundfonts (SF2 mode) or MT-32 ROM sets (MT-32 mode)
- Encoder — volume

**From DOS via MT32-PI.EXE:**
```bat
MT32-PI.EXE -p 330 -f 0       ← slot 0 (GeneralUser GS)
MT32-PI.EXE -p 330 -f 1       ← slot 1 (SC-55 Patch93)
MT32-PI.EXE -p 330 -f 2       ← slot 2 (Timbres of Heaven)
```

**Via MPU.BAT** (automatically switches PicoGUS to MPU-401 mode before the game):
```bat
MPU GAME.EXE     ← launches game with McCake on port 330h
```

---

### Post-Installation Checklist — McCake

- [ ] micro SD card inserted into McCake (slot on underside)
- [ ] SD karta obsahuje mt32-pi.cfg, soundfonts/ se SF2 soubory
- [ ] McCake fyzicky usazena na PicoGUS waveblaster header (pin 1 aligned)
- [ ] Drive bay panel installed in 5.25" bay, cable connected to McCake
- [ ] First boot: OLED display shows status, loading soundfont
- [ ] Test from DOS: MT32-PI.EXE -p 330 -g reports no error
- [ ] Playback test: GM game on port 330h plays through McCake (audible on CH 1+2, shared with PicoGUS)
- [ ] MT32-PI.EXE saved to C:\DRIVERS\PICOGUS\
- [ ] QX1222USB CH 1+2 has adequate volume (McCake shares PicoGUS line out)

---


---


---

## Audio Routing — Behringer QX1222USB

### Channel Assignment

| QX1222USB Channel | Source | Signal |
|---|---|---|
| CH 1 (MONO) | PicoGUS Left | PAN fully left |
| CH 2 (MONO) | PicoGUS Right | PAN fully right |
| CH 3 (MONO) | AWE32 CT3900 Left | PAN fully left |
| CH 4 (MONO) | AWE32 CT3900 Right | PAN fully right |
| CH 5+6 (STEREO) | MT32-pi (SF2) — external | stereo |
| CH 7+8 (STEREO) | Roland MT-32 original | stereo |
| CH 9+10 (STEREO) | Roland SC-55 MK2 original | stereo |
| CH 11+12 (STEREO) | Roland SC-88 Pro original | stereo |
| 2-TR (STEREO) | Second PC — Windows XP | stereo |
| PHONES | Audio-Technica ATH-M50x | headphone monitoring |
| MAIN OUT (XLR) | → recording / monitors | — |

### Signal Flow

```
PicoGUS L      ──────────────────────► CH 1 (PAN left)   ─┐
PicoGUS R      ──────────────────────► CH 2 (PAN right)  ─┤
AWE32 L        ──────────────────────► CH 3 (PAN left)   ─┤
AWE32 R        ──────────────────────► CH 4 (PAN right)  ─┤
MT32-pi SF2    ──────────────────────► CH 5+6            ─┤
MT-32 orig.    ──────────────────────► CH 7+8            ─┼──► MAIN MIX ──► MAIN OUT (XLR)
SC-55 MK2      ──────────────────────► CH 9+10           ─┤         │
SC-88 Pro      ──────────────────────► CH 11+12          ─┤         │
Second PC (XP) ──────────────────────► 2-TR              ─┘         │
                                                                    │
                                                  ATH-M50x ◄── PHONES
```

### MIDI Hardware Chain

```
PicoGUS MIDI OUT (port 330h)
        │
        ▼
  CME WIDI Thru6 BT
  (2-in / 6-out, Bluetooth 5, 32-bit, USB-C napájení)
    ┌───┼───┬───────┐
    │   │   │       │
    ▼   ▼   ▼       ▼
 MT32-pi  MT-32  SC-55 MK2  SC-88 Pro
 (SF2)   orig.   orig.      orig.
 CH 5+6  CH 7+8  CH 9+10   CH 11+12
```

AWE32 nemá MIDI výstup připojený — gameport není použit pro MIDI.
McCake (WP32) — interní wavetable na PicoGUS wavetable headeru, aktivní v MPU profilech.
CME WIDI Thru6 BT podporuje i Bluetooth MIDI (BLE 5, 3ms latency, dosah 20m) — lze připojit iOS/Android/PC bezdrátově.

### Mixer Operation — which faders to raise

The QX1222USB has no mute buttons on stereo channels — use the faders.
AWE32 (CH 3+4) is almost always up for sound effects.
Adjust the music source channel depending on the game.

| Game type | CH 1+2 PicoGUS | CH 3+4 AWE32 | CH 5+6 MT32-pi | CH 7+8 MT-32 | CH 9+10 SC-55 | CH 11+12 SC-88 |
|---|---|---|---|---|---|---|
| MT-32 games | down | up (FX) | down | **UP** | down | down |
| GM/GS — SC-55 | down | up (FX) | down | down | **UP** | down |
| GM/GS — SC-88 Pro | down | up (FX) | down | down | down | **UP** |
| GM — MT32-pi SF2 | down | up (FX) | **UP** | down | down | down |
| GUS games | **UP** | up (FX) | down | down | down | down |
| AWE32 native | down | **UP** (all) | down | down | down | down |
| OPL3/AdLib only | down | **UP** (all) | down | down | down | down |

---


---

## Sound Device Reference

| Device | Port | IRQ | DMA | Type |
|---|---|---|---|---|
| AWE32 SB16 | 220h | 5 | 1 / 5 | Sound effects, real OPL3 |
| AWE32 MPU-401 | 300h | 5 | — | nepřipojeno — gameport nepoužit |
| PicoGUS GUS | 240h | 7 | 3 | GUS music |
| PicoGUS MPU-401 | 330h | 7 | — | McCake (wavetable) + MIDI splitter → MT-32/SC-55/SC-88/MT32-pi |

---


---

---

# FAT32 — MS-DOS 7.1 + Windows 98SE

> Verbatim Vi560 256GB M.2 SATA III → Ableconn IDE40-SAT → PIIX4
> C: FAT32 8GB (DOS+Win98SE) · D: FAT32 ~230GB (Games+Data)

## FAT32 — Disk Installation


```
Verbatim Vi560 256GB M.2 SATA III
    ↓ AXAGON RSS-M2SD (M.2 SATA → 2.5" SATA)
    ↓ Ableconn IDE40-SAT (SATA → 40-pin IDE, Marvell 88SA8052)
    ↓ 80-conductor IDE cable
    ↓ Rhino 15 IDE controller (PIIX4, UDMA/33 max)
```

---


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

> **See current configuration in the section below.**


### Step 16 — Write AUTOEXEC.BAT (temporary)

> **See current configuration in the section below.**


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

> **See current configuration in the section below.**


### Step 24 — Replace AUTOEXEC.BAT with full multi-boot version

> **See current configuration in the section below.**


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
  2. MS-DOS  NOEMS  - 607KB conventional
  3. MS-DOS  EMS    - 595KB conventional (DOS extenders)
  4. MS-DOS  Bare   - no drivers
```

Výběr NOEMS nebo EMS otevře podmenu s dalšími profily.

Default: Windows 98SE (10 second countdown)

### Step 28 — Test each option

| Test | Expected result |
|---|---|
| Option 1 (Windows) | Windows 98SE loads, desktop appears |
| Option 2 (NOEMS podmenu) | Zobrazí podmenu s NOEMS profily |
| Option 3 (EMS podmenu) | Zobrazí podmenu s EMS profily |
| NORMAL (z podmenu) | DOS prompt, phys CD-ROM, sound card active |
| MPU (z podmenu) | DOS prompt, PicoGUS MPU-401, McCake active |
| Option 4 (BARE) | Minimal DOS prompt, no drivers |

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
- MPU-401 Compatible, IRQ 9, port 330h

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
| NORMAL | NOEMS | No | Everyday DOS, phys CD, AWEUTIL /S |
| EMS | Yes | Yes | Tyrian, Magic Carpet, Unreal, DOS extenders |
| NOSOFTMPU | No | No | AWEUTIL /EM emulation |
| NOSOFTEMU | No | Yes | AWEUTIL /EM + EMS games |
| BARE | No | No | Diagnostics, installation |

---

## FAT32 — Boot Menu Profiles

| # | Profile | Mode | Conv. RAM | Use for |
|---|---|---|---|---|
| 1 | WINDOWS | Win98SE boot | — | Windows 98SE |
| 2 | NORMAL (NOEMS podmenu) | NOEMS | 607 KB | Everyday DOS, phys CD, AWEUTIL /S |
| 3 | ISOCD (NOEMS podmenu) | NOEMS | 607 KB | Virtual ISO CD-ROM |
| 4 | MPU (NOEMS podmenu) | NOEMS | 607 KB | McCake GM/MT-32, PicoGUS MPU-401, phys CD |
| 5 | ESPNS (NOEMS podmenu) | NOEMS | 607 KB | AWEUTIL /EM + ESP32 CD-ROM |
| 6 | NORMEMS (EMS podmenu) | RAM | 595 KB | Everyday DOS + DOS extenders |
| 7 | ISOCDEMS (EMS podmenu) | RAM | 595 KB | Virtual ISO CD-ROM + extenders |
| 8 | MPUEMS (EMS podmenu) | RAM | 595 KB | McCake GM/MT-32 + DOS extenders, phys CD |
| 9 | ESPNES (EMS podmenu) | RAM | 595 KB | AWEUTIL /EM + ESP32 CD-ROM + extenders |
| 10 | BARE | NOEMS | max | Diagnostics, no drivers |

Default: **WINDOWS** (auto-boot after 10 seconds)

**MPU profiles note:** PicoGUS switches to MPU-401 intelligent mode — no SoftMPU needed. McCake (WP32) on wavetable header provides GM/MT-32 on port 330h. Configure in-game MIDI: port 330h, General MIDI or MT-32.


---

## FAT32 — CONFIG.SYS

```
;===========================================
; CONFIG.SYS - Boot menu
; Rhino 15 / Pentium MMX / AWE32 CT3900 / Voodoo2 / ATI MACH64
; MS-DOS 7.10 + Windows 98SE
;===========================================

; Boot menu - displayed at startup with 10 second countdown
; MENUDEFAULT=WINDOWS,10 = auto-boot Windows after 10 seconds if no key pressed
; Main menu: 4 items
[MENU]
MENUITEM=WINDOWS,  Windows 98SE
SUBMENU=NOEMS,     MS-DOS  NOEMS  - 607KB conventional
SUBMENU=EMS,       MS-DOS  EMS    - 595KB conventional (DOS extenders)
MENUITEM=BARE,     MS-DOS  Bare   - no drivers
MENUDEFAULT=WINDOWS,10

; NOEMS sub-menu: SoftMPU, No SoftMPU, ISO CD, MPU-401, MPU-401 ISO
[NOEMS]
MENUITEM=NORMAL,     Normal CD-ROM         - NOEMS 607KB  (phys CD)
MENUITEM=MPU,        MPU-401 CD-ROM        - NOEMS 607KB  (MPU-401 IRQ, phys CD)
MENUITEM=ISOCD,      ISO CD-ROM            - NOEMS 607KB  (virtual CD)
MENUITEM=ESPNS,      ESP32 No SoftMPU      - NOEMS 607KB  (ESP32 CD)

; EMS sub-menu: SoftMPU EMS, No SoftMPU EMS, ISO CD EMS, MPU-401 EMS, MPU-401 ISO EMS
[EMS]
MENUITEM=NORMEMS,    Normal CD-ROM EMS     - RAM   595KB  (phys CD + EMS)
MENUITEM=MPUEMS,     MPU-401 CD-ROM EMS    - RAM   595KB  (MPU-401 IRQ, phys CD + EMS)
MENUITEM=ISOCDEMS,   ISO CD-ROM EMS        - RAM   595KB  (virtual CD + EMS)
MENUITEM=ESPNES,     ESP32 No SoftMPU EMS  - RAM   595KB  (ESP32 CD + EMS)
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

; FILES=30 - max open file handles (NC + SHSUCDX need ~25)
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

; Samsung CD-ROM driver - needed so SHSUCDX in AUTOEXEC.BAT can load
; Windows will replace this with its own 32-bit CD-ROM driver after boot
DEVICEHIGH=C:\DRIVERS\SAMSUNG\SSCDROM.SYS /D:SSCD000
[NORMAL]

; EMM386 NOEMS - no EMS, maximum UMB space
DEVICE=C:\WINDOWS\EMM386.EXE NOEMS
INSTALLHIGH=C:\DRIVERS\SHSUCDX\SMARTCDX.EXE /X 2048 512
DEVICEHIGH=C:\DRIVERS\SAMSUNG\SSCDROM.SYS /D:SSCD000

; -----------------------------------------------
; Profile NORMEMS - RAM (EMS), physical CD-ROM (595KB conventional)
; Use for: DOS extender games, phys CD-ROM
; -----------------------------------------------
[NORMEMS]

; EMM386 RAM - EMS enabled for games that need it
DEVICE=C:\WINDOWS\EMM386.EXE RAM
INSTALLHIGH=C:\DRIVERS\SHSUCDX\SMARTCDX.EXE /X 2048 512
DEVICEHIGH=C:\DRIVERS\SAMSUNG\SSCDROM.SYS /D:SSCD000

; -----------------------------------------------
; Profile ISOCD - NOEMS with virtual ISO CD-ROM
; Use for: Running games from ISO images on D:\ISOS\
; Physical Samsung CD-ROM NOT loaded - saves UMB space
; SHSUCDHD.EXE + SHSUCDX.COM loaded in AUTOEXEC.BAT
; Download: http://adoxa.altervista.org/shsucdx/ -> SHSUCD r3-7
; -----------------------------------------------
[ISOCD]

; EMM386 NOEMS - same as NORMAL, no physical CD-ROM driver loaded
DEVICE=C:\WINDOWS\EMM386.EXE NOEMS
INSTALLHIGH=C:\DRIVERS\SHSUCDX\SMARTCDX.EXE /X 2048 512

; -----------------------------------------------
; Profile ISOCDEMS - RAM (EMS) with virtual ISO CD-ROM
; Use for: DOS extender games from ISO (Tyrian, Magic Carpet, Unreal)
; Physical Samsung CD-ROM NOT loaded - saves UMB space
; 12KB less conventional memory than ISOCD due to EMS page frame
; -----------------------------------------------
[ISOCDEMS]

; EMM386 RAM = EMS + UMB both enabled
DEVICE=C:\WINDOWS\EMM386.EXE RAM
INSTALLHIGH=C:\DRIVERS\SHSUCDX\SMARTCDX.EXE /X 2048 512

; -----------------------------------------------
; Profile MPU - NOEMS, PicoGUS in MPU-401 mode, physical CD-ROM
; Use for: GM/MT-32 games via McCake (port 300h), physical disc
; PicoGUS: MPU-401 intelligent mode (McCake on wavetable header)
; No SoftMPU needed - PicoGUS handles intelligent mode natively
; -----------------------------------------------
[MPU]

DEVICE=C:\WINDOWS\EMM386.EXE NOEMS
INSTALLHIGH=C:\DRIVERS\SHSUCDX\SMARTCDX.EXE /X 2048 512
DEVICEHIGH=C:\DRIVERS\SAMSUNG\SSCDROM.SYS /D:SSCD000

; -----------------------------------------------
; Profile MPUEMS - RAM (EMS), PicoGUS MPU-401 mode, physical CD-ROM
; Use for: GM/MT-32 games + DOS extenders, physical disc
; -----------------------------------------------
[MPUEMS]

DEVICE=C:\WINDOWS\EMM386.EXE RAM
INSTALLHIGH=C:\DRIVERS\SHSUCDX\SMARTCDX.EXE /X 2048 512
DEVICEHIGH=C:\DRIVERS\SAMSUNG\SSCDROM.SYS /D:SSCD000
[ESPNS]

DEVICE=C:\WINDOWS\EMM386.EXE NOEMS
INSTALLHIGH=C:\DRIVERS\SHSUCDX\SMARTCDX.EXE /X 2048 512
DEVICEHIGH=C:\DRIVERS\USBCD\USBASPI1.SYS /w /v
DEVICEHIGH=C:\DRIVERS\USBCD\USBCD1.SYS /D:ESPCD0
[ESPNES]

DEVICE=C:\WINDOWS\EMM386.EXE RAM
INSTALLHIGH=C:\DRIVERS\SHSUCDX\SMARTCDX.EXE /X 2048 512
DEVICEHIGH=C:\DRIVERS\USBCD\USBASPI1.SYS /w /v
DEVICEHIGH=C:\DRIVERS\USBCD\USBCD1.SYS /D:ESPCD0
[BARE]

; Minimal EMM386 for XMS access only
DEVICE=C:\WINDOWS\EMM386.EXE NOEMS
```

---

## FAT32 — AUTOEXEC.BAT

```bat
@ECHO OFF
PROMPT $P$G
PATH C:\DOS;C:\NC;C:\TOOLS\NU;C:\DRIVERS\PICOGUS;C:\DRIVERS\SB16;C:\DRIVERS\SCRIPTS

REM --- Environment variables ---
SET SYMANTEC=C:\SYMANTEC
SET NU=C:\TOOLS\NU
SET TEMP=C:\DOS\TMP
SET TMP=C:\DOS\TMP
SET TELIX=C:\TOOLS\TELIX

REM --- AWE32 CT3900 settings ---
REM A220=SB16 port, I5=IRQ, D1=DMA 8bit, H5=DMA 16bit
REM P300=MPU-401 port (MT-32/SC-55 chain), E620=EMU8000, T6=SB16/AWE type
REM CT3900 semi-PnP: UNISOUND programs IRQ/DMA from these values
REM Valid values: IRQ 2/5/7/10, Low DMA 0/1/3, High DMA 5/6/7
SET SOUND=C:\DRIVERS\SB16
SET BLASTER=A220 I5 D1 H5 P300 E620 T6 
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
REM /mpuport 330 = MPU-401 on port 330h - needed for McCake under Windows
REM /mainvol 95  = master output 95% (headroom to prevent clipping)
REM /gusvol 95   = GUS output 95%
REM /wtvol 95    = wavetable header output 95%
REM /mpudelay 1  = slow down SysEx for Roland-compatible synthesizers
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 330 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
ECHO.
ECHO  [SOUND ENVIRONMENT]
ECHO  BLASTER : %BLASTER%
ECHO  MIDI    : %MIDI%
ECHO  SOUND   : %SOUND%
ECHO  ULTRASND: %ULTRASND%
ECHO  ULTRADIR: %ULTRADIR%
ECHO.

REM --- CD-ROM ---
REM /Q = quiet mode (no drive letter announcement)
LH C:\DRIVERS\SHSUCDX\SHSUCDX.COM /D:SSCD000 /Q

REM --- Mouse ---
REM /R2 = horizontal resolution 2 (movement sensitivity)
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2

REM --- Launch Windows 98SE ---
WIN.COM
GOTO END

REM -----------------------------------------------
REM Profile: NORMAL - NOEMS, physical CD-ROM, everyday
REM Use for: AWEUTIL /EM:GM/GS/MT32 emulation
REM -----------------------------------------------
:NORMAL
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
REM /mpuport 330 = MPU-401 on port 330h (AWE32 uses 300h - must not conflict)
REM /mainvol 95  = master output 95% (headroom to prevent clipping)
REM /gusvol 95   = GUS output 95%
REM /wtvol 95    = wavetable header output 95%
REM /mpudelay 1  = slow down SysEx for Roland-compatible synthesizers
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 330 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
ECHO.
ECHO  [SOUND ENVIRONMENT]
ECHO  BLASTER : %BLASTER%
ECHO  MIDI    : %MIDI%
ECHO  SOUND   : %SOUND%
ECHO  ULTRASND: %ULTRASND%
ECHO  ULTRADIR: %ULTRADIR%
ECHO.

REM --- CD-ROM ---
LH C:\DRIVERS\SHSUCDX\SHSUCDX.COM /D:SSCD000 /Q

REM --- Mouse ---
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END

REM -----------------------------------------------
REM Profile: NORMEMS - RAM (EMS), physical CD-ROM
REM Use for: AWEUTIL /EM + EMS memory
REM -----------------------------------------------
:MPU
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90
C:\DRIVERS\SB16\AWEUTIL.COM /S
REM --- PicoGUS in MPU-401 intelligent mode ---
REM No SoftMPU needed - PicoGUS handles intelligent mode natively
REM McCake (WP32) on wavetable header: GM/MT-32 on port 330h
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode mpu /mpuport 330 /mainvol 95 /wtvol 95 /mpudelay 1
ECHO.
ECHO  [SOUND ENVIRONMENT - MPU-401 MODE]
ECHO  BLASTER : %BLASTER%
ECHO  MIDI    : %MIDI%
ECHO  SOUND   : %SOUND%
ECHO  McCake  : port 330h (GM/MT-32 via wavetable header)
ECHO.
LH C:\DRIVERS\SHSUCDX\SHSUCDX.COM /D:SSCD000 /Q
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END

REM -----------------------------------------------
REM Profile: MPUEMS - RAM (EMS), PicoGUS MPU-401, physical CD-ROM
REM Use for: GM/MT-32 games + DOS extenders, physical disc
REM -----------------------------------------------
:ISOCD
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90
C:\DRIVERS\SB16\AWEUTIL.COM /S
LH C:\DRIVERS\SOFTMPU\SOFTMPU.EXE /MPU:300 /SB:220 /IRQ:5
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 330 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
ECHO.
ECHO  [SOUND ENVIRONMENT]
ECHO  BLASTER : %BLASTER%
ECHO  MIDI    : %MIDI%
ECHO  SOUND   : %SOUND%
ECHO  ULTRASND: %ULTRASND%
ECHO  ULTRADIR: %ULTRADIR%
ECHO.
REM --- Virtual ISO CD-ROM ---
REM SHSUCDHD: mounts ISO file as virtual CD device SHSU-CDH
REM /F: = default ISO to mount at boot (switch later with ISO.BAT)
REM SHSUCDX: exposes SHSU-CDH as a drive letter (replaces MSCDEX)
REM /Q = quiet, /I = override any existing MSCDEX
LH C:\DRIVERS\SHSUCDX\SHSUCDHD.EXE /F:D:\ISOS\DEFAULT.ISO
LH C:\DRIVERS\SHSUCDX\SHSUCDX.COM /D:SHSU-CDH /Q
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END

REM -----------------------------------------------
REM Profile: ISOCDEMS - RAM (EMS) with virtual ISO CD-ROM
REM Use for: DOS extender games from ISO (Tyrian, Magic Carpet, Unreal)
REM Physical Samsung CD-ROM NOT loaded
REM To switch ISO at runtime: ISO D:\ISOS\GAME.ISO
REM -----------------------------------------------
:ESPNS
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90
C:\DRIVERS\SB16\AWEUTIL.COM /S
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 330 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
ECHO.
ECHO  [SOUND ENVIRONMENT - ESP32-S3 CD-ROM]
ECHO  BLASTER : %BLASTER%
ECHO  MIDI    : %MIDI%
ECHO  ULTRASND: %ULTRASND%
ECHO  ESP32CD : drive letter auto-assigned by SHSUCDX
ECHO.
LH C:\DRIVERS\SHSUCDX\SHSUCDX.COM /D:ESPCD0 /Q
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END
:NORMEMS
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90
C:\DRIVERS\SB16\AWEUTIL.COM /S
REM --- SoftMPU NOT loaded ---
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 330 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
ECHO.
ECHO  [SOUND ENVIRONMENT]
ECHO  BLASTER : %BLASTER%
ECHO  MIDI    : %MIDI%
ECHO  SOUND   : %SOUND%
ECHO  ULTRASND: %ULTRASND%
ECHO  ULTRADIR: %ULTRADIR%
ECHO.
LH C:\DRIVERS\SHSUCDX\SHSUCDX.COM /D:SSCD000 /Q
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END
:MPUEMS
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90
C:\DRIVERS\SB16\AWEUTIL.COM /S
REM --- PicoGUS in MPU-401 intelligent mode ---
REM No SoftMPU needed - PicoGUS handles intelligent mode natively
REM McCake (WP32) on wavetable header: GM/MT-32 on port 330h
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode mpu /mpuport 330 /mainvol 95 /wtvol 95 /mpudelay 1
ECHO.
ECHO  [SOUND ENVIRONMENT - MPU-401 MODE]
ECHO  BLASTER : %BLASTER%
ECHO  MIDI    : %MIDI%
ECHO  SOUND   : %SOUND%
ECHO  McCake  : port 330h (GM/MT-32 via wavetable header)
ECHO.
LH C:\DRIVERS\SHSUCDX\SHSUCDX.COM /D:SSCD000 /Q
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END
:ISOCDEMS
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90
C:\DRIVERS\SB16\AWEUTIL.COM /S
LH C:\DRIVERS\SOFTMPU\SOFTMPU.EXE /MPU:300 /SB:220 /IRQ:5
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 330 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
ECHO.
ECHO  [SOUND ENVIRONMENT]
ECHO  BLASTER : %BLASTER%
ECHO  MIDI    : %MIDI%
ECHO  SOUND   : %SOUND%
ECHO  ULTRASND: %ULTRASND%
ECHO  ULTRADIR: %ULTRADIR%
ECHO.
REM --- Virtual ISO CD-ROM ---
LH C:\DRIVERS\SHSUCDX\SHSUCDHD.EXE /F:D:\ISOS\DEFAULT.ISO
LH C:\DRIVERS\SHSUCDX\SHSUCDX.COM /D:SHSU-CDH /Q
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END

REM -----------------------------------------------
REM Profile: MPU - NOEMS, PicoGUS MPU-401, physical CD-ROM
REM Use for: GM/MT-32 games via McCake (port 330h), physical disc
REM In-game MIDI: port 330h, General MIDI or MT-32
REM -----------------------------------------------
:ESPNES
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90
C:\DRIVERS\SB16\AWEUTIL.COM /S
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 330 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
ECHO.
ECHO  [SOUND ENVIRONMENT - ESP32-S3 CD-ROM]
ECHO  BLASTER : %BLASTER%
ECHO  MIDI    : %MIDI%
ECHO  ULTRASND: %ULTRASND%
ECHO  ESP32CD : drive letter auto-assigned by SHSUCDX
ECHO.
LH C:\DRIVERS\SHSUCDX\SHSUCDX.COM /D:ESPCD0 /Q
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END
:BARE
GOTO END

:END
REM --- Norton Commander ---
NC
```

---x x x x x x x x x x x x x x x x x x x x x x x x x x x
; x x x x x x x x x x x x x x x x x x x x x x x x x x x x
; x x x x x x x x x x x x x x x x x x x x x x x x x x x x
; x x x x x x x x x x x x x x x x x x x x x x x x x x x x
; x x x x x x x x x x x x x x x x x x x x x x x x x x x x
; x x x x x x x x x x x x x x x x x x x x x x x x x x x x
;=================================================================
```

---

# DOS 6.22

> FAT16 · C: up to 2GB · separate disk from FAT32

## DOS 6.22 — Boot Menu Profiles

| # | Profile | Mode | Conv. RAM | Use for |
|---|---|---|---|---|
| 1 | NOSOFTMPU | NOEMS | 607 KB | AWEUTIL /EM:GM/GS/MT32 |
| 2 | NOSOFTEMU | RAM | 595 KB | AWEUTIL /EM + DOS extenders |
| 3 | NORMAL | NOEMS + SoftMPU | 607 KB | MT-32, GUS, everyday DOS |
| 4 | EMS | RAM + SoftMPU | 595 KB | Tyrian, Magic Carpet (DOS extenders) |
| 5 | BARE | NOEMS | max | Diagnostics, no drivers |

Default: **NOSOFTMPU** (auto-boot after 10 seconds)


---

## DOS 6.22 — CONFIG.SYS

```
;===========================================
; CONFIG.SYS - Boot menu
; Rhino 15 / Pentium MMX / AWE32 CT3900 / Voodoo2 / ATI MACH64
; MS-DOS 6.22
;===========================================

; Boot menu - displayed at startup with 10 second countdown
[MENU]
MENUITEM=NORMAL,Normal          - NOEMS 607KB
MENUITEM=EMS,   EMS/Games       - RAM   595KB (DOS extenders, old games)
MENUITEM=BARE,  Bare DOS        - no drivers
; Default profile if no key is pressed within timeout
MENUDEFAULT=NORMAL,10
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

; 3) Larger environment block - prevents DIGN9003 error from AWE64
;    /E:1024 = 1024 bytes for SET variables
SHELL=C:\COMMAND.COM C:\ /E:1024 /P

; --- System settings ---
; FILES=30  - max open file handles (NC + SHSUCDX need ~25)
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
INSTALLHIGH=C:\DOS\SMARTCDX.EXE /X 2048 512

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
INSTALLHIGH=C:\DOS\SMARTCDX.EXE /X 2048 512

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

## DOS 6.22 — AUTOEXEC.BAT

```bat
@ECHO OFF
PROMPT $P$G
PATH C:\DOS;C:\NC;C:\TOOLS\NU;C:\DRIVERS\PICOGUS;C:\DRIVERS\SB16;C:\DRIVERS\SCRIPTS

REM --- Environment variables ---
SET SYMANTEC=C:\SYMANTEC
SET NU=C:\TOOLS\NU
SET TEMP=C:\DOS\TMP
SET TMP=C:\DOS\TMP
SET TELIX=C:\TOOLS\TELIX

REM --- AWE32 CT3900 settings ---
REM A220=SB16 port, I5=IRQ, D1=DMA 8bit, H5=DMA 16bit
REM P300=MPU-401 port (AWE32 gameport — not connected to MIDI), E620=EMU8000, T6=SB16/AWE type
REM CT3900 semi-PnP: UNISOUND programs IRQ/DMA from these values
REM Valid values: IRQ 2/5/7/10, Low DMA 0/1/3, High DMA 5/6/7
SET SOUND=C:\DRIVERS\SB16
SET BLASTER=A220 I5 D1 H5 P300 E620 T6
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
REM Profile 1: NOSOFTMPU - NOEMS without SoftMPU
REM Use for: AWEUTIL /EM:GM/GS/MT32 emulation
REM           GM/GS games via AWEUTIL without MT-32/SC-55
REM -----------------------------------------------
:NOSOFTMPU
REM --- AWE32 CT3900 hardware init (UNISOUND) ---
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90

REM --- AWEUTIL - EMU8000 init ---
REM /S = hardware init only, 0KB memory resident
REM This profile has no SoftMPU - AWEUTIL /EM:* can run without conflict
REM   LH C:\DRIVERS\SB16\AWEUTIL.COM /EM:GM    General MIDI emulation
REM   LH C:\DRIVERS\SB16\AWEUTIL.COM /EM:GS    Roland GS emulation
REM   LH C:\DRIVERS\SB16\AWEUTIL.COM /EM:MT32  Roland MT-32 emulation
REM   C:\DRIVERS\SB16\AWEUTIL.COM /U           unload from memory
C:\DRIVERS\SB16\AWEUTIL.COM /S

REM --- SoftMPU NOT loaded - AWEUTIL /EM can run without conflict ---

REM --- PicoGUS initialization ---
REM /mainvol 95 = master output 95% (headroom to prevent clipping)
REM /gusvol 95  = GUS output 95%
REM /wtvol 95   = wavetable header output 95%
REM /mpudelay 1 = slow down SysEx for Roland-compatible synthesizers
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 330 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
ECHO.
ECHO  [SOUND ENVIRONMENT]
ECHO  BLASTER : %BLASTER%
ECHO  MIDI    : %MIDI%
ECHO  SOUND   : %SOUND%
ECHO  ULTRASND: %ULTRASND%
ECHO  ULTRADIR: %ULTRADIR%
ECHO.

REM --- CD-ROM ---
LH C:\DRIVERS\SHSUCDX\SHSUCDX.COM /D:SSCD000 /Q

REM --- Mouse ---
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END

REM -----------------------------------------------
REM Profile 2: NOSOFTEMU - EMS without SoftMPU
REM Use for: AWEUTIL /EM + DOS extender games
REM Note: AWEUTIL /EM does not work with DOS extenders (DOS4GW)
REM       For extender games use profile 4 (EMS with SoftMPU)
REM -----------------------------------------------
:NOSOFTEMU
REM --- AWE32 CT3900 hardware init (UNISOUND) ---
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90

REM --- AWEUTIL - EMU8000 init ---
C:\DRIVERS\SB16\AWEUTIL.COM /S

REM --- SoftMPU NOT loaded ---

REM --- PicoGUS initialization ---
REM /mainvol 95 = master output 95% (headroom to prevent clipping)
REM /gusvol 95  = GUS output 95%
REM /wtvol 95   = wavetable header output 95%
REM /mpudelay 1 = slow down SysEx for Roland-compatible synthesizers
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 330 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
ECHO.
ECHO  [SOUND ENVIRONMENT]
ECHO  BLASTER : %BLASTER%
ECHO  MIDI    : %MIDI%
ECHO  SOUND   : %SOUND%
ECHO  ULTRASND: %ULTRASND%
ECHO  ULTRADIR: %ULTRADIR%
ECHO.

REM --- CD-ROM ---
LH C:\DRIVERS\SHSUCDX\SHSUCDX.COM /D:SSCD000 /Q

REM --- Mouse ---
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END

REM -----------------------------------------------
REM Profile 3: NORMAL - NOEMS with SoftMPU
REM Use for: MT-32 games (Sierra, LucasArts), GUS games, everyday use
REM           AWE32 native games, SC-55, McCake
REM -----------------------------------------------
:NORMAL
REM --- AWE32 CT3900 hardware init (UNISOUND) ---
REM Initializes: IRQ, DMA, I/O ports, OPL3, mixer
REM CT3900 semi-PnP: UNISOUND programs IRQ/DMA from BLASTER variable
REM /V70 = master volume 70 (range 0-100)
REM /VF90 = FM/OPL3 volume 90 - real Yamaha OPL3 chip (CT1747) na CT3900
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90

REM --- AWEUTIL - EMU8000 wavetable synthesizer init ---
REM UNISOUND does not init EMU8000 - AWEUTIL required for AWE32 wavetable features
REM /S = init EMU8000 from BLASTER variable (E620 = EMU8000 port)
REM Required for: AWE32 games, GM/GS/MT-32 MIDI emulation
REM Files: C:\DRIVERS\SB16\AWEUTIL.COM + Synthgm.sbk + Synthgs.sbk + Synthmt.sbk
REM Note: AWEUTIL /EM:* conflicts with SoftMPU - use profile 1 (NOSOFTMPU)
C:\DRIVERS\SB16\AWEUTIL.COM /S

REM --- SoftMPU - intelligent mode MPU-401 emulation for MT-32 games ---
REM Required for: Monkey Island 1, Sierra games, Ultima Underworld
REM AWE32 supports UART mode only - SoftMPU adds intelligent mode
REM /MPU:300 = MPU-401 port (must match P300 in BLASTER — AWE32 MPU at 300h)
REM /SB:220  = Sound Blaster base port (explicit, prevents autodetect failure)
REM /IRQ:5   = Sound Blaster IRQ for intelligent mode timing
REM WARNING: AWEUTIL /EM:* cannot be combined with SoftMPU!
LH C:\DRIVERS\SOFTMPU\SOFTMPU.EXE /MPU:300 /SB:220 /IRQ:5

REM --- PicoGUS initialization ---
REM /mode gus    = Gravis UltraSound emulation
REM /mpuport 330 = MPU-401 on port 330h (AWE32 MPU at 300h - must not conflict)
REM /mainvol 95  = master output 95% (headroom to prevent clipping)
REM /gusvol 95   = GUS output 95%
REM /wtvol 95    = wavetable header output 95%
REM /mpudelay 1  = slow down SysEx for Roland-compatible synthesizers
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 330 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
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
LH C:\DRIVERS\SHSUCDX\SHSUCDX.COM /D:SSCD000 /Q

REM --- Mouse ---
REM /R2 = horizontal resolution 2 (movement sensitivity)
REM COM port is auto-detected by CTMOUSE
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END

REM -----------------------------------------------
REM Profile 4: EMS/GAMES - RAM with SoftMPU
REM Use for: DOS extender games (Tyrian, Magic Carpet)
REM           games requiring EMS memory
REM -----------------------------------------------
:EMS
REM --- AWE32 CT3900 hardware init (UNISOUND) ---
REM /V70 = master volume 70, /VF90 = FM/OPL3 volume 90
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90

REM --- AWEUTIL - EMU8000 wavetable synthesizer init ---
REM Note: AWEUTIL /EM:* does NOT work with DOS extenders (DOS4GW) - only /S init
C:\DRIVERS\SB16\AWEUTIL.COM /S

REM --- SoftMPU - intelligent mode MPU-401 emulation ---
REM /MPU:300 = MPU-401 port (must match P300 in BLASTER — AWE32 MPU at 300h)
REM /SB:220  = Sound Blaster base port (explicit, prevents autodetect failure)
REM /IRQ:5   = Sound Blaster IRQ for intelligent mode timing
LH C:\DRIVERS\SOFTMPU\SOFTMPU.EXE /MPU:300 /SB:220 /IRQ:5

REM --- PicoGUS initialization ---
REM /mainvol 95 = master output 95% (headroom to prevent clipping)
REM /gusvol 95  = GUS output 95%
REM /wtvol 95   = wavetable header output 95%
REM /mpudelay 1 = slow down SysEx for Roland-compatible synthesizers
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 330 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
ECHO.
ECHO  [SOUND ENVIRONMENT]
ECHO  BLASTER : %BLASTER%
ECHO  MIDI    : %MIDI%
ECHO  SOUND   : %SOUND%
ECHO  ULTRASND: %ULTRASND%
ECHO  ULTRADIR: %ULTRADIR%
ECHO.

REM --- CD-ROM ---
LH C:\DRIVERS\SHSUCDX\SHSUCDX.COM /D:SSCD000 /Q

REM --- Mouse ---
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END

REM -----------------------------------------------
REM Profile 5: BARE DOS
REM -----------------------------------------------
:BARE
REM --- No drivers loaded in bare mode ---
GOTO END

:END
REM --- Norton Commander ---
NC


```

---

# Scripts — C:\DRIVERS\SCRIPTS\

> All scripts live in `C:\DRIVERS\SCRIPTS\` which is on PATH in both AUTOEXEC variants.
> Run from any directory. All paths inside scripts are absolute.

## GUS.BAT — GUS Game Launcher

Loads ULTRAMID.EXE before the game (required for Tyrian, Raptor), unloads after.
Safe to use for all GUS games — ULTRAMID is harmless for Doom/Duke3D/Heretic/Hexen.

```bat
REM Usage:
REM   GUS TYRIAN.EXE
REM   GUS DOOM.EXE
REM   GUS SETUP.EXE
REM   GUS DUKE3D.EXE -level 1
```

```bat
@ECHO OFF
REM =============================================================
REM  GUS.BAT - Universal GUS game launcher
REM  Place in a directory on PATH (e.g. C:\TOOLS)
REM
REM  Usage (run from game directory):
REM    GUS DOOM.EXE
REM    GUS TYRIAN.EXE
REM    GUS SETUP.EXE
REM    GUS DUKE3D.EXE -level 1
REM =============================================================

SET ULTRAMID=C:\DRIVERS\PICOGUS\ULTRAMID.EXE

IF "%1"=="" GOTO USAGE

REM --- Load ULTRAMID into UMB ---
LH %ULTRAMID%

REM --- Launch the specified executable with any extra params ---
%1 %2 %3 %4 %5 %6 %7 %8 %9

REM --- Unload ULTRAMID from memory ---
%ULTRAMID% -f

SET ULTRAMID=
GOTO END

:USAGE
ECHO.
ECHO  GUS.BAT - Universal GUS game launcher
ECHO  Usage: GUS executable.exe [params]
ECHO.
ECHO  Examples:
ECHO    GUS DOOM.EXE
ECHO    GUS TYRIAN.EXE
ECHO    GUS DUKE3D.EXE -level 1
ECHO    GUS SETUP.EXE
ECHO.

:END

```

---

## MPU.BAT — PicoGUS MPU-401 Game Launcher

Switches PicoGUS from GUS mode → MPU-401 intelligent mode before game.
McCake (WP32) on wavetable header provides GM/MT-32 emulation on port 330h.
Restores GUS mode after game exits.

```bat
REM Usage:
REM   MPU MONKEY2.EXE
REM   MPU SETUP.EXE
REM   MPU SIERRA.EXE
REM In-game: Music = General MIDI or MT-32, port 300h
```

```bat
@ECHO OFF
REM =============================================================
REM  MPU.BAT - PicoGUS MPU-401 game launcher
REM  Switches PicoGUS GUS to MPU-401 intelligent mode before game
REM  McCake (WP32) on wavetable header provides GM/MT-32 emulation
REM  Returns PicoGUS to GUS mode after game exits
REM
REM  Place in C:\TOOLS\ (already in PATH)
REM  Run from game directory:
REM
REM  Usage:
REM    MPU GAME.EXE
REM    MPU SETUP.EXE
REM    MPU GAME.EXE -params
REM
REM  In-game MIDI setup:
REM    Music device : General MIDI  OR  Roland MT-32
REM    MIDI port    : 300h
REM =============================================================

SET PGUSINIT=C:\DRIVERS\PICOGUS\PGUSINIT.EXE

IF "%1"=="" GOTO USAGE

REM --- Switch PicoGUS to MPU-401 intelligent mode ---
REM /mode mpu    = MPU-401 intelligent mode (McCake GM/MT-32 via wavetable)
REM /mpuport 330 = MPU-401 port 330h (McCake on wavetable header)
REM /mainvol 95  = master volume
REM /wtvol 95    = wavetable header volume (McCake output)
REM /mpudelay 1  = SysEx delay for Roland compatibility
ECHO  [PicoGUS] Switching to MPU-401 mode...
%PGUSINIT% /mode mpu /mpuport 300 /mainvol 95 /wtvol 95 /mpudelay 1
ECHO.

REM --- Launch game ---
%1 %2 %3 %4 %5 %6 %7 %8 %9

REM --- Restore PicoGUS to GUS mode ---
ECHO.
ECHO  [PicoGUS] Restoring GUS mode...
%PGUSINIT% /mode gus /mpuport 300 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1

GOTO END

:USAGE
ECHO.
ECHO  MPU.BAT - PicoGUS MPU-401 game launcher
ECHO.
ECHO  Usage: MPU executable.exe [params]
ECHO.
ECHO  Examples:
ECHO    MPU GAME.EXE
ECHO    MPU SETUP.EXE
ECHO    MPU GAME.EXE -level 1
ECHO.
ECHO  Configure in-game MIDI: port 300h, GM or MT-32
ECHO  McCake (WP32) on PicoGUS wavetable header provides the sound.
ECHO.

:END
SET PGUSINIT=

```

---

## ISO.BAT — Virtual CD-ROM Switcher

Mounts ISO file as virtual CD-ROM using SHSUCDHD.EXE + SHSUCDX.COM.
Requires **profile ISOCD or ISOCDEMS** at boot. Physical Samsung CD-ROM not loaded in these profiles.

```bat
REM Usage:
REM   ISO D:\ISOS\GAME.ISO   - mount ISO
REM   ISO /U                 - unload virtual CD
REM   ISO                   - show usage
```

```bat
@ECHO OFF
REM =============================================================
REM  ISO.BAT - Virtual CD-ROM ISO switcher
REM  Uses SHSUCDHD.EXE from SHSUCD suite by Jason Hood
REM  Download: http://adoxa.altervista.org/shsucdx/ (SHSUCD r3-7)
REM
REM  Place in C:\TOOLS\ (already in PATH)
REM  Profile ISOCD must be selected at boot menu
REM
REM  Usage:
REM    ISO D:\ISOS\GAME.ISO      - mount ISO as virtual CD
REM    ISO /U                    - unload virtual CD (free memory)
REM    ISO                       - show usage
REM =============================================================

SET SHSUCDHD=C:\DRIVERS\SHSUCDX\SHSUCDHD.EXE
SET SHSUCDX=C:\DRIVERS\SHSUCDX\SHSUCDX.COM

IF "%1"=="" GOTO USAGE
IF "%1"=="/U" GOTO UNLOAD
IF "%1"=="/u" GOTO UNLOAD
IF NOT EXIST %1 GOTO NOTFOUND

REM --- Unload current virtual CD, then mount new ISO ---
%SHSUCDX% /U
%SHSUCDHD% /U
ECHO.
ECHO  Mounting: %1
LH %SHSUCDHD% /F:%1
LH %SHSUCDX% /D:SHSU-CDH /Q
ECHO  Done.
ECHO.
GOTO END

:UNLOAD
ECHO.
ECHO  Unloading virtual CD-ROM...
%SHSUCDX% /U
%SHSUCDHD% /U
ECHO  Done.
ECHO.
GOTO END

:USAGE
ECHO.
ECHO  Usage: ISO D:\ISOS\GAME.ISO   - mount ISO
ECHO         ISO /U                 - unload virtual CD
ECHO.
ECHO  ISO files: D:\ISOS\
ECHO  Profile ISOCD must be active. Physical CD-ROM not available.
ECHO.
GOTO END

:NOTFOUND
ECHO.
ECHO  ERROR: File not found: %1
ECHO.

:END
SET SHSUCDHD=
SET SHSUCDX=

```

---

## USBMNT.BAT — Mount USB Drive

Mounts a USB mass storage device using Bret Johnson DOSUSB.
Requires **profile UBSSTM or UBSSTEM** at boot (USBUHCIL.COM already loaded as TSR).

```bat
@ECHO OFF
REM USBMNT.BAT - Mount USB mass storage device
REM Usage: USBMNT
REM Requires: USBUHCIL loaded (profiles UBSSTM / UBSSTEM)
REM Driver: Bret Johnson DOSUSB - C:\DRIVERS\USBDOS\

ECHO.
ECHO  === USB Mass Storage - Mount ===
ECHO  Plug in USB device NOW, then press Enter.
ECHO  Wait 3-5 seconds after plugging in.
ECHO.
C:\DRIVERS\USBDOS\USBDRIVE.COM /Devices:1 /Disks:1 /Drives:1
ECHO.
ECHO  Done. Check drive letters with: DIR E:  DIR F:  etc.
ECHO  To verify device: USBCHCK
ECHO.
```

---

## USBCHCK.BAT — Check USB Devices

Shows all USB devices currently detected by USBUHCIL TSR.

```bat
@ECHO OFF
REM USBCHCK.BAT - Show connected USB devices
REM Usage: USBCHCK
REM Requires: USBUHCIL loaded (profiles UBSSTM / UBSSTEM)

ECHO.
ECHO  === USB Devices - Status ===
ECHO.
C:\DRIVERS\USBDOS\USBDEVIC.COM
ECHO.
```

---

## USBUMNT.BAT — Safe USB Unplug

Reminds to close files before unplugging. Uninstall is disabled — see comments in script.

```bat
@ECHO OFF
REM USBUMNT.BAT - Safe to unplug USB drive
REM USBDRIVE stays in memory (blocked by CTMOUSE - cannot uninstall)
REM Just stop using the drive before unplugging

REM C:\DRIVERS\USBDOS\USBDRIVE.COM Uninstall
REM Uninstall is disabled - CTMOUSE loads after USBDRIVE and blocks it.
REM Calling Uninstall with a blocking TSR causes EMM386 error and system reset.
REM To unload: reboot. Hotswap works without unloading - just swap the drive.

ECHO.
ECHO  === USB Mass Storage - Safe Unplug ===
ECHO.
ECHO  Make sure all files are closed and
ECHO  no programs are reading the USB drive.
ECHO.
ECHO  It is now safe to unplug the USB device.
ECHO  To remount: USBMNT
ECHO.
```

---

## Environment Variables Reference

```bat
SET BLASTER=A220 I5 D1 H5 P300 E620 T6
  A220  = SB16 base port 220h
  I5    = IRQ 5
  D1    = DMA 1 (8-bit)
  H5    = DMA 5 (16-bit)
  P300  = MPU-401 port 300h (AWE32 gameport — nepřipojeno k MIDI)
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
REM QX1222USB: CH 7+8 (MT-32) UP, CH 3+4 (AWE32) up for effects
REM SoftMPU active from AUTOEXEC, DO NOT run AWEUTIL /EM (conflicts with SoftMPU)
KQ5.EXE

REM GM/GS game with SC-55 connected:
REM QX1222USB: CH 9+10 (SC-55) UP, CH 3+4 (AWE32) up for effects
REM Do not run AWEUTIL /EM — SC-55 >> EMU8000, SoftMPU does not interfere here
MONKEY2.EXE

REM GUS game (Doom, Duke3D, Heretic):
REM QX1222USB: CH 1+2 (PicoGUS) UP, CH 3+4 (AWE32) up for effects
REM Do not run AWEUTIL, GUS is via PicoGUS
DOOM.EXE

REM AWE32 native game:
REM QX1222USB: CH 3+4 (AWE32) UP for everything
REM AWEUTIL /S ran at boot, just launch the game
FIFA95.EXE

REM GM/GS game WITHOUT SC-55, WITHOUT DOS extender:
REM QX1222USB: CH 1+2 (PicoGUS/McCake) UP + CH 3+4 (AWE32) for effects
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
LH C:\DRIVERS\SOFTMPU\SOFTMPU.EXE /MPU:300 /SB:220 /IRQ:5

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
**QX1222USB: CH 7+8 (MT-32) UP, CH 3+4 (AWE32) up for effects | Profile: NORMAL**

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
> MT-32 is in the MIDI chain after SC-55 (THRU) — it outputs nothing for SC-55/GM games.

---

### Category 2 — GM/GS games — SC-55
**QX1222USB: CH 9+10 (SC-55) UP, CH 3+4 (AWE32) up for effects | Profile: NORMAL**

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
> SC-55 is in MIDI chain before MT-32 (THRU) — MIDI data pass through SC-55
> transparently and arrive at SC-55.
>
> **Warcraft 2 and Civilization 2** also offer a native AWE32 option —
> it sounds better than GM via SC-55. See Category 4.

---

### Category 3 — GUS games
**QX1222USB: CH 1+2 (PicoGUS) UP, CH 3+4 (AWE32) up for effects | Profile: NORMAL**

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
**QX1222USB: CH 3+4 (AWE32) UP for all | Profile: NORMAL | AWEUTIL /S runs from AUTOEXEC**

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
**QX1222USB: CH 1+2 (PicoGUS/McCake) UP + CH 3+4 (AWE32) for effects | Profile: NORMAL**

Use when SC-55 is not connected or you do not want to switch MIDI chain.
McCake on port 330h via PicoGUS — no preparation needed, always active.

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
**QX1222USB: CH 3+4 (AWE32) UP — real OPL3 CT1747 | Profile: NORMAL**

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

> Tyrian requires EMS memory — boot into EMS podmenu → NORMEMS

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
| McCake (WP32) via PicoGUS | **330h** | GM games via SF2 soundfont (without SC-55) |
| EMU8000 AWEUTIL emulation | **300h** | AWEUTIL /EM:GM, AWE32 native games |

### Switching SC-55 mode

```bat
REM GM mode (for General MIDI games):
DOSMID /mpu=330 /preset=GM /nosound /dontstop

REM GS mode (default, for GS games — C&C, LucasArts):
DOSMID /mpu=330 /preset=GS /nosound /dontstop
```

> SC-55 MT-32 mode is switched via the physical button on the front panel only.
> SC-55 must be first in MIDI chain — MT-32 receives data via SC-55 THRU.

---


---

## Memory Map (after optimization)

Measured with MEM.EXE on real hardware (Rhino 15 / Pentium MMX / AWE32 CT3900 / PicoGUS v2.0).
SMARTCDX.EXE (patched SmartDrive) + SHSUCDX.COM instead of MSCDEX — saves ~25 KB of UMB.

### Profile overview

| Profile | Conv. KB | UMB total | UMB free | Largest block | Notes |
|---|---|---|---|---|---|
| NOEMS / SoftMPU (NORMAL) | **608 KB** | 134 KB | 40 KB | 27 KB | SHSUCDX 6 KB v konv. |
| NOEMS / No SoftMPU (NOSOFTMPU) | **608 KB** | 134 KB | 49 KB | 35 KB | SHSUCDX 6 KB v konv. |
| NOEMS / ISO CD-ROM (ISOCD) | **614 KB** | 134 KB | 69 KB | 48 KB | ✓ |
| NOEMS / MPU-401 CD-ROM (MPU) | **608 KB** | 134 KB | 49 KB | 35 KB | SHSUCDX 6 KB v konv. |
| NOEMS / MPU-401 ISO (MPUISO) | **614 KB** | 134 KB | 77 KB | 56 KB | ✓ best NOEMS |
| EMS / SoftMPU EMS (EMSMODE) | 583 KB | 70 KB | 2 KB | 1 KB | ⚠ UMB full, SOFTMPU in conv. |
| EMS / No SoftMPU EMS (NOSOFTEMU) | 591 KB | 70 KB | 2 KB | 1 KB | ⚠ UMB full |
| EMS / ISO CD-ROM EMS (ISOCDEMS) | **614 KB** | 70 KB | 5 KB | 4 KB | ✓ bez phys CD driveru |
| EMS / MPU-401 EMS (MPUEMS) | 591 KB | 70 KB | 2 KB | 1 KB | ⚠ UMB full |
| EMS / MPU-401 ISO EMS (MPUISOEMS) | **614 KB** | 70 KB | 13 KB | 12 KB | ✓ bez phys CD driveru |
| Bare | 614 KB | 134 KB | 109 KB | 63 KB | — |

**Note on EMS profiles with physical CD (EMSMODE, NOSOFTEMU, MPUEMS):** EMS page frame takes 64 KB of UMB — only 70 KB total remains. SSCDROM.SYS (28 KB) + SMARTCDX.EXE (29 KB) + SHSUCDX.COM (6 KB) = 63 KB → UMB almost full, 1–2 KB free. These profiles work but have no headroom. ISO variants (ISOCDEMS, MPUISOEMS) are better because SSCDROM.SYS is not loaded.

**SHSUCDX.COM (6 KB) in conventional memory** for NOEMS profiles with physical CD: UMB is filled by SSCDROM (28 KB) + SMARTCDX (29 KB) + SOFTMPU/CTMOUSE (11 KB) = 68 KB — SHSUCDX loads from AUTOEXEC after UMB is already full. This is a load-order characteristic, not a problem — 608 KB conventional is sufficient.

### UMB obsah — NOEMS profily (134 KB celkem)

| Driver | Size | Location |
|---|---|---|
| SMARTCDX.EXE | 29 KB | UMB (INSTALLHIGH v CONFIG.SYS) |
| SSCDROM.SYS | 28 KB | UMB (DEVICEHIGH v CONFIG.SYS) |
| SOFTMPU.EXE | 8 KB | UMB (profily NORMAL, ISOCD) |
| COMMAND.COM | 7 KB | UMB |
| IFSHLP.SYS | 3 KB | UMB |
| CTMOUSE.EXE | 3 KB | UMB |
| SHSUCDX.COM | 6 KB | conv. memory (phys CD profiles) / UMB (ISO profiles) |

### UMB obsah — EMS profily (70 KB celkem po EMS page frame)

| Driver | Size | Location |
|---|---|---|
| SMARTCDX.EXE | 29 KB | UMB |
| SSCDROM.SYS | 28 KB | UMB (jen phys CD profily) |
| COMMAND.COM | 2 KB | UMB (zbytek) |
| SOFTMPU.EXE | 8 KB | **conv. memory** (EMSMODE — UMB full) |

---


---

## Driver Locations

| Driver / File | Path |
|---|---|
| HIMEM.SYS | C:\DOS\HIMEM.SYS |
| EMM386.EXE | C:\DOS\EMM386.EXE |
| SMARTDRV.EXE | C:\DRIVERS\SHSUCDX\SMARTCDX.EXE |
| SHSUCDX.COM | C:\DRIVERS\SHSUCDX\SHSUCDX.COM |
| SMARTCDX.EXE | C:\DRIVERS\SHSUCDX\SMARTCDX.EXE (SMARTDRV patched for SHSUCDX cache) |
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
| GUS.BAT | C:\DRIVERS\SCRIPTS\GUS.BAT |
| MPU.BAT | C:\DRIVERS\SCRIPTS\MPU.BAT |
| ISO.BAT | C:\DRIVERS\SCRIPTS\ISO.BAT |
| CTMOUSE.EXE | C:\DRIVERS\CTMOUSE\CTMOUSE.EXE |

---


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


---

## PicoIDE Deluxe — Pending Delivery

From the creator of PicoGUS (polpo / Ian Scott). Crowd Supply: `https://www.crowdsupply.com/polpotronics/picoide`

**PicoIDE** is an open-source IDE/ATAPI device emulator based on a Raspberry Pi RP2350.
The Deluxe version includes an ESP32 front panel with OLED display, 4 buttons and WiFi.

### Features

| Funkce | Popis |
|---|---|
| ATAPI CD-ROM emulation | .ISO, .BIN/.CUE including **Redbook CD audio** |
| IDE HDD emulation | .IMG, .HDA, .VHD, .HDF — various geometries, LBA and CHS |
| Redbook audio | MPC-2 connector (internal → sound card) + 3.5mm jack |
| Front panel | 1.3" OLED 128×64, 4 buttons, on-the-fly image switching |
| WiFi | Web interface for image management and upload |
| DOS utility | Switch images from DOS without touching the SD card |
| Transfer mode | MWDMA mode 2 + PIO mode 4 — **bez UDMA** |

> ⚠️ **PicoIDE has no UDMA** — operates in MWDMA/2 or PIO/4 mode. Performance is equivalent to a 52× CD-ROM drive, fully sufficient for retro gaming. The PIIX4 Bus Master driver for UDMA is not relevant for PicoIDE.

> ⚠️ **PicoIDE currently emulates only one device** — either CD-ROM or HDD, not both simultaneously. Two-device support is planned in a future firmware update.

### Planned configuration on arrival

```
Primary IDE master   — Verbatim Vi560 SSD (via Ableconn IDE40-SAT)
Secondary IDE master — LG GH22NS40 (physical drive stays)
Secondary IDE slave  — PicoIDE Deluxe
```

> Or PicoIDE on a separate IDE channel if a slot is available — depends on final layout.

Redbook audio: MPC-2 connector on PicoIDE → AWE32 CD-IN header or direct input to QX1222USB.

LG GH22NS40 stays — for physical CDs. SSCDROM.SYS in AUTOEXEC.BAT stays for the physical drive.

---

## Gotek SFR1M44-U100K — USB Floppy Emulator

Older Gotek variant with **2 buttons and LED numeric display** (not OLED).
Replaces a physical 3.5" floppy drive — connects to the standard 3.5" floppy connector and power.

**Recommended firmware: FlashFloppy**
- Download: `https://github.com/keirf/FlashFloppy`
- Supports .IMG, .IMA, .DSK, .ST and other formats
- USB flash drive = virtual floppy images — navigate with buttons

**FlashFloppy installation:**
1. Download the latest `FF_Gotek-*.zip` from GitHub releases
2. Extract `FIRMWARE.UPD` to a USB flash drive (FAT32, root)
3. Insert USB into Gotek, hold left button while powering on → flashing = update in progress
4. Reboot when complete

**Usage:**
- USB flash drive with `.img` files in root or subdirectories
- Left/right button = browse images
- LED display = number of currently selected image

---

## USBODE — USB Optical Drive Emulator

**Project:** `https://github.com/danifunker/usbode-circle`
**Current version:** v2.20.3 (February 2026)
**Discord:** `https://discord.gg/8qfuuUPBts`

USBODE turns a Raspberry Pi into a virtual USB CD-ROM drive for retro PCs. It connects via USB cable which carries both data and power. Disk images are stored on the Pi's micro SD card and switched via a WiFi web interface or optionally a hardware HAT with display and buttons.

### Supported Hardware

| Model | Support | Connection | Notes |
|---|---|---|---|
| Pi Zero (2015) | ✅ | Micro USB → USB-A | Supported as of v2.9.2 |
| Pi Zero W (2017) | ✅ | Micro USB → USB-A | Recommended: WH model (pre-soldered headers) |
| Pi Zero 2W (2021) | ✅ **Recommended** | Micro USB → USB-A | Best performance, multi-core |
| Pi 3A+ (2018) | ✅ | USB-A → USB-A | Do not connect separate power — power loop risk |
| Pi 3B / 3B+ | ❌ | — | No USB gadget mode |
| Pi 4B (2019) | ✅ | USB-C (power port) → USB-A | All RAM configs supported |
| Pi 400 | ❓ | — | Unknown |
| Pi 5 (2023) | ❌ | — | USB gadget mode not supported by current dependencies |

> ⚠️ **Connection ports:** Zero/Zero W/Zero 2W — use the **"USB"** micro USB port, **not** the "PWR" port. Pi 3A+ — USB-A to USB-A cable, no separate power. Pi 4B — USB-C power port to USB-A.

**Power:** Pi is powered entirely from the PC's USB port via the data cable. No separate power supply needed. Pi boots and shuts down with the PC.

### Required Hardware

| Component | Notes |
|---|---|
| Supported Raspberry Pi | See table above |
| Micro SD card | A1 or A2 class, 32 GB+, up to 1 TB tested |
| USB cable | Data cable (not charge-only) — type depends on Pi model |

### Optional HATs

| HAT | Features |
|---|---|
| Pirate Audio Line Out (PIM483) | On-device controls + **Redbook CD audio via 3.5mm jack** — recommended |
| Waveshare 1.3" OLED HAT | On-device controls only, no CD audio — requires `config.txt` change |
| IQaudio DAC+ | CD audio, reported working — requires Pi Zero without headers |
| HDMI audio | Requires HDMI cable + audio splitter + dummy plug — ~$30 extra hardware |

### Supported Image Formats

| Format | Notes |
|---|---|
| `.ISO` | Standard — fully supported |
| `.BIN/.CUE` | Files must have identical base name. Multi-bin CUEs not supported — convert to CHD first |
| `.MDS/.MDF` | Files must have identical base name |
| `.CHD` | Supported, ~50% performance of BIN/CUE. Better compression with `-f -c cdzs,cdfl -hs 9792` (MAME 280+) |
| `.dvd.iso` | Add `.dvd` extension for DVD images that must be detected as DVD |

### Initial Setup

1. Download latest `.img` from `https://github.com/danifunker/usbode-circle/releases`
   - Pi Zero W (not 2W): use 32-bit build
   - All other supported Pis: either 32-bit or 64-bit (32-bit more tested)
2. Flash image to SD card using Raspberry Pi Imager (Choose OS → Use Custom)
3. Open `bootfs` volume on SD card, edit `wpa_supplicant.conf`:
   - Set `country=` to your two-letter country code
   - Set `ssid=` to your 2.4 GHz WiFi network name
   - Set `psk=` to your WiFi password
4. Safely eject SD card, insert into Pi
5. Connect Pi to PC USB port — Pi boots in ~7-10 seconds
6. Copy `.ISO` and other image files to the `IMGSTORE` volume on SD card

### Initial Setup — PIIX4 USB Speed Note

PIIX4 (Rhino 15) is USB 1.1 Full Speed only. After USBODE is running, open the web interface, go to **Configuration → USB Configuration** and set USB speed to **Full Speed (USB 1.1)**. This prevents USBODE from attempting High Speed negotiation which PIIX4 cannot complete.

### Web Interface

Access via browser: `http://usbode` or `http://usbode.local` or `http://<IP address>`

| Function | Location |
|---|---|
| Switch disk image | Main page — click image name |
| USB speed (Full/High Speed) | Configuration → USB Configuration |
| HAT type | Configuration → Display Configuration |
| Audio output mode | Configuration → Audio Configuration |
| CD audio test | Configuration → Audio Test |
| FTP image upload | Connect FTP client (port 21, anonymous) → navigate to `1:/` |
| Logging | Configuration → Logging Configuration |
| Shutdown | Main page → Shutdown USBODE |

### Adding Images

Three methods to copy images to IMGSTORE:

1. **Eject SD card** from Pi, connect directly to PC — fastest method
2. **FTP** — FTP client (port 21, anonymous login) → `1:/` directory
3. **Win98SE browser** — web interface supports file upload from browser

> ⚠️ Do not delete `image.iso` from IMGSTORE — it is required as a fallback.

### Folder Support (v2.19.0+)

Images can be organized into subdirectories on IMGSTORE. Max path 512 characters. Web interface has a "Flattened folders" toggle to list all images on one screen regardless of folder structure.

### Disc Artwork

Place a 240×240 px JPG with the same base name as the image file in the same folder. Example: `mygame.iso` → `mygame.jpg`. Shown in web interface and on ST7789 HAT screen.

Companion tool for artwork download: `https://github.com/danifunker/ODE-artwork-downloader`

### Redbook CD Audio — Pirate Audio HAT

Connect 3.5mm jack from Pirate Audio HAT to sound card Line-In or mixer. For internal connection use a 4-pin CD audio cable (MPC-2 connector) wired to a TRS adapter:

```
Yellow (TRS) → White (CD Audio L)
Red (TRS)    → Red   (CD Audio R)
Black (TRS)  → Black (CD Audio GND)
```

After connecting, test with the `usb-audio-sampler` image included on IMGSTORE — play track 2 in Win98SE CD Player.

### Upgrading USBODE

Download from latest release: `sysupgrade.tar`, `sysupgrade.crc` (+ 64-bit variants). Copy to root of `bootfs` partition, reboot. Update takes < 5 minutes. Requires v2.14.0+ for Pirate Audio, v2.18.3+ for Waveshare.

---

### Mode 1 — CD-ROM Emulation (DOS)

Pi presents itself as a standard ATAPI USB CD-ROM drive. DOS loads it via `USBASPI.EXE` + `USBCD1.SYS`, both in `C:\DRIVERS\USBCD\`.

**PIIX4 UHCI — confirmed output from USBASPI verbose mode:**
```
Controller: 00-07-2 VID=8086h PID=7112h (0000h-0000h) UHCI
            I/O=6400h-641Fh
```

**Boot profiles for Mode 1:**

| Profile | Memory | Sound | Description |
|---|---|---|---|
| `UBSNM` | NOEMS 607 KB | SoftMPU + GUS | Everyday use, MT-32 games |
| `UBSNS` | NOEMS 607 KB | No SoftMPU | AWEUTIL /EM emulation |
| `UBSNMP` | NOEMS 607 KB | MPU-401 | McCake GM/MT-32 via port 330h |
| `UBSEM` | EMS 595 KB | SoftMPU + GUS | DOS extender games |
| `UBSNES` | EMS 595 KB | No SoftMPU | AWEUTIL /EM + DOS extenders |
| `UBSEMP` | EMS 595 KB | MPU-401 | McCake + DOS extenders |

**CONFIG.SYS (all Mode 1 profiles):**
```
DEVICEHIGH=C:\DRIVERS\USBCD\USBASPI.EXE /u /w /w
DEVICEHIGH=C:\DRIVERS\USBCD\USBCD1.SYS /D:USBCD0
```

**AUTOEXEC.BAT (all Mode 1 profiles):**
```bat
LH C:\DRIVERS\SHSUCDX\SHSUCDX.COM /D:USBCD0 /Q
```

**Files in C:\DRIVERS\USBCD\:**

| File | Description |
|---|---|
| `USBASPI.EXE` | Panasonic ASPI Manager for USB mass-storage v2.28 |
| `USBASPI.SYS` | Same driver, .SYS extension variant |
| `USBASPI.OLD` | Older v2.27 — rename to use as alternative |
| `USBCD1.SYS` | Panasonic USB CD-ROM Device Driver v1.0 — recommended |
| `USBCD2.SYS` | TEAC USB CD-ROM Device Driver |
| `USBCD3.SYS` | ASUSTeK USB CD-ROM Device Driver |
| `DI1000DD.SYS` | Novac ASPI Mass Storage Device Driver (Mode 2 fallback) |
| `ASPIDISK.SYS` | Adaptec ASPI Disk Driver (Mode 2 fallback) |

**USBASPI compatibility note:** USBASPI 2.28 correctly finds PIIX4 UHCI at I/O=6400h but reports `Target USB device not found` for modern USB 2.0/3.0 flash drives. This is a USB 1.1 / High Speed compatibility issue — modern drives attempt High Speed negotiation which PIIX4 cannot satisfy. USBODE Pi Zero 2W works correctly because it properly enumerates as Full Speed USB 1.1. **Set USBODE USB speed to Full Speed in web interface.**

---

### Mode 2 — USB Mass Storage (DOS)

Pi presents its SD card IMGSTORE partition as a DOS drive letter. Used for transferring ISO files to USBODE without removing the SD card.

**Driver stack: Bret Johnson DOSUSB** — `C:\DRIVERS\USBDOS\`
Specifically designed for Intel/VIA UHCI controllers. Supports hotswap.

**Boot profiles for Mode 2:**

| Profile | Memory | Sound | Description |
|---|---|---|---|
| `UBSSTM` | NOEMS 607 KB | SoftMPU + GUS | USB mass storage |
| `UBSSTEM` | EMS 595 KB | SoftMPU + GUS | USB mass storage + DOS extenders |

**CONFIG.SYS (Mode 2 profiles):** No USB device drivers — DOSUSB is TSR-based.
```
DEVICE=C:\WINDOWS\EMM386.EXE NOEMS
INSTALLHIGH=C:\DRIVERS\SHSUCDX\SMARTCDX.EXE /X 2048 512
```

**AUTOEXEC.BAT (Mode 2 profiles):**
```bat
LH C:\DRIVERS\USBDOS\USBUHCIL.COM DisableLegacySupport
```
`DisableLegacySupport` suppresses the BIOS USB keyboard warning at every boot.

**Files in C:\DRIVERS\USBDOS\:**

| File | Description |
|---|---|
| `USBUHCIL.COM` | UHCI TSR lite (30 KB RAM, max 16 devices) — Intel/VIA UHCI only |
| `USBUHCIL.OVL` | **Required overlay — must be in same directory as USBUHCIL.COM** |
| `USBUHCI.COM` | Full UHCI TSR (43 KB RAM) — alternative to USBUHCIL |
| `USBUHCI.OVL` | Overlay for USBUHCI.COM |
| `USBDRIVE.COM` | Mass storage driver — assigns DOS drive letters |
| `USBDEVIC.COM` | Shows connected USB devices and status |
| `USBHOSTS.COM` | Shows USB host controllers detected by USBUHCIL |

> ⚠️ `USBUHCIL.OVL` must be present in the same directory. Without it USBUHCIL.COM will not start.

**Mounting (run after boot):**
```bat
USBMNT
```
Calls `USBDRIVE /Devices:1 /Disks:1 /Drives:1` — reserves exactly 1 device slot, 1 LUN, 1 drive letter. Without `/Drives:1` DOS receives 6-8 extra phantom drive letters.

**Flash drive compatibility with PIIX4 USB 1.1:**
Modern USB 2.0/3.0 flash drives often fail to enumerate — they attempt High Speed negotiation which PIIX4 cannot satisfy. Workarounds:
- Use older flash drive (2-4 GB, pre-2008 era)
- Use USBODE Pi Zero 2W SD card directly in Mode 2 — Pi correctly presents as Full Speed USB 1.1

---

### Hotswap Workflow

**First mount:**
1. Boot into `UBSSTM` or `UBSSTEM`
2. `USBUHCIL.COM DisableLegacySupport` loads automatically from AUTOEXEC.BAT
3. Run `USBMNT` — plug in USB device, wait 3-5 s, press Enter
4. Drive letter assigned automatically (first free after existing drives)

**Swap drive (no reboot needed):**
1. Close all files and programs using the USB drive
2. Pull the USB drive
3. Insert new drive — USBDRIVE detects it automatically in background
4. Wait 3-5 seconds, run `USBMNT` again

**Safe unplug:**
Run `USBUMNT` — reminder message only, USBDRIVE stays in memory (see note below).

**Why Uninstall does not work:**
CTMOUSE loads after USBDRIVE in AUTOEXEC.BAT. CTMOUSE does not use IBM Interrupt Sharing Protocol and blocks USBDRIVE from uninstalling (TSR ordering rule). Calling `USBDRIVE Uninstall` with a blocking TSR causes an EMM386 protected mode conflict and immediate system reset. To fully unload USBDRIVE, reboot. Hotswap works without unloading.

---

## BLE Keyboard + Mouse Bridge

A modern BLE mouse and BLE keyboard are connected via a custom ESP32 firmware bridge.
Projects: https://github.com/falco81/BLE-RS232-Bridge and https://github.com/falco81/BLE-PS2-USB-Bridge

Two wiring variants are available:

### Variant A — RS232 mouse + PS/2 keyboard (2× ESP32)

| ESP32 | Firmware | Output | Connection to PC |
|---|---|---|---|
| ESP32 #1 | `ble_ps2_bridge.ino` | PS/2 AT keyboard | DIN-5 or Mini-DIN 6 keyboard port |
| ESP32 #2 | `ble_serial_mouse_bridge.ino` | RS-232 serial mouse (Microsoft MZ protocol) | DB9 COM1/COM2 |

RS232 bridge: ESP32 → BSS138 level shifter → MAX232CPE → DB9 female (pin 2=data, pin 5=GND, pin 7=RTS, pin 4=DTR).
Protocol MZ (IntelliMouse with scroll wheel) — requires CTMOUSE ≥ 3.4.

CTMOUSE parameters for RS232 mouse:
```bat
CTMOUSE /R2       (sensitivity, values 1-9)
CTMOUSE /U        (unload)
CTMOUSE           (reload — re-reads protocol after change)
```

### Variant B — PS/2 mouse + PS/2 keyboard (1× ESP32)

| ESP32 | Firmware | Output |
|---|---|---|
| ESP32 WROOM-32 | `ble_ps2_kb_mouse_bridge.ino` | PS/2 keyboard (DIN-5/Mini-DIN 6) + PS/2 mouse (Mini-DIN 6) |

One ESP32 + one 4-channel BSS138 level shifter handles both PS/2 ports simultaneously.
PS/2 mouse: Explorer protocol (4-byte, scroll wheel, Back, Forward buttons), auto-negotiation with host.

GPIO pinout (both variants):
```
KB CLK  = GPIO19    KB DATA  = GPIO18
MS CLK  = GPIO16    MS DATA  = GPIO17   (Variant B only)
```

### Common features

- Scan-before-connect — waits for device to start advertising
- Automatic reconnect on disconnect
- NVS storage — MAC address persists across reboots
- Configuration via Serial console (115200 baud): `scan`, `connect <mac>`, `forget`, `status`
- DPI scaling: `scale <1-64>` (default 4 for 1600 DPI mouse)
- Y-axis inversion: `flipy`, scroll inversion: `flipw`
- Keyboard shortcuts: LCtrl+LAlt+PrtSc = battery %, LCtrl+LAlt+LShift+PrtSc = full status

### MSD report — actual state

MSD reports `Logitech PS/2 Mouse, driver 7.05, IRQ 12` — when Variant B (PS/2 bridge) is active, booted under profile EMSMODE.
With Variant A (RS232 bridge) MSD reports serial mouse on COM1/COM2, IRQ 3 or 4.

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
- AWE32 MPU-401 → port 300h → gameport (nepřipojeno k MIDI)
- PicoGUS MPU-401 → port 330h → CME WIDI Thru6 BT → MT-32 / SC-55 MK2 / SC-88 Pro / MT32-pi SF2 + McCake (WP32) wavetable
- LPT1 disabled in BIOS to free IRQ 7 for PicoGUS
- MIDI chain: PicoGUS → WIDI Thru6 BT (splitter) → MT-32 / SC-55 MK2 / SC-88 Pro / MT32-pi SF2 (paralelně)
- CTMOUSE /R2 = horizontal resolution 2; mouse is a modern BLE mouse via ESP32 bridge (PS/2 IRQ 12 or RS232 IRQ 3/4)
- ULTRADIR must point to C:\DRIVERS\PICOGUS root (not MIDI subfolder)
- CT3900 IDE port must be DISABLED (JP2+JP3 closed) — conflicts with motherboard IDE
- CT3900 SIMM slots: both must be populated simultaneously with identical modules
- **ULTRAMID.EXE** required for Tyrian and Raptor GUS music — use `GUS.BAT` launcher, not AUTOEXEC
- **McCake power** — from waveblaster header (PicoGUS) or floppy connector
- **CPU upgrade — K6/K6-2 on Socket 7:** K7 does not exist in Socket 7 (K7 = Athlon, Slot A/Socket A). K6/300 (no 3DNow!) is essentially the same performance as Pentium MMX 200 with a weaker FPU — not an upgrade. K6-2/300 (with 3DNow!) is roughly equivalent to Pentium MMX 233. **Rhino 15 has an Intel PIIX4 chipset** — K6-2 CPUs only reach their potential on Super Socket 7 boards with VIA/ALi chipsets. On Intel TX chipset the K6-2 will not reach its potential and will be equal or slower in FPU-heavy games (Quake, GLQuake). Pentium MMX 200 on Intel TX is the optimal combination for DOS gaming — excellent compatibility, reliable FPU. K6-2/300 is not a recommended upgrade for this system.

---


---

---

## Upgrades

---

### Upgrade — Ableconn IDE40-SAT (HDD + ODD varianta) + UDMA/33 v Windows

**What changes:**
- Existing adapter replaced with **Ableconn IDE40-SAT SATA Hard Drive or Optical Drive to IDE 40-Pin Mini Vertical Adapter** — explicitly supports optical drives (ODD)
- 80-pin IDE cables already installed (required for UDMA/33)
- Enabling UDMA/33 in Windows 98SE for HDD and CD-ROM via PIIX4 Bus Master driver

**Why 80-pin:** A 40-pin cable limits transfer to UDMA/16. An 80-pin cable (with the same 40-pin connector) adds 40 ground wires, reduces crosstalk and enables UDMA/33.

---

#### Step 0 — Back up configuration from DOS (before upgrade)

Perform the backup from DOS (not from Windows) so that the Windows registry is consistent.
Bootuj do profilu **NORMAL** nebo **NOSOFTMPU**.

```bat
REM --- Backup DOS configuration files ---
XCOPY C:\CONFIG.SYS        C:\BACKUP\ /Y
XCOPY C:\AUTOEXEC.BAT      C:\BACKUP\ /Y
XCOPY C:\MSDOS.SYS         C:\BACKUP\ /Y
XCOPY C:\DRIVERS\SCRIPTS\*.BAT  C:\BACKUP\SCRIPTS\ /Y /I

REM --- Backup Windows registry (from DOS via SCANREG) ---
SCANREG /BACKUP
REM Creates backup in C:\WINDOWS\SYSBCKUP\RB000.CAB (rotates through RB000-RB004)

REM --- Export registry as readable REG file (run from Windows) ---
REM Run this from Windows before the upgrade:
REM   REGEDIT /E C:\BACKUP\REGISTRY.REG
```

**Windows backup (run before the physical upgrade):**

```
Start → Spustit → regedit
File → Export Registry File → C:\BACKUP\REGISTRY.REG → All
```

Or from the Windows command line:
```bat
REGEDIT /E C:\BACKUP\REGISTRY.REG
```

**Back up System.dat and User.dat:**
```bat
REM V DOSu (soubory jsou hidden+system+readonly v C:\WINDOWS)
ATTRIB -H -S -R C:\WINDOWS\SYSTEM.DAT
ATTRIB -H -S -R C:\WINDOWS\USER.DAT
COPY C:\WINDOWS\SYSTEM.DAT C:\BACKUP\SYSTEM.DAT
COPY C:\WINDOWS\USER.DAT   C:\BACKUP\USER.DAT
ATTRIB +H +S +R C:\WINDOWS\SYSTEM.DAT
ATTRIB +H +S +R C:\WINDOWS\USER.DAT
```

**Restore registry (if Windows fails to boot):**
```bat
REM Z DOSu:
SCANREG /RESTORE
REM Select the most recent backup from the list (RB000.CAB = newest)

REM Or manually:
COPY C:\BACKUP\SYSTEM.DAT C:\WINDOWS\SYSTEM.DAT
COPY C:\BACKUP\USER.DAT   C:\WINDOWS\USER.DAT
```

---

#### Step 1 — Physical adapter upgrade

1. Vypni PC
2. Disconnect IDE cable from existing Ableconn IDE40-SAT on SSD
3. Odpoj Ableconn IDE40-SAT od SSD
4. Connect new Ableconn IDE40-SAT (HDD+ODD variant) to SSD — same wiring
5. Connect new Ableconn IDE40-SAT (HDD+ODD variant) to CD-ROM (LG GH22NS40) — secondary master
6. Verify both adapters are powered (SATA power → Molex adapter or direct Molex)
7. Check 80-pin IDE cables — connector marked **MASTER** at cable end → drive, middle connector → slave (unused)

---

#### Krok 2 — Test v DOSu

Boot to **BARE** profile and verify:
```bat
MSD /F C:\TEMP\MSD_POST.TXT
REM Check Fixed Disk section — both drives must be visible
```

Nebo:
```bat
DIR C:\
DIR D:\
DIR E:\     REM CD-ROM
```

---

#### Krok 3 — Instalace PIIX4 IDE Bus Master driveru ve Windows

> ⚠️ Only proceed after a successful DOS test.

1. Bootuj do Windows 98SE
2. Download **Intel INF Update Utility** — look for `INFINST_AUTOL.EXE` or `inf8xxxx.exe` on VOGONS Drivers or Intel ARK
3. Run the installer, reboot
4. After reboot: `Right-click My Computer → Properties → Device Manager`
5. `Disk controllers` → should show: **Intel 82371AB/EB PCI Bus Master IDE Controller**
6. Right-click → Properties → Settings → check **DMA** for Primary and Secondary channel

**Verify UDMA in Device Manager:**
```
Device Manager → Disk controllers →
  Intel 82371AB/EB PCI Bus Master IDE Controller
    ├─ Primary IDE channel  → Vlastnosti → DMA: Enabled ✓
    └─ Secondary IDE channel → Vlastnosti → DMA: Enabled ✓
```

**Verify from DOS after reboot (HWINFO):**

HWINFO report should show DMA transfer modes:
```
HDD:  Ultra DMA mode 6 active (omezeno PIIX4 na UDMA/33)
CDROM: Ultra DMA mode 5 active (omezeno PIIX4 na UDMA/33)
```

---

#### What to do if Windows fails to boot after driver installation

```bat
REM Boot do DOSu, obnov registry:
SCANREG /RESTORE
REM Nebo:
COPY C:\BACKUP\SYSTEM.DAT C:\WINDOWS\SYSTEM.DAT
COPY C:\BACKUP\USER.DAT   C:\WINDOWS\USER.DAT
```

If SCANREG /RESTORE does not work — boot from Win98SE CD or boot disk and restore manually.

---

#### Notes

- PIIX4 supports a maximum of **UDMA/33** (Ultra DMA mode 2) regardless of drive speed
- Vi560 S3 SSD supports UDMA/6 but will be limited to UDMA/2 (33 MB/s) by the PIIX4 chipset — this is expected
- 80-pin cable is required for UDMA/33 — without it Windows automatically degrades to UDMA/16 or PIO
- CD-ROM (LG GH22NS40) — UDMA/33 will improve read speed and reduce CPU load during CD playback

---

---

# MIDI Synthesizer Reference

> Všechny moduly jsou připojeny přes **CME WIDI Thru6 BT** (MIDI splitter) na MIDI OUT z PicoGUS.
> Každý modul přijímá všechny kanály současně — hru přepínáš výběrem správného kanálu v nastavení hry.

---

## Roland MT-32 (original)

**Typ:** LA syntezátor (Linear Arithmetic), 1987  
**Polyfonie:** 32 hlasů, 8 partů + rytmus  
**Kanály:** MIDI 2–9 (part 1–8), kanál 10 = rytmus  
**Výstup:** CH 7+8 na mixpultu

### Ovládání panelu

| Tlačítko | Funkce |
|---|---|
| PART 1–8 | Výběr partu (zobrazí nastavení) |
| RHYTHM PART | Výběr rytmické sady |
| MASTER VOLUME | Zobrazí hlasitost — otočit SELECT/VOLUME |
| SOUND GROUP + MASTER VOLUME | Nastaví reverb (0–10) |
| SOUND GROUP + PART | Nastaví timbr partu |

### Speciální módy / reset

```
Factory reset (vymaže user timbry):
  Drž MASTER VOLUME → stiskni RHYTHM PART → stiskni PART 1

ROM Play (demo přehrávání, 5 skladeb):
  Drž MASTER VOLUME při zapnutí → PART (1–5) vybere skladbu → VOLUME spustí
  SOUND GROUP zastaví → vypnout/zapnout pro exit

Reverb nastavení:
  Drž MASTER VOLUME → stiskni SOUND GROUP → SELECT/VOLUME mění mód (0–10)
```

### Použití ve hrách

Hry zasílají MT-32 reset SysEx při startu (`F0 41 10 16 12 7F 01 F7`) — MT-32 se inicializuje automaticky. Před hrou není třeba nic nastavovat. Pokud MT-32 vydává šum nebo špatné zvuky — proveď factory reset.

---

## Roland SC-55 MK2

**Typ:** GS Sound Canvas, GM + GS standard  
**Polyfonie:** 28 hlasů  
**Kanály:** 1–16, kanál 10 = perkuse  
**Výstup:** CH 9+10 na mixpultu

### Ovládání panelu

| Tlačítko | Funkce |
|---|---|
| INSTRUMENT ◄ / ► | Přepíná zobrazený part / nástroj |
| MIDI CH ◄ / ► | Mění MIDI kanál pro zobrazení |
| KEY SHIFT ◄ / ► | Transpozice |
| PART ◄ / ► | Přepíná party |
| ALL | Zobrazuje celkové info / potvrzuje akci |
| MUTE | Ztlumí aktuální part |

### Speciální módy / reset

```
Factory reset (vymaže user data):
  Standby → drž INSTRUMENT ◄ + INSTRUMENT ► → stiskni POWER
  Zobrazí "Init All, Sure?" → stiskni ALL → provede reset

MT-32 emulační mód:
  Drž INSTRUMENT ◄ při zapínání → stiskni ALL

GS mód (výchozí):
  Drž INSTRUMENT ► při zapínání → stiskni ALL

Zjištění verze firmware:
  Standby → drž INSTRUMENT ◄ + INSTRUMENT ► → stiskni MIDI CH ◄ + MIDI CH ►
  Na LCD se zobrazí verze CPU ROM a Control ROM
```

### Použití ve hrách

Hry posílají GS Reset SysEx (`F0 41 10 42 12 40 00 7F 00 41 F7`) — SC-55 MK2 se inicializuje automaticky. V nastavení hry vyber **Sound Canvas**, **Roland GS**, nebo **General MIDI**. SC-55 MK2 má rozšířenou sadu nástrojů oproti původnímu SC-55.

---

## Roland SC-88 Pro

**Typ:** GS Sound Canvas Pro, GM + GS + SC-88 Map + SC-55 Map  
**Polyfonie:** 64 hlasů, 2× 16 kanálů (Part A + Part B)  
**Kanály:** Part A = MIDI IN A, Part B = MIDI IN B  
**Výstup:** CH 11+12 na mixpultu

### Ovládání panelu

| Tlačítko / kombinace | Funkce |
|---|---|
| SC-55 Map | Přepne instrument mapu na SC-55 MK2 kompatibilní |
| SC-88 Map | Přepne instrument mapu na SC-88 |
| SELECT + ALL | Aktivuje **compatibility mode** (ALL bliká) — pak použij mapu |
| SELECT + PART ► | GM mód |
| SELECT + INSTRUMENT ◄ | CM-64 mód |
| SELECT + INSTRUMENT ► | GS mód |
| SELECT + INSTRUMENT ◄ + INSTRUMENT ► | Factory reset |

### ⚠ Důležité — mapování

Pouhé stisknutí SC-55 Map **NEMĚNÍ GM patche**. Jen mění mapping doplňkových nástrojů. Pro správnou SC-55 kompatibilitu:

```
1. Drž SELECT → stiskni ALL  → ALL bliká (compatibility mode)
2. Stiskni SC-55 Map nebo SC-88 Map
```

Přepnutí mapy za běhu MIDI souboru způsobí reset parametrů → špatné zvuky. Přepínej vždy před spuštěním hry/souboru.

### Speciální módy / reset

```
Factory reset:
  Drž SELECT → stiskni INSTRUMENT ◄ + INSTRUMENT ► → stiskni ALL

GM reset (z panelu):
  Drž SELECT → stiskni PART ►

GS reset (z panelu):
  Drž SELECT → stiskni INSTRUMENT ►

CM-64 mód:
  Drž SELECT → stiskni INSTRUMENT ◄
```

### Použití ve hrách

SC-88 Pro má 2 MIDI vstupy (Part A + Part B = 32 kanálů celkem). V retro hrách stačí Part A (standardní MIDI port). Pro hry vyžadující SC-88 Pro specifické zvuky — mód ponech na výchozím GS (neresetuj na SC-55 Map).

---

## Serdashop SF2 (external MIDI synth)

**Zařízení:** [Serdashop SF2](https://www.serdashop.com/SF2) — standalone MIDI synthesizer v krabičce  
**Hardware:** Raspberry Pi Zero 2W, 512 MB RAM, DAC PCM5xxx, 81×75×26 mm, 74 g  
**Software:** mt32-pi (baremetal, FluidSynth) — SF2 soundfonty, volitelně MT-32 emuláce  
**Polyfonie:** 128 hlasů, 16 MIDI kanálů  
**Latence:** 3.9 ms (měřeno osciloskopem, woodblock, buffer 32)  
**Výstup:** 3.5mm stereo line out → CH 5+6 na mixpultu  
**Napájení:** USB-C, 5V 2A (doporučeno originální Raspberry Pi napájení)  
**SD karta:** microSD, SF2 soubory do `soundfonts/`, max. 400 MB per soundfont

### Přepínání soundfontů — tlačítko na zařízení

SF2 má fyzické tlačítko pro přepínání mezi soundfonty uloženými na SD kartě. Stisk přepne na další SF2 v adresáři.

### Ovládání — MT32-PI.EXE z DOSu

Utilita `MT32-PI.EXE` od gmcn42 ovládá zařízení přes MIDI SysEx na portu PicoGUS:

```bat
REM Port — dle boot profilu: 300h (GUS profily) nebo 330h (MPU profily)
MT32-PI.EXE -p 330 -g          přepne do SF2/FluidSynth GM módu (výchozí)
MT32-PI.EXE -p 330 -m          přepne do MT-32 módu (pokud jsou ROM soubory na SD)
MT32-PI.EXE -p 330 -s 0        soundfont č. 0 (první v adresáři soundfonts/)
MT32-PI.EXE -p 330 -s 1        soundfont č. 1
MT32-PI.EXE -p 330 -r          reboot Pi
MT32-PI.EXE -p 330 --gm-reset  pošle GM reset SysEx
MT32-PI.EXE -p 330 --gs-reset  pošle GS reset SysEx
MT32-PI.EXE -p 330 --mt32-reset  pošle MT-32 reset SysEx (jen v MT-32 módu)
MT32-PI.EXE -p 330 -b old      MT-32 Old romset (model 1987)
MT32-PI.EXE -p 330 -b new      MT-32 New romset (model 1989+)
MT32-PI.EXE -p 330 -b cm32l    CM-32L romset
MT32-PI.EXE -p 330 -t "Hello"  text na display (MT-32 mód)
```

**Download:** `https://github.com/gmcn42/mt32-pi-control`  
**Umístění:** `C:\DRIVERS\MT32PI\MT32-PI.EXE`

### Soundfonty — doporučené

Stažení SD obsahu: `https://serdaco.com/downloads/SF2`  
Předinstalováno: **GeneralUser GS** (S. Christian Collins)

| Soundfont | Velikost | Zaměření |
|---|---|---|
| GeneralUser GS (předinstalovaný) | ~31 MB | GM/GS, retro hry |
| Roland SC-55 v3.7 (EmperorGrieferus) | ~120 MB | SC-55 emuláce |
| Arachno | ~148 MB | moderní GM |

### Použití ve hrách

Výchozí mód je SF2/GM — pro většinu retro her stačí. Vyber v nastavení hry **General MIDI** nebo **Roland GS** na portu PicoGUS.

```bat
REM Workflow před GM/GS hrou:
MT32-PI.EXE -p 330 -g --gm-reset

REM Workflow před MT-32 hrou (jen pokud máš ROM na SD):
MT32-PI.EXE -p 330 -m --mt32-reset
```

---

## McCake WP32 (interní wavetable)

**Zařízení:** Serdaco WP32 McCake (mt32-pi, CM4)  
**Umístění:** Wavetable header na PicoGUS v2.0  
**Port:** 330h (v MPU profilech)  
**Aktivní v profilech:** MPU, MPUEMS  
**Výstup:** přes PicoGUS → CH 1+2 na mixpultu (sdílí s GUS)

### Ovládání z DOSu

Stejná utilita `MT32-PI.EXE` jako pro externí MT32-pi SF2, jen na jiném portu:

```bat
MT32-PI.EXE -p 330 -m     MT-32 mód
MT32-PI.EXE -p 330 -g     SF2/GM mód
MT32-PI.EXE -p 330 -s 0   soundfont č. 0
MT32-PI.EXE -p 330 -r     reboot McCake
```

Panel (Serdaco MT32Pi Drive Bay Panel 5.25") je příslušenství k McCake — **dosud nedoručen**. Po instalaci přidá fyzická tlačítka pro přepínání módů a OLED displej.

### Použití ve hrách

Aktivní pouze v profilech **MPU** a **MPUEMS**. PicoGUS běží v MPU-401 intelligent mode, McCake odpovídá na portu 330h. V nastavení hry vyber General MIDI nebo MT-32 na MIDI portu 330h. SoftMPU není potřeba — PicoGUS zvládá intelligent mode nativně.


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
C:\DRIVERS\PICOGUS\PGUSINIT.EXE /mode gus /mpuport 330 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1
```

### Reporting the defect to Serdaco

Description for support (serdashop.com/Contact or VOGONS user `dreamblaster`):

> X16GS digital noise/crackling when playing 2 or more notes simultaneously.
> Single notes play perfectly clean. Tested via USB-MIDI from modern PC,
> direct 3.5mm jack output, all soundbank slots, all presets.
> Problem is consistent and reproducible.
