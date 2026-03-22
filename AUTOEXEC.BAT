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
REM CT3900 semi-PnP: UNISOUND naprogramuje IRQ/DMA dle techto hodnot
REM Mozne hodnoty: IRQ 2/5/7/10, Low DMA 0/1/3, High DMA 5/6/7
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
REM --- AWE32 CT3900 inicializace hardware (UNISOUND) ---
REM Inicializuje: IRQ, DMA, I/O porty, OPL3, mixer
REM CT3900 semi-PnP: UNISOUND naprogramuje IRQ/DMA dle BLASTER promenne
REM /V70 = master volume 70 (range 0-100)
REM /VF90 = FM/OPL3 volume 90 - real Yamaha OPL3 chip (CT1747) na CT3900
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90

REM --- AWEUTIL - inicializace EMU8000 wavetable syntezatoru ---
REM UNISOUND NERESI EMU8000 - AWEUTIL je nutny pro AWE32 wavetable funkce
REM /S = inicializace EMU8000 dle BLASTER promenne (E620 = port EMU8000)
REM Nutny pro: hry s AWE32 podporou, MIDI emulaci GM/GS/MT-32
REM Soubory: C:\DRIVERS\SB16\AWEUTIL.COM + Synthgm.sbk + Synthgs.sbk + Synthmt.sbk
REM Rucni prepinani modu pred hrou:
REM   LH C:\DRIVERS\SB16\AWEUTIL.COM /EM:GM    <- General MIDI emulace
REM   LH C:\DRIVERS\SB16\AWEUTIL.COM /EM:GS    <- Roland GS emulace
REM   LH C:\DRIVERS\SB16\AWEUTIL.COM /EM:MT32  <- Roland MT-32 emulace
REM   C:\DRIVERS\SB16\AWEUTIL.COM /U           <- uvolnit z pameti (pred prepnutim modu)
REM Pozor: AWEUTIL /EM nepracuje s DOS extendery (DOS4GW, DOS32A)
C:\DRIVERS\SB16\AWEUTIL.COM /S

REM --- SoftMPU - intelligent mode MPU-401 emulace pro MT-32 hry ---
REM Nutny pro: Monkey Island 1, Sierra hry, Ultima Underworld
REM AWE32 podporuje pouze UART mode - SoftMPU prida intelligent mode
REM /MPU:330 = MPU-401 port (musi odpovidat P330 v BLASTER)
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
REM --- AWE32 CT3900 inicializace hardware (UNISOUND) ---
REM /V70 = master volume 70, /VF90 = FM/OPL3 volume 90
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90

REM --- AWEUTIL - inicializace EMU8000 wavetable syntezatoru ---
REM Pozor: AWEUTIL /EM:* NEFUNGUJE s DOS extendery (DOS4GW) - pouze /S init
C:\DRIVERS\SB16\AWEUTIL.COM /S

REM --- SoftMPU - intelligent mode MPU-401 emulace ---
REM /MPU:330 = MPU-401 port (musi odpovidat P330 v BLASTER)
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
