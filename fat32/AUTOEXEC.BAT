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
REM -----------------------------------------------
REM Profile: ISOCD - NOEMS with virtual ISO CD-ROM
REM Use for: Running games from ISO images on D:\ISOS\
REM Physical Samsung CD-ROM NOT loaded - saves UMB space
REM To switch ISO at runtime: ISO D:\ISOS\GAME.ISO
REM Requires: C:\DRIVERS\SHSUCDX\SHSUCDHD.EXE + SHSUCDX.COM
REM Download: http://adoxa.altervista.org/shsucdx/ -> SHSUCD r3-7
REM -----------------------------------------------
:ISOCD
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90
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
:ISOCDEMS
LH C:\DRIVERS\UNISOUND\UNISOUND.COM /V70 /VF90
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
REM --- Virtual ISO CD-ROM ---
LH C:\DRIVERS\SHSUCDX\SHSUCDHD.EXE /F:D:\ISOS\DEFAULT.ISO
LH C:\DRIVERS\SHSUCDX\SHSUCDX.COM /D:SHSU-CDH /Q
LH C:\DRIVERS\CTMOUSE\CTMOUSE.EXE /R2
GOTO END

:BARE
GOTO END

:END
REM --- Norton Commander ---
NC







